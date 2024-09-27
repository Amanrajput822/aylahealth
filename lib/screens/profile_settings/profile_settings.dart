import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/screens/profile_settings/personal_setting/personal_setting.dart';
import 'package:aylahealth/screens/profile_settings/personal_setting/personal_setting_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

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
    final uerdatamodal = Provider.of<userprofile_Provider>(context);

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

        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('  Profile Settings',
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
                  }),
                  sizedboxheight(10.0),

                  // uerdatamodal.loading1?Center(child: CircularProgressIndicator()): commenlisttile('Delete my account', '', (){
                  //   deleteAccount_dialog();
                  // })
                ],
              ),
            ),
            Positioned(
                bottom: 40,
                child: Container(
                    width: deviceWidth(context),
                    child: Center(
                        child: TextButton(child: Text("Delete my account",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: fontFamilyText,
                              color: colorBluePigment,
                              fontWeight: fontWeight400,
                              overflow: TextOverflow.ellipsis,
                            decoration: TextDecoration.underline,
                          ),
                        ),onPressed: (){
                          deleteAccount_dialog();
                        },))))
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
            fontSize: 16,
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
  void deleteAccount_dialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(

            actions: [
              CupertinoDialogAction(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: fontFamilyText,
                  color: colorBluePigment,
                  fontWeight: fontWeight900,
                ),)),
              CupertinoDialogAction(onPressed: (){
                final uerdatamodal = Provider.of<userprofile_Provider>(context, listen: false);
                uerdatamodal.deleteCustomer_api(context);
               // Navigator.pop(context);
              }, child: Text("Confirm",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: fontFamilyText,
                  color: colorBluePigment,
                  fontWeight: fontWeight900,
                ),)),
            ],
            content: Text("Deleting your account will permanently remove all associated data,"
                " including your meal plans, shopping lists, modules, and profile details."
                " This information cannot be recovered once deleted."
                " Please click 'Confirm' if you wish to proceed with deleting your account.",
              style: TextStyle(
                fontSize: 14,
                fontFamily: fontFamilyText,
                color: colorRichblack,
                fontWeight: fontWeight400,
              ),),
          );
        });
  }
}
