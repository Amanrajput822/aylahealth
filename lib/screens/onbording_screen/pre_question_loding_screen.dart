import 'dart:async';

import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/screens/onbording_screen/pagination_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Pre_Question_Screen extends StatefulWidget {
  const Pre_Question_Screen({Key? key}) : super(key: key);

  @override
  State<Pre_Question_Screen> createState() => _Pre_Question_ScreenState();
}

class _Pre_Question_ScreenState extends State<Pre_Question_Screen> {
  @override
  getValuesSF() async {
    Timer(
      Duration(seconds: 3),
          () {
        Get.off(() => Pagination_screen());

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
          child:Image.asset('assets/image/Light_Mode_SecondaryLogo_Small.png',width: 185,height: 185,) ,
        ),
      ),
    );
  }
}
