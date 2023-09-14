import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/screens/auth/login_screen.dart';
import 'package:aylahealth/screens/auth/signup_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:page_transition/page_transition.dart';

import '../../common/commonwidgets/button.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: deviceWidth(context),
        height: deviceheight(context),
        child: Stack(
          children: [
            Container(
              width: deviceWidth(context),
              height: deviceheight(context),
              child: Image.asset('assets/HEALTHYEATINGCLINIC-pewpewstudio-211119-72 1.png',
              fit: BoxFit.cover,),
            ),
            Container(
              width: deviceWidth(context),
              height: deviceheight(context),
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 // sizedboxheight(deviceheight(context, 0.08)),
                  Padding(
                    padding:  EdgeInsets.only(top:deviceheight(context, 0.06) ),
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                          child: SvgPicture.asset('assets/Logo.svg')),
                    ),
                  ),
                 // sizedboxheight(deviceheight(context, 0.45)),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text('Bite-sized nutrition learning, habit building and meal planning.',
                          style: TextStyle(
                              fontSize: 21,
                              fontFamily: fontFamilyText,
                              color: colorWhite,
                              fontWeight: fontWeight600,
                              height: 1.3
                          ),
                        ),
                        sizedboxheight(15.0),
                        signupBtn(context),
                        sizedboxheight(5.0),
                        Divider(
                          color: colorWhite,
                          thickness: 1.5,
                        ),
                        sizedboxheight(5.0),
                        Text('Already have an account?',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: fontFamilyText,
                              color: colorWhite,
                              fontWeight: fontWeight600
                          ),
                        ),
                        sizedboxheight(5.0),
                        signinBtn(context),
                        sizedboxheight(10.0),
                      ],
                    ),
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
  Widget signupBtn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Sign up',
        textColor: colorPrimaryColor,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor: colorLightYellow,
        onPressed: () {
         // Get.to(() => Signup_type());
          Navigator.push(
            context,
            PageTransition(duration:Duration(milliseconds: 400) ,
              type: PageTransitionType.bottomToTop,
              child: Signup_type(),
            ),
          );
        },
      ),
    );
  }
  Widget signinBtn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Login',
        textColor: colorPrimaryColor,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor: colorWhite,
        onPressed: () {
          // Get.to(() => LogIn())
           Navigator.push(
             context,
             PageTransition(duration:const Duration(milliseconds: 500) ,
               type: PageTransitionType.bottomToTop,
               child: const LogIn(),
             ),
           );
        },
      ),
    );
  }
}
