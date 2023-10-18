import 'dart:convert';
import 'dart:io';

import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/screens/auth/signup_type.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/SharedPrefHelper.dart';
import '../../common/api_common_fuction.dart';
import '../../common/check_screen.dart';
import '../../common/commonwidgets/button.dart';
import '../../common/formtextfield/mytextfield.dart';
import '../../common/formtextfield/validations_field.dart';
import '../../common/new_bottombar_screen/New_Bottombar_Screen.dart';
import '../../common/styles/Fluttertoast_internet.dart';
import '../../common/styles/showLoaderDialog_popup.dart';
import '../../models/auth model/user_login_model.dart';
import '../onbording_screen/pre_question_loding_screen.dart';
import 'forgot_password_screens/forgotpassword_screen.dart';
import 'package:http/http.dart' as http;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get_navigation/src/extension_navigation.dart';


class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController txt_email = TextEditingController();
  TextEditingController txt_pass = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  
  bool pass_show = true;
  int? field1 = 0;
  int? field2 = 0;
  String? divece_type;


  var success, message, id, email;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    type_check();
  }

  void type_check(){
    if (Platform.isIOS) {
      divece_type= '2';

    } else if(Platform.isAndroid)  {
      divece_type= '1';

    }
   else{
      divece_type= '1';
    }
  }

  Future<user_login_model> signin() async {

    // Or, use a predicate getter.

    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        showLoaderDialog_popup(context,"Sign In...");
      } else {
        FlutterToast_Internet();
      }
    });

    print(toMap());
    var response = await http.post(
      Uri.parse(Endpoints.baseURL+Endpoints.Login),
      body: toMap(),
    );
print(response.body.toString());
    success = (user_login_model.fromJson(json.decode(response.body)).status);
    message = (user_login_model.fromJson(json.decode(response.body)).message);
    print("success 123 ==${success??""}");
    if (success == 200) {
      if (success == 200) {
        Navigator.pop(context);

        final user = user_login_model.fromJson(json.decode(response.body)).data!;
        FlutterToast_message(message??"");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);

        // SharedPrefHelper.authToken = user.accessToken ?? "";

        prefs.setString(
          'login_user_id',
          json.encode(
            user_login_model.fromJson(json.decode(response.body)).data!.custId ?? '',
          ),
        );
        prefs.setString(
          'login_user_name',
        (  "${json.encode(
            user_login_model.fromJson(json.decode(response.body))
            .data!
            .custFirstname ?? '',
    )}""\t""${json.encode(
            user_login_model.fromJson(json.decode(response.body))
            .data!
            .custLastname ?? '',
    )}")
        );
        prefs.setString(
          'login_user_email',
          json.encode(
            user_login_model.fromJson(json.decode(response.body)).data!.custEmail ?? '',
          ),
        );
        prefs.setString(
          'login_user_token',
          json.encode(
            user_login_model.fromJson(json.decode(response.body)).data!.accessToken ?? '',
          ),
        );
        prefs.setString(
          'login_user_profilepic',
          json.encode(
            user_login_model.fromJson(json.decode(response.body)).data!.image ?? '',
          ),
        );

        prefs.setBool(
          'user_login_time',
           true,
        );
        SharedPrefHelper.userId = int.tryParse(user.custId.toString());
        SharedPrefHelper.name =  "${user.custFirstname}""\t""${user.custLastname}";
        SharedPrefHelper.email = user.custEmail ?? "";
        SharedPrefHelper.authToken = user.accessToken ?? "";

        Get.offAll(() => New_Bottombar_Screen());
        txt_email.clear();
        txt_pass.clear();
        FlutterToast_message(message??"");
      }
    } else {
      Navigator.pop(context);
      error_dialog(message??"");
    }
    return user_login_model.fromJson(json.decode(response.body));
  }




  void error_dialog(message){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Error", style: TextStyle(
              fontSize: 20,
              fontFamily: fontFamilyText,
              color: colorBlack,
              fontWeight: fontWeight600,
            ),),
            actions: [
              CupertinoDialogAction(onPressed: (){
                Navigator.pop(context);
              }, child: Text("OK",
                style: TextStyle(
                fontSize: 18,
                fontFamily: fontFamilyText,
                color: colorBluePigment,
                fontWeight: fontWeight900,
              ),)),

            ],
            content: Text(message.toString(),
              style: TextStyle(
                fontSize: 14,
                fontFamily: fontFamilyText,
                color: colorRichblack,
                fontWeight: fontWeight400,
              ),),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBlizzardBlue,
      body: Form(
        key: formkey,
        child: Container(
          height: deviceheight(context),
          width: deviceWidth(context),
          child: SingleChildScrollView(
            child: Column(
              children: [
                sizedboxheight(deviceheight(context, 0.15)),
                Container(
                  height: deviceheight(context, 0.1),
                  child: Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset('assets/Logo (1).svg')),
                ),
                sizedboxheight(deviceheight(context, 0.05)),
             Container(
               height: deviceheight(context, 0.7),
               width: deviceWidth(context),
               decoration: BoxDecoration(
                 borderRadius: const BorderRadius.only(
                   topLeft: Radius.circular(20),
                   topRight: Radius.circular(20),
                 ),
                 color: colorWhite
               ),
               padding: EdgeInsets.all(15),
               child: SingleChildScrollView(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     sizedboxheight(deviceheight(context, 0.02)),
                     Text('Welcome back.',
                       style: TextStyle(
                         fontSize: 28,
                         fontFamily: fontFamilyText,
                         color: colorPrimaryColor,
                         fontWeight: fontWeight700,
                       ),
                     ),
                     sizedboxheight(15.0),
                     Text('Login',
                       style: TextStyle(
                         fontSize: 20,
                         fontFamily: fontFamilyText,
                         color: colorTextFieldHadingText,
                         fontWeight: fontWeight600,
                       ),
                     ),
                     sizedboxheight(deviceheight(context,0.01)),

                     emailfield(),

                     sizedboxheight(deviceheight(context,0.02)),
                     passwordfield(),
                     sizedboxheight(deviceheight(context,0.02)),
                     signinBtn(context),
                     sizedboxheight(deviceheight(context,0.01)),
                     Align(
                       alignment: Alignment.bottomRight,
                       child: InkWell(
                         onTap: (){
                           Get.to(() => Forgotpass_screen());
                         },
                         child: Text('Forgot password',
                           style: TextStyle(
                             fontSize: 14,
                             fontFamily: fontFamilyText,
                             color: colorShadowBlue,
                             fontWeight: fontWeight400,
                           ),
                         ),
                       ),
                     ),
                     sizedboxheight(deviceheight(context,0.025)),
                     Align(
                       alignment: Alignment.center,
                       child:RichText(
                         text:  TextSpan(
                           text: 'Don’t have an account? ',
                           style: TextStyle(
                             fontSize: 14,
                             fontFamily: fontFamilyText,
                             color: colorShadowBlue,
                             fontWeight: fontWeight400,
                           ),
                           children: <TextSpan>[
                              TextSpan(
                                 text: 'Sign up',
                                 style:  TextStyle(
                                   fontSize: 14,
                                   fontFamily: fontFamilyText,
                                   color: colorRichblack,
                                   fontWeight: fontWeight400,
                                 ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {

                                      Navigator.push(
                                        context,
                                        PageTransition(duration:Duration(milliseconds: 400) ,
                                          type: PageTransitionType.bottomToTop,
                                          child: Signup_type(),
                                        ),
                                      );
                                      //Code to launch your URL
                                    }
                              ),
                           ],
                         ),
                       )


                     ),

                     sizedboxheight(deviceheight(context,0.1)),
                    Align(
                      alignment:Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Terms of use',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: fontFamilyText,
                              color: colorShadowBlue,
                              fontWeight: fontWeight400,
                            ),
                          ),
                          Text('Privacy & cookies',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: fontFamilyText,
                              color: colorShadowBlue,
                              fontWeight: fontWeight400,
                            ),
                          )
                        ],
                      ),
                    )
                   ],
                 ),
               ),
             )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget signinBtn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Login',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor: ((field1 !=0 && field2 !=0)? colorEnabledButton:colorDisabledButton),
        onPressed: () {
          if(field1 !=0 && field2 !=0){
            if (formkey.currentState!.validate()) {
              signin();
            } else {
              // model.toggleautovalidate();
            }

           // Get.to(() => Pre_Question_Screen());
          }

        },
      ),
    );
  }
  Widget emailfield() {
    return  Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            inputHeaderName: 'Email',
            // key: Key("email1"),
           // floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: 'Email',
            hintText: 'Email address',

            controller: txt_email,

            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            autofillHints: [AutofillHints.email],
            textInputAction: TextInputAction.next,
            keyBoardType: TextInputType.emailAddress,
            validatorFieldValue: 'email',
            onChanged: (val){
              setState(() {
                print(val.length);
                field1 = val.length;
              });
            },
            validator:validateEmailField,
          );

        },
      ),
    );
  }
  Widget passwordfield() {
    return Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            inputHeaderName: 'Password',
            // key: Key("email1"),
           // floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: 'Password',
            hintText: 'Enter your password',

            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            obsecureText: pass_show,
            suffixIcon: TextButton(
                onPressed: () {
                  setState((){
                    pass_show = !pass_show;
                  });
                },
                child:pass_show? SvgPicture.asset(
                  'assets/fi_eye-off.svg',
                ):SvgPicture.asset(
                  'assets/eye 1.svg',
                )),

            controller: txt_pass,
            autofillHints: [AutofillHints.email],
            textInputAction: TextInputAction.done,
            onChanged: (val){
              setState(() {
                print(val.length);
                field2 = val.length;
              });
            },
            keyBoardType: TextInputType.emailAddress,
            validatorFieldValue: 'email',
            validator:validateNewPassword,
          );
        },
      ),
    );


  }
  Map toMap() {
    var map =  Map<String, dynamic>();

    map["cust_email"] = txt_email.text.toString().trim();
    map["cust_password"] = txt_pass.text.toString().trim();
    map["cust_login_by"] = divece_type;

    return map;
  }
}
