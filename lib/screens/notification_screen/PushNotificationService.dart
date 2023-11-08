import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future initialize() async {
    await _fcm.subscribeToTopic('your_topic_name'); // Optional: Subscribe to a topic

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle a message when the app is in the foreground
      print("Message received while app is in the foreground: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle a message when the app is opened from a terminated state
      print("Message opened from terminated state: ${message.notification?.title}");
    });
  }
}
