import 'dart:async';

import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/screens/notification_screen/FirebaseNotifications.dart';
import 'package:aylahealth/screens/notification_screen/ReceivedNotification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/new_bottombar_screen/New_Bottombar_Screen.dart';
import 'home_screen.dart';

class Splesh extends StatefulWidget {
  static const String route = "/Splesh";
  const Splesh({Key? key}) : super(key: key);

  @override
  State<Splesh> createState() => _SpleshState();
}

class _SpleshState extends State<Splesh> {
  var status;

  getAuthToken() async {
    var token = await FirebaseMessaging.instance.getToken();
    print('Firebase Token Motivation $token');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firebase_token', token!);
  }

  @override
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    status = prefs.getBool('isLoggedIn') ?? false;
    Timer(
      const Duration(seconds: 3),
          () {
        // status ? Get.offAll(() => BottomNavBarPage()) : Get.offAll(() => IntroductionPage());
        status
            ? Get.offAll(() => const New_Bottombar_Screen())
            : Get.offAll(() => const HomeScreen());
      },
    );
    prefs.setBool(
      'user_login_time', true,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     // LocalNotification().configureDidReceiveLocalNotificationSubject(context);
     // LocalNotification().configureSelectNotificationSubject();
     // FirebaseNotifications().firebaseInitialization();
     LocalNotification().initialize();
    getAuthToken();
    getValuesSF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: deviceheight(context),
        width: deviceheight(context),
        child: Center(
          child: Hero(
            tag: 'Light_Mode_SecondaryLogo_Small',
            child: Image.asset('assets/image/Light_Mode_SecondaryLogo_Small.png',
              width: 185,height: 185,)
          ),
        ),
      ),
    );

  }
}
