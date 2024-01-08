import 'dart:convert';
import 'dart:developer';

import 'package:aylahealth/DefaultFirebaseOptions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'FirebaseNotifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage remoteMessage) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationHandler.initialize();
 // await NotificationHandler.showLocalNotification(remoteMessage);
  log(remoteMessage.data.toString(), name: "Background Notification");

  ///TODO Handling Background Message Notification
}

@pragma('vm:entry-point')
void didReceiveBackgroundNotificationResponseCallback(
    NotificationResponse response) async {
  log(response.notificationResponseType.name,
      name: "onDidReceiveBackgroundNotificationResponse");
  log(response.payload ?? "Empty Payload",
      name: "onDidReceiveBackgroundNotificationResponse Payload");
  log(response.input ?? "Empty Input",
      name: "onDidReceiveBackgroundNotificationResponse Input");

  ///TODO Handling Background Message Notification
}

class NotificationHandler {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    const androidInitializationSettings =
    AndroidInitializationSettings("@mipmap/ic_launcher");
    const darwinInitializationSettings = DarwinInitializationSettings();
    InitializationSettings settings = const InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(settings,
        onDidReceiveBackgroundNotificationResponse:
        didReceiveBackgroundNotificationResponseCallback,
        onDidReceiveNotificationResponse: (response) {
          notificationClick(json.decode(response.payload!));
          log(response.notificationResponseType.name,
              name: "onDidReceiveNotificationResponse");
          log(response.payload ?? "Empty Payload",
              name: "onDidReceiveNotificationResponse Payload");
          log(response.input ?? "Empty Input",
              name: "onDidReceiveNotificationResponse Input");
        });
  }

  static Future<void> firebaseInit() async {
    NotificationSettings notificationSettings =
    await _messaging.requestPermission();
    log(notificationSettings.authorizationStatus.name,
        name: "Notification Permission");

    ///Whenever User Click On Background Notification App Is Terminated....Handle On Tap Through This Method!!
    _messaging.getInitialMessage().then((remoteMessage) {
      if (remoteMessage != null) {
        log("Notification Click Event On Background Application. Data ${remoteMessage.data}, Title ${remoteMessage.notification?.title}");
        notificationClickLocal( remoteMessage.data);
        ///ToDo Notification Handle On Click;
      }
    });

    ///Whenever Notification Coming And App Is Not Terminated And Open In Background Only For Show Notification..!!
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      log("On Message Notification Data ${remoteMessage.data}, Title ${remoteMessage.notification?.title}");
      showLocalNotification(remoteMessage);

      ///ToDo Notification Show On Coming From Firebase;
    });

    ///Whenever User Click On Background Notification App Is Not Terminated Working In Background....Handle On Tap Through This Method!!
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      log("Background App Notification Data ${remoteMessage.data}, Title ${remoteMessage.notification?.title}");
      notificationClickLocal( remoteMessage.data);
      ///ToDo Notification Handle On Click;
    });
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  // static Future<String> getToken() async {
  //   return await _messaging.getToken() ?? "";
  // }

  static Future<void> showLocalNotification(RemoteMessage remoteMessage) async {
    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails(
        'notifications', "Notification Channel");
    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    String title =
        remoteMessage.notification?.title ?? remoteMessage.data["title"];
    String body =
        remoteMessage.notification?.body ?? remoteMessage.data["body"];
    await _flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails,
        payload: jsonEncode(remoteMessage.toMap()));
  }
}
