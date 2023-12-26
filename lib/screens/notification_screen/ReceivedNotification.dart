import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import 'FirebaseNotifications.dart';


class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

class LocalNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@drawable/ic_launcher');

  static final IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (
        int id,
        String? title,
        String? body,
        String? payload,
        ) =>
        didReceiveLocalNotificationSubject.add(
          ReceivedNotification(
            id: id,
            title: title!,
            body: body!,
            payload: payload!,
          ),
        ),
  );

  static const MacOSInitializationSettings initializationSettingsMacOS =
  MacOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false);

  final InitializationSettings initializationSettings =
  InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);



  initialize() async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
          selectNotificationSubject.add(payload.toString());
        });

  }
  showNotification(RemoteMessage message) {
    Map<String, dynamic> data = message.data;
    if (data["body"] != null) {
      flutterLocalNotificationsPlugin.show(
        data.hashCode,
        data["title"],
        data["body"],
      //  payload: jsonEncode(message.data),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'id',
            'name',
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: IOSNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true),
        ),
      );
    }
  }
  // Future<void> showNotification(String title, var type, String body, int value) async {
  //   AndroidNotificationDetails androidPlatformChannelSpecifics =
  //   const AndroidNotificationDetails(
  //     'id',
  //     'name',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     playSound: true,
  //   );
  //   IOSNotificationDetails iosNotificationDetails =
  //   const IOSNotificationDetails(
  //     presentAlert: true,
  //     presentSound: true,
  //     presentBadge: true,
  //   );
  //
  //   NotificationDetails platformChannelSpecifics = NotificationDetails(
  //       android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);
  //   print('type ${type.data}');
  //   print('notification catch');
  //   await flutterLocalNotificationsPlugin.show(
  //       value, title, body, platformChannelSpecifics,
  //       payload: jsonEncode(type.data));
  // }

  void configureDidReceiveLocalNotificationSubject(context) {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      //context.watch<HomeViewModel>().getAlertNotificationList();
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(receivedNotification.title),
          content: Text(receivedNotification.body),

          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                notificationClick("${receivedNotification.payload}");
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((message) async {
      print("Message ${jsonDecode(message)}");
      await notificationClickLocal(jsonDecode(message));
    });
  }
}
