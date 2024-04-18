const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendJudgeNotification = functions.firestore
    .document("users/{userId}")
    .onUpdate(async (change, context) => {
      const before = change.before.data();
      const after = change.after.data();

      if (before.applicationState !== after.applicationState) {
        const title = "FoodSense";
        const body = `Usted ha sido ${after.applicationState} como juez.`;

        const payload = {
          notification: {title, body},
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
