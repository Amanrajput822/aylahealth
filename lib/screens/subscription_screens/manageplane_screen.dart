import 'package:flutter/material.dart';

import '../../common/commonwidgets/button.dart';
import '../../common/styles/const.dart';

class Manage_Plan_Screen extends StatefulWidget {
  const Manage_Plan_Screen({Key? key}) : super(key: key);

  @override
  State<Manage_Plan_Screen> createState() => _Manage_Plan_ScreenState();
}

class _Manage_Plan_ScreenState extends State<Manage_Plan_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new,color: colorRichblack,),
        ),
      ),
      body: Container(
        height: deviceheight(context),
        width: deviceWidth(context),
        padding: EdgeInsets.only(left: 15,right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manage My Subscription',
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: fontFamilyText,
                  color: colorPrimaryColor,
                  fontWeight: fontWeight600,
                  overflow: TextOverflow.ellipsis
              ),
              maxLines: 1,
            ),
            sizedboxheight(20.0),
            Text('Current subscription:',
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: fontFamilyText,
                  color: colorPrimaryColor,
                  fontWeight: fontWeight400,
              ),
            ),
            Text('Free level',
              style: TextStyle(
                fontSize: 16,
                fontFamily: fontFamilyText,
                color: colorPrimaryColor,
                fontWeight: fontWeight400,
              ),),
              Text('Includes recipes and introductory modules.',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: fontFamilyText,
                  color: colorShadowBlue,
                  fontWeight: fontWeight400,
                ),
            ),
            sizedboxheight(20.0),
            planupgradBtn(context),
            sizedboxheight(20.0),
            cancelplanBtn(context)
          ],
        ),
      ),
    );
  }
  Widget planupgradBtn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Upgrade to premium',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor: colorEnabledButton,
        onPressed: () {
         // Get.to(() => Pre_Question_Screen());
        },
      ),
    );
  }
  Widget cancelplanBtn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Cancel subscription',
        textColor: colorBluePigment,
        borderColor: colorBluePigment,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor: colorWhite,
        onPressed: () {
          // Get.to(() => Pre_Question_Screen());
        },
      ),
    );
  }
}
