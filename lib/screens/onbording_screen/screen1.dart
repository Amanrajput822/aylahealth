import 'package:aylahealth/common/styles/const.dart';
import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: deviceheight(context),
        width: deviceWidth(context),
        color: colorWhite,
        padding: EdgeInsets.only(left: deviceWidth(context,0.2),right:  deviceWidth(context,0.2)),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Hi there!\n\nWe’d love to get to '
                    'know you.\n\nPlease tell us '
                    'more about yourself!',
                    style: TextStyle(
                      fontSize: 24,
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
