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
          return; // Skip this iteration since the FCM token is missing
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

        // Send Email
        try {
          await mailTransport.sendMail(emailOptions);
          console.log("Email sent to:", judge.email);
        } catch (error) {
          console.error("Failed to send email:", error);
        }

        // Send Push Notification
        try {
          await admin.messaging().send(pushNotification);
          console.log("Push notification sent to:", judge.email);
        } catch (error) {
          console.error("Failed to send push notification:", error);
        }

        // Update judge state
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
