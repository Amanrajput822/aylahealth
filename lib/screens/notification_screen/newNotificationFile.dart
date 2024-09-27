import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aylahealth/DefaultFirebaseOptions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../../common/new_bottombar_screen/Bottom_NavBar_Provider.dart';
import '../../common/new_bottombar_screen/New_Bottombar_Screen.dart';
import '../tabbar_screens/modules/module_description_screen/module_description_screen.dart';
import '../tabbar_screens/modules/modules_screen/modules_screen_provider.dart';
import '../tabbar_screens/support_screen/message/chat/chat_list.dart';
import 'FirebaseNotifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage remoteMessage) async {
  log("Background Notification Payload: ${jsonEncode(remoteMessage.data)}", name: "Background Payload");

  print('Background Notification');
  print(remoteMessage.data.toString());

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await NotificationHandler.initialize();
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

          switch (json.decode(response.payload!)['data']['action']) {
            case '1':
              notificationClick(json.decode(response.payload!));
              break;

            case '2':
              {
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  testContext!,
                  settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                  screen:  ChatListScreen(),
                );
              }
              break;
            case '3':
              handleModuleLibraryRefresh();
              notificationClick(json.decode(response.payload!));
              break;


          }
          log(response.notificationResponseType.name,
              name: "onDidReceiveNotificationResponse");
          log(response.payload ?? "Empty Payload",
              name: "onDidReceiveNotificationResponse Payload");
          log(response.input ?? "Empty Input",
              name: "onDidReceiveNotificationResponse Input");
        });
  }

  static Future<void> firebaseInit() async {
    print('firebaseInit');

    NotificationSettings notificationSettings =
     await _messaging.requestPermission();
    log(notificationSettings.authorizationStatus.name,
        name: "Notification Permission");
    print('Notification Permission');
    print(notificationSettings.authorizationStatus.name);
    ///Whenever User Click On Background Notification App Is Terminated....Handle On Tap Through This Method!!
    _messaging.getInitialMessage().then((remoteMessage) {
      print('Notification Click Event On Background Application. Data');
      if (remoteMessage != null) {
        log("Notification Click Event On Background Application. Data ${remoteMessage.data}, Title ${remoteMessage.notification?.title}");
        handleNotificationClick(remoteMessage);

        ///ToDo Notification Handle On Click;
      }
    });

    ///Whenever Notification Coming And App Is Not Terminated And Open In Background Only For Show Notification..!!
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      log("On Message Notification Data ${jsonEncode(remoteMessage.data)}", name: "OnMessage Payload");

      final BottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(testContext!, listen: false);
      print('On Message Notification Data');
      log("On Message Notification Data "
          "data: ${remoteMessage.data},"
          " Title: ${remoteMessage.notification?.title}"
          " body: ${remoteMessage.notification?.body}"
          " notification: ${remoteMessage.notification}"
          " action: ${remoteMessage.data['action']}"
      );
      try {
       // showLocalNotification(remoteMessage);
        if(remoteMessage.data["action"] == "2"){
          if(BottomNavBarProviderModel.chatMessages){}
          else{
            showLocalNotification(remoteMessage);
          }
        }else if(remoteMessage.data["action"] == "1"){
          showLocalNotification(remoteMessage);
        }else if(remoteMessage.data["action"] == "3"){
          handleModuleLibraryRefresh();
          showLocalNotification(remoteMessage);
        }else{
          showLocalNotification(remoteMessage);

        }
      } catch (_) {
        log("Error Catch $_");
      }



    //  showLocalNotification(remoteMessage);
      ///ToDo Notification Show On Coming From Firebase;
    });

    ///Whenever User Click On Background Notification App Is Not Terminated Working In Background....Handle On Tap Through This Method!!
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      log("Background App Notification Data ${jsonEncode(remoteMessage.data)}", name: "onMessageOpenedApp Payload");

      print('Background App Notification Data');
      print(remoteMessage.data);
      log("Background App Notification Data ${remoteMessage.data}, Title ${remoteMessage.notification?.title}");
      handleNotificationClick(remoteMessage);
      ///ToDo Notification Handle On Click;
    });
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
  //
  // static Future<void> requestNotificationPermission() async {
  //   NotificationSettings notificationSettings =
  //   await _messaging.requestPermission();
  //   log(notificationSettings.authorizationStatus.name,
  //       name: "Notification Permission");
  //   print('Notification Permission');
  //   print(notificationSettings.authorizationStatus.name);
  // }

  static Future<String> getToken() async {
    try {
      // if (Platform.isIOS) {
      //   String? apn = await _messaging.getAPNSToken();
      // }
      print(_messaging.getToken().toString());
      return await _messaging.getToken() ?? "";
    } catch (_, st) {
      log('Stack Trace $st');
      return "";
    }
  }


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
        0, title,body, notificationDetails,
        payload: jsonEncode(remoteMessage.toMap()));
  }

  static void handleNotificationClick(RemoteMessage remoteMessage) {
    log("Notification Click Event. Data ${remoteMessage.data}, Title ${remoteMessage.notification?.title}");

    switch (remoteMessage.data['action']) {
      case '1':
        notificationClickLocal(remoteMessage.data);
        break;

      case '2':
        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
          testContext!,
          settings: const RouteSettings(name: "/Recipes_Description_Screen"),
          screen:  ChatListScreen(),
        );
        break;
      case '3':
       // handleModuleLibraryRefresh();
        notificationClickLocal(remoteMessage.data);
        break;
    }
  }
  static void handleModuleLibraryRefresh() {
    final modulesProviderData = Provider.of<ModulesScreenProvider>(testContext!, listen: false);
    modulesProviderData.get_moduleLibrary_api();
  }
}
