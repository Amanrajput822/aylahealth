import 'dart:convert';

import 'package:aylahealth/common/SharedPrefHelper.dart';
import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/screens/auth/login_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/api_common_fuction.dart';
import '../../common/check_screen.dart';
import '../../common/styles/Fluttertoast_internet.dart';
import '../../common/styles/showLoaderDialog_popup.dart';
import '../profile_settings/personal_setting/personal_setting_provider.dart';
import '../tabbar_screens/my_meals/calendar_evryday_json.dart';
import '../../models/auth model/logout_model.dart';
import '../auth/google_authentication.dart';
import '../food_natrition_settings/food_natrition_setting.dart';
import '../help_screen/help_screen.dart';
import '../notification_screen/notification_screen.dart';
import '../profile_settings/profile_settings.dart';
import '../subscription_screens/manageplane_screen.dart';
import 'package:http/http.dart' as http;

class Profile_screen extends StatefulWidget {
  const Profile_screen({Key? key}) : super(key: key);

  @override
  State<Profile_screen> createState() => _Profile_screenState();
}

class _Profile_screenState extends State<Profile_screen> {
  final plugin = FacebookLogin(debug: true);
  Future<void> _onPressedLogOutButton() async {
    await plugin.logOut();
  }

  var success, message;
  var tokanget;
  var user_name,user_email;

  Future<logout_model> logout_api() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokanget = prefs.getString('login_user_token');
      tokanget = tokanget!.replaceAll('"', '');
    });
    print(tokanget.toString());
    check().then((intenet) async {
      if (intenet) {
        // Internet Present Case
        showLoaderDialog_popup(context,"Log out...");

      } else {
        FlutterToast_Internet();
      }
    });

    var response = await http.post(
        Uri.parse(Endpoints.baseURL+Endpoints.logout),
        headers: {
          'Authorization': 'Bearer $tokanget',

        }
    );
    print(response.body.toString());
    success = (logout_model.fromJson(json.decode(response.body)).status);
    message = (logout_model.fromJson(json.decode(response.body)).message);
    print("success 123 ==${success}");
    if (success == 200) {
      //Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
        // the new route
        MaterialPageRoute(
          builder: (BuildContext context) => const LogIn(),
        ), (Route route) => false,
      );
      SharedPreferences prefs =  await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", false);
      prefs.remove("login_user_token");
      prefs.remove("login_user_name");
      prefs.remove("login_user_email");
      prefs.remove("login_user_name");
      prefs.remove("login_user_id");
      prefs.remove("user_login_time");

      SharedPrefHelper.userId = null;
      ///calendar json data remove function ///
      removeDataFromFile(DateTime.now().year.toString());
      ///
      await Authentication.signOut(context: context);

      FlutterToast_message(message);

      // Get.to(() => Pre_Question_Screen());
    } else {
      Navigator.pop(context);
      print('else==============');
      FlutterToast_message(message);
    }
    return logout_model.fromJson(json.decode(response.body));
  }


 Future<void> userdetails() async {
   SharedPreferences prefs =  await SharedPreferences.getInstance();
   setState(() {
     user_name = prefs.getString('login_user_name');
     user_name = user_name!.replaceAll('"', '');

     user_email = prefs.getString('login_user_email');
     user_email = user_email!.replaceAll('"', '');

     tokanget = prefs.getString('login_user_token');
     tokanget = tokanget!.replaceAll('"', '');
   });
 }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    userdetails();
    final uerdatamodal = Provider.of<userprofile_Provider>(context, listen: false);
    uerdatamodal.customer_ditels_api(context);

}
  @override
  Widget build(BuildContext context) {
   // userdetails();
    final uerdatamodal = Provider.of<userprofile_Provider>(context);
    return Scaffold(
      backgroundColor: colorWhite,
      body: Container(
        width: deviceWidth(context),
        height: deviceheight(context),
        padding: EdgeInsets.only(top: 70,
        left: 20,right: 20,bottom: 20),
        child: Stack(
          children: [
            Container(
              width: deviceWidth(context),
              height: deviceheight(context),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Image.asset('assets/appnamelogo.png',height: 34,width: 65,),
                         InkWell(
                             onTap: (){
                               Navigator.pop(context);
                             },
                             child: Icon(Icons.close)),
                       ],
                     ),
                    sizedboxheight(deviceheight(context,0.03)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,

                            backgroundColor: colorWhite,
                            child: SvgPicture.asset('assets/image/profileicon.svg')),
                       sizedboxwidth(10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            uerdatamodal.loading
                                ? Container(
                              child: Center(),
                            ) : Text(uerdatamodal.user_details_data!.custFirstname!=null?"${uerdatamodal.user_details_data!.custFirstname??""} ${uerdatamodal.user_details_data!.custLastname??""}":"User Name",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: fontFamilyText,
                                color: colorRichblack,
                                fontWeight: fontWeight700,
                                overflow: TextOverflow.ellipsis,
                                height:1.5
                              ),
                              maxLines: 1,
                            ),
                            Text('Upgrade membership',
                              style: TextStyle(
                                fontSize: 16,height: 1.5,
                                fontFamily: fontFamilyText,
                                color: colorShadowBlue,
                                fontWeight: fontWeight400,
                                  overflow: TextOverflow.ellipsis
                              ),
                              maxLines: 1,
                            ),
                          ],
                        )
                      ],
                    ),
                    sizedboxheight(deviceheight(context,0.03)),

                    topcommenlisttile('Profile Settings', 'assets/image/settings.svg', (){
                      Get.to(() => Profile_Settings());
                    }),
                    Divider(
                      thickness: 1,height: 1,
                      color: HexColor('#E9ECF1'),
                    ),

                    topcommenlisttile('Food & Nutrition Settings', 'assets/image/recipes.svg', (){
                      Get.to(() => Food_Nutrition_Settings());
                    }),

                    Divider(
                      thickness: 1,height: 1,
                      color: HexColor('#E9ECF1'),
                    ),

                    topcommenlisttile('Manage My Subscription', 'assets/image/subscription.svg', (){
                      Get.to(() => Manage_Plan_Screen());
                    }),

                    Divider(
                      thickness: 1,height: 1,
                      color: HexColor('#E9ECF1'),
                    ),

                     topcommenlisttile('Notifications', 'assets/image/notification.svg', (){
                    Get.to(() => Notifocation_Screen());
                    }),
                  ],
                ),
              ),
            ),
            Container(
              width: deviceWidth(context),
              height: deviceheight(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  ListTile(
                    leading: Icon(Icons.help_outline,color: colorPrimaryColor,),
                    title: Text('Help',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: fontFamilyText,
                        color: colorPrimaryColor,
                        fontWeight: fontWeight400,
                      ),),
                    tileColor: colorWhite,
                    textColor: colorRichblack,
                    onTap: (){
                      Get.to(() => Help_Screen());
                    },
                  ),
                  Divider(
                    thickness: 1,height: 1,
                    color: HexColor('#E9ECF1'),
                  ),
                  ListTile(
                    leading:Icon(Icons.logout,color: colorPrimaryColor),
                    title: Text('Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: fontFamilyText,
                        color: colorPrimaryColor,
                        fontWeight: fontWeight400,
                      ),),
                    tileColor: colorWhite,
                    textColor: colorRichblack,
                    onTap: (){
                      showAlertDialog( context);
                     // Get.to(() => Help_Screen());

                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Text('Are you sure you want to log out?',style:  TextStyle(
        fontSize: 20,
        fontFamily: fontFamilyText,
        color: colorBlack,
        fontWeight: fontWeight600,
      ),),

      actions: <Widget>[
        TextButton(
          onPressed: () {
            print("you choose no");
            Navigator.of(context).pop(false);
          },
          child: Text('No',style:  TextStyle(
            fontSize: 16,
            fontFamily: fontFamilyText,
            color: colorBluePigment,
            fontWeight: fontWeight600,
          ),),
        ),
        TextButton(
          onPressed: () async {
            logout_api();
          },
          child: Text('Yes',style:  TextStyle(
            fontSize: 16,
            fontFamily: fontFamilyText,
            color: colorBluePigment,
            fontWeight: fontWeight600,
          ),),
        ),
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  //  topcommenlisttile('Contact usn', 'Get in touch for support.', (){
  // Get.to(() => Contact_us_screen());
  // }),
  Widget topcommenlisttile(String _title,String iconimage, Function action){
    return  ListTile(
      leading: SvgPicture.asset(iconimage,color: colorRichblack),

      title: Text(_title.toString(),
        style: TextStyle(
            fontSize: 16,
            fontFamily: fontFamilyText,
            color: colorRichblack,
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
