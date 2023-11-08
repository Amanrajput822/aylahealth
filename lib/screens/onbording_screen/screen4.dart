import 'package:aylahealth/common/styles/const.dart';
import 'package:flutter/material.dart';

class Screen4 extends StatelessWidget {
  const Screen4({Key? key}) : super(key: key);

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
               sizedboxheight(deviceheight(context,0.05)),
                Text('Did you know?',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: fontFamilyText,
                    color: colorBlack,
                    fontWeight: fontWeight600,
                  ),
                  textAlign: TextAlign.center,
                ),
                sizedboxheight(deviceheight(context,0.02)),
                Text('Changing your eating habits all at once is the quickest way to fail!\n\n'
                    ' Take a long-term approach and focus your efforts on one aspect of your diet at a time.',
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
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
