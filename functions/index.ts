import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as firestore from '@google-cloud/firestore';

admin.initializeApp();
const db = admin.firestore();

export const onMessageAdded = functions.firestore
  .document('users/{userId}/messages/{messageId}')
  .onCreate(async (snap, context) => {
    const message = snap.data();
    const recipientId = message.recipientId;

    // Fetch the recipient's FCM token
    const recipientDoc = await db.collection('users').doc(recipientId).get();
    const recipientData = recipientDoc.data();
    const fcmToken = recipientData.fcmToken;

    // Send a notification to the recipient
    const messagePayload = {
      notification: {
        title: 'New message',
        body: message.text,
      },
      token: fcmToken,
    };

    admin.messaging().send(messagePayload);
  });