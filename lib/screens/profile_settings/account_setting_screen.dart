import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../common/formtextfield/mytextfield.dart';
import '../../common/styles/const.dart';
import 'Edit_passwerd_screen.dart';

class Account_Setting_Screen extends StatefulWidget {
  var user_email;
   Account_Setting_Screen({Key? key,this.user_email}) : super(key: key);

  @override
  State<Account_Setting_Screen> createState() => _Account_Setting_ScreenState();
}

class _Account_Setting_ScreenState extends State<Account_Setting_Screen> {
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
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Account settings',
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: fontFamilyText,
                      color: colorPrimaryColor,
                      fontWeight: fontWeight600,
                      overflow: TextOverflow.ellipsis
                  ),
                  maxLines: 1,
                ),
                SvgPicture.asset('assets/image/edit 1.svg')
              ],
            ),
            sizedboxheight(20.0),

            // hedingcontainer('Email'),
            // sizedboxheight(5.0),
            // feildcontainer(widget.user_email??'email address'),
            // sizedboxheight(15.0),

            hedingcontainer('Password'),
            sizedboxheight(5.0),
            feildcontainer('Reset password '),
          ],
        ),
      ),
    );
  }
 Widget feildcontainer(title){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: HexColor('#F6F8F9')
      ),
      padding: EdgeInsets.all(10),
      width: deviceWidth(context),
      child: InkWell(
        onTap: (){
          Get.to(() => Edit_Passwers_Screen());
        },
        child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title.toString(),
              style: TextStyle(
                fontSize: 16,
                fontFamily: fontFamilyText,
                color: HexColor('#79879C'),
                fontWeight: fontWeight400,
              ),
            ),
            Icon(Icons.arrow_forward_ios,color: HexColor('#79879C'),)
          ],
        ),
      ),
    );
 }
  Widget hedingcontainer(title){
    return Text(title.toString(),
      style: TextStyle(
        fontSize: 14,
        fontFamily: fontFamilyText,
        color: colorRichblack,
        fontWeight: fontWeight400,
      ),
    );
  }
}
