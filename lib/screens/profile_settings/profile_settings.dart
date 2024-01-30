import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/screens/profile_settings/personal_setting/personal_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'Edit_passwerd_screen.dart';
import 'account_setting_screen.dart';

class Profile_Settings extends StatefulWidget {

   Profile_Settings({Key? key}) : super(key: key);

  @override
  State<Profile_Settings> createState() => _Profile_SettingsState();
}

class _Profile_SettingsState extends State<Profile_Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context,'aman rrrrrr');
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
            Text('  Profile settings',
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

            commenlisttile('Account settings', 'Reset password', (){
              Get.to(() => Edit_Passwers_Screen());
            }),
            sizedboxheight(10.0),

            commenlisttile('Personal settings', 'Edit personal details', (){
              Get.to(() => Personal_Setting());
            })
          ],
        ),
      ),
    );
  }

  Widget commenlisttile(String _title,String _subtitle, Function action){
    return  ListTile(
      trailing: Icon(Icons.arrow_forward_ios_rounded),
      title: Text(_title.toString(),
        style: TextStyle(
            fontSize: 20,
            fontFamily: fontFamilyText,
            color: colorRichblack,
            fontWeight: fontWeight400,
            overflow: TextOverflow.ellipsis
        ),
        maxLines: 1,
      ),
      subtitle: Text(_subtitle.toString(),
        style: TextStyle(
            fontSize: 14,
            fontFamily: fontFamilyText,
            color: colorShadowBlue,
            fontWeight: fontWeight400,
            overflow: TextOverflow.ellipsis
        ),
        maxLines: 1,
      ),
      tileColor: colorWhite,
      textColor: colorRichblack,
      onTap: () => action() ,

    );
  }
}
