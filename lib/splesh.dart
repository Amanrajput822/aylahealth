import 'dart:async';

import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/screens/onbording_screen/pagination_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  @override
  var status;
  getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    status = prefs.getBool('isLoggedIn') ?? false;

    Timer(
      Duration(seconds: 3),
          () {
        // status ? Get.offAll(() => BottomNavBarPage()) : Get.offAll(() => IntroductionPage());
        status
            ? Get.offAll(() => New_Bottombar_Screen())
            : Get.offAll(() => HomeScreen());
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValuesSF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: deviceheight(context),
        width: deviceWidth(context),
        child: Center(
          child:Image.asset('assets/image/Light_Mode_SecondaryLogo_Small 1.png',width: 185,height: 185,) ,
        ),
      ),
    );
  }
}
