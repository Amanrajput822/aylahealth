
import 'package:aylahealth/screens/notification_screen/newNotificationFile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

import 'DefaultFirebaseOptions.dart';
import 'common/SharedPrefHelper.dart';
import 'myapp.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   // await FlutterInappPurchase.instance.initialize();
  await Firebase.initializeApp();
  await SharedPrefHelper.init();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//  NotificationHandler.firebaseInit();
 // NotificationHandler.initialize();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(const MyApp(),);
}



