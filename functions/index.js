const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const nodemailer = require("nodemailer");

const mailTransport = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: functions.config().email.user,
    pass: functions.config().email.pass,
  },
});

exports.resendInvitationsOnCommand = functions.firestore
    .document("commands/{commandId}")
    .onUpdate(async (change, context) => {
      const commandData = change.after.data();
      if (!commandData.resendInvitations) {
        return null;
      }

      const eventSnapshot = await admin.firestore().collection("events").doc(commandData.eventId).get();
      const event = eventSnapshot.data();

      if (!event || !event.eventJudges) {
        console.error("Event not found or no judges associated with it.");
        return null;
      }

      const promises = event.eventJudges.filter((judge) => judge.state === "invited").map(async (judge) => {
        // Fetch the latest fcmToken from the Judge model
        const judgeSnapshot = await admin.firestore().collection("users").doc(judge.id).get();
        const judgeData = judgeSnapshot.data();

        if (!judgeData || !judgeData.fcmToken) {
          console.error("Missing fcmToken for judge:", judge.email);
          return;
        }

        const emailOptions = {
          from: `FoodSense <${functions.config().email.user}>`,
          to: judge.email,
          subject: `Recordatorio: Has sido seleccionado como juez para el evento: ${event.name}!`,
          html: `<h1>Felicidades, ${judge.name}!</h1>
                 <p>Has sido seleccionado como juez para el evento: <strong>${event.name}</strong>.</p>
                 <p>Fecha del evento: <strong>${event.date}</strong>.</p>
                 <p>Revisa más detalles en la sección de invitaciones de la aplicación.</p>`,
        };

        const pushNotification = {
          notification: {
            title: `Evento ${event.name}`,
            body: `Has sido seleccionado como juez para el evento: ${event.name}.`,
          },
          token: judgeData.fcmToken,
          data: {
            click_action: "FLUTTER_NOTIFICATION_CLICK",
            status: "selected",
          },
        };

        try {
          await mailTransport.sendMail(emailOptions);
          console.log("Email sent to:", judge.email);
          await admin.messaging().send(pushNotification);
          console.log("Push notification sent to:", judge.email);
        } catch (error) {
          console.error("Failed to send notification:", error);
        }
      });

      try {
        await Promise.all(promises);
        console.log("All invitations resent successfully.");
        // Optionally reset the command
        await change.after.ref.update({resendInvitations: false});
        return {result: "Invitations resent to all invited judges."};
      } catch (error) {
        console.error("Failed to resend invitations:", error);
        throw new functions.https.HttpsError("internal", "Failed to resend invitations.");
      }
    });

exports.sendJudgeNotification = functions.firestore
    .document("users/{userId}")
    .onUpdate(async (change, context) => {
      const before = change.before.data();
      const after = change.after.data();

      if (before.applicationState !== after.applicationState) {
        const payload = {
          notification: {
            title: "FoodSense",
            body: `Usted ha sido ${after.applicationState} como juez.`,
          },
          token: after.fcmToken,
          data: {
            click_action: "FLUTTER_NOTIFICATION_CLICK",
            status: after.applicationState,
          },
        };

        try {
          await admin.messaging().send(payload);
          console.log("Notification sent successfully");
        } catch (error) {
          console.error("Error sending notification:", error);
        }
      }
    });

exports.sendEmailAndPushNotification = functions.firestore
    .document("events/{eventId}")
    .onUpdate(async (change, context) => {
      const data = change.after.data();
      const eventName = data.name;
      const eventDate = data.date;
      const eventJudges = data.eventJudges;
      let updatesApplied = false;

      if (eventJudges.length === 0) {
        console.log("No judges available");
        return null;
      }

      const notificationPromises = eventJudges.filter((judge) => judge.state === "selected").map(async (judge) => {
        if (!judge.fcmToken) {
          console.error("Missing FCM token for judge:", judge.email);
          return;
        }

        const emailOptions = {
          from: `FoodSense <${functions.config().email.user}>`,
          to: judge.email,
          subject: `Has sido seleccionado como juez para el evento: ${eventName}!`,
          html: `<h1>Felicidades, ${judge.name}!</h1>
                       <p>Has sido seleccionado como juez para el evento: <strong>${eventName}</strong>.</p>
                       <p>Fecha del evento: <strong>${eventDate}</strong>.</p>
                       <p>Revisa más detalles en la sección de invitaciones de la aplicación.</p>`,
        };

        const pushNotification = {
          notification: {
            title: `Evento ${eventName}`,
            body: `Has sido seleccionado como juez para el evento: ${eventName}.`,
          },
          token: judge.fcmToken,
          data: {
            click_action: "FLUTTER_NOTIFICATION_CLICK",
            status: "selected",
          },
        };


        try {
          await mailTransport.sendMail(emailOptions);
          console.log("Email sent to:", judge.email);
        } catch (error) {
          console.error("Failed to send email:", error);
        }


        try {
          await admin.messaging().send(pushNotification);
          console.log("Push notification sent to:", judge.email);
        } catch (error) {
          console.error("Failed to send push notification:", error);
        }


        const judgeIndex = eventJudges.findIndex((j) => j.email === judge.email);
        if (judgeIndex !== -1) {
          eventJudges[judgeIndex] = {...eventJudges[judgeIndex], state: "invited"};
          updatesApplied = true;
        }
      });

      await Promise.all(notificationPromises);

      if (updatesApplied) {
        await admin.firestore().collection("events").doc(context.params.eventId).update({
          eventJudges: eventJudges,
        });
      }
    });
