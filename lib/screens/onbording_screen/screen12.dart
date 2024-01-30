import 'package:aylahealth/common/styles/const.dart';
import 'package:flutter/material.dart';

class Screen12 extends StatelessWidget {
  const Screen12({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: Container(
        height: deviceheight(context),
        width: deviceWidth(context),
        padding: EdgeInsets.only(left: deviceWidth(context,0.15),right: deviceWidth(context,0.15)),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/image/Light_Mode_SecondaryLogo_Small.png',width: 185,height: 185,),
                sizedboxheight(deviceheight(context,0.08)),
                Text('Make small, consistent changes.',
                  style: TextStyle(
                    fontSize: 24,
                    height: 1.5,
                    fontFamily: fontFamilyText,
                    color: colorBlack,
                    fontWeight: fontWeight600,
                  ),
                  textAlign: TextAlign.center,
                ),
                sizedboxheight(deviceheight(context,0.02)),
                Text('Your health is not a destination.\n\n Your health is the result of small, daily habits, behaviours and routines.',
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    fontFamily: fontFamilyText,
                    color: colorBlack,
                    fontWeight: fontWeight400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
