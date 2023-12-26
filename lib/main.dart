
import 'package:aylahealth/screens/notification_screen/FirebaseNotifications.dart';
import 'package:aylahealth/screens/notification_screen/ReceivedNotification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'DefaultFirebaseOptions.dart';
import 'common/SharedPrefHelper.dart';
import 'myapp.dart';


final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPrefHelper.init();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(const MyApp(),);
}

Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  await notificationClick(message);
}

