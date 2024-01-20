
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'DefaultFirebaseOptions.dart';
import 'common/SharedPrefHelper.dart';
import 'myapp.dart';


final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPrefHelper.init();
  // await NotificationHandler.initialize();
  // await NotificationHandler.firebaseInit();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(const MyApp(),);
}

// Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
//
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await LocalNotification().initialize();
//   await LocalNotification().showNotificationIOS(message);
// }



// Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//
//   //await LocalNotification().showNotificationIOS(message);
//   await notificationClick(message);
// }



