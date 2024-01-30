import 'package:aylahealth/common/styles/const.dart';
import 'package:flutter/material.dart';

class Screen14 extends StatelessWidget {
  const Screen14({Key? key}) : super(key: key);

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
                sizedboxheight(deviceheight(context,0.1)),
                Text('Preparing something great for you.',
                  style: TextStyle(
                    fontSize: 24,
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
