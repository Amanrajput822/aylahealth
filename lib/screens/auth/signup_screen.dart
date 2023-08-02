import 'dart:convert';
import 'dart:io';

import 'package:aylahealth/common/formtextfield/validations_field.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/api_common_fuction.dart';
import '../../common/check_screen.dart';
import '../../common/commonwidgets/button.dart';
import '../../common/formtextfield/mytextfield.dart';
import '../../common/styles/Fluttertoast_internet.dart';
import '../../common/styles/const.dart';
import '../../common/styles/showLoaderDialog_popup.dart';
import '../../models/auth model/user_login_model.dart';
import '../onbording_screen/pre_question_loding_screen.dart';
import 'package:http/http.dart' as http;

class Signup_screen extends StatefulWidget {
  const Signup_screen({Key? key}) : super(key: key);

  @override
  State<Signup_screen> createState() => _Signup_screenState();
}

class _Signup_screenState extends State<Signup_screen> {

  var _formKey = GlobalKey<FormState>();
  TextEditingController txt_email = TextEditingController();
  TextEditingController txt_pass = TextEditingController();
  TextEditingController txt_fist_name = TextEditingController();
  TextEditingController txt_last_name = TextEditingController();
  TextEditingController txt_conform_pass = TextEditingController();
  bool pass_show = true;
  bool pass_show1 = true;
  int? field1 = 0;
  int? field2 = 0;
  int? field3 = 0;
  int? field4 = 0;
  int? field5 = 0;

  var success, message, id, email;
  String? divece_type;

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


  Future<user_login_model> signup() async {
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        showLoaderDialog_popup(context,"Sign Up...");
      } else {
        FlutterToast_Internet();
      }
    });
    print(toMap());
    var response = await http.post(
      Uri.parse(beasurl+Signup),
      body: toMap(),
    );
    print(response.body.toString());
    success = (user_login_model.fromJson(json.decode(response.body)).status);
    message = (user_login_model.fromJson(json.decode(response.body)).message);
    print("success 123 ==${success}");
    if (success == 200) {

        Navigator.pop(context);

        FlutterToast_message(message);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
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
        Get.to(() => Pre_Question_Screen());

        FlutterToast_message(message);

    } else {
      Navigator.pop(context);
      print('else==============');
      error_dialog(message);
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
      body: Container(
        height: deviceheight(context),
        width: deviceWidth(context),
        child: SingleChildScrollView(
          child: Column(
            children: [

              sizedboxheight(deviceheight(context, 0.1)),
              Form(
                key: _formKey,
                child: Container(
                  height: deviceheight(context, 0.9),
                  width: deviceWidth(context),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: colorWhite
                  ),
                 // padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10,top: 10),
                          child: IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: SvgPicture.asset('assets/backbutton.svg')),
                        ),
                        Text('Sign up',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: fontFamilyText,
                            color: colorTextFieldHadingText,
                            fontWeight: fontWeight600,
                          ),
                        ).paddingOnly(left: 20,right: 20),
                        sizedboxheight(deviceheight(context,0.01)),

                        fistnamefield().paddingOnly(left: 20,right: 20),
                        sizedboxheight(deviceheight(context,0.025)),
                        lastnamefield().paddingOnly(left: 20,right: 20),
                        sizedboxheight(deviceheight(context,0.025)),
                        emailfield().paddingOnly(left: 20,right: 20),

                        sizedboxheight(deviceheight(context,0.025)),
                        passwordfield().paddingOnly(left: 20,right: 20),
                        sizedboxheight(deviceheight(context,0.025)),
                        conformpasswordfield().paddingOnly(left: 20,right: 20),
                        sizedboxheight(deviceheight(context,0.025)),
                        signupBtn(context).paddingOnly(left: 20,right: 20),
                        sizedboxheight(deviceheight(context,0.01)),

                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  Widget signupBtn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Sign up',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor: ((field1 !=0 && field2 !=0 && field3 !=0 && field4 !=0 && field5 !=0)? colorEnabledButton:colorDisabledButton),
        onPressed: () {
          if(field1 !=0 && field2 !=0 && field3 !=0 && field4 !=0 && field5 !=0){
            if(_formKey.currentState!.validate()){
              print(txt_pass.text);
              print(txt_conform_pass.text);
              print(txt_pass.text==txt_conform_pass.text);

              if(txt_pass.text==txt_conform_pass.text){
                signup();
              }
              else{
                print('Passwords do NOT match');
                // Fluttertoast.showToast(
                //
                //     msg: "Passwords do not match",
                //     toastLength: Toast.LENGTH_SHORT,
                //     gravity: ToastGravity.BOTTOM,
                //     backgroundColor: colorFlutterToast,
                //     textColor: Colors.white,
                //     fontSize: 16.0);
              }

             // Get.to(() => Pre_Question_Screen());
            }
           }
          // Get.to(() => Pre_Question_Screen());
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
            onChanged: (val){
              setState(() {
                print(val.length);
                field3 = val.length;
              });
            },
            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            autofillHints: [AutofillHints.email],
            textInputAction: TextInputAction.next,
            keyBoardType: TextInputType.emailAddress,
            validatorFieldValue: 'email',

            validator: validateEmailField,
          );

        },
      ),
    );
  }

  Widget fistnamefield() {
    return  Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            inputHeaderName: 'First name',
            // key: Key("email1"),
           // floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: 'First name',
            hintText: 'Name',

            controller: txt_fist_name,
            onChanged: (val){
              setState(() {
                print(val.length);
                field1 = val.length;
              });
            },
            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            autofillHints: [AutofillHints.name],
            textInputAction: TextInputAction.next,
            keyBoardType: TextInputType.text,
            validatorFieldValue: 'Name',
            validator: validateName,
          );

        },
      ),
    );
  }
  Widget lastnamefield() {
    return  Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            inputHeaderName: 'Last name',
            // key: Key("email1"),
          //  floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: 'Last name',
            hintText: 'Name',

            controller: txt_last_name,
            onChanged: (val){
              setState(() {
                print(val.length);
                field2 = val.length;
              });
            },
            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            autofillHints: [AutofillHints.name],
            textInputAction: TextInputAction.next,
            keyBoardType: TextInputType.text,
            validatorFieldValue: 'Name',

            validator: validateName,
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
          //  floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: 'Password',
            hintText: 'password',
            obsecureText: pass_show,
            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
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
            onChanged: (val){
              setState(() {
                print(val.length);
                field4 = val.length;
              });
            },
            controller: txt_pass,
            autofillHints: [AutofillHints.password],
            textInputAction: TextInputAction.next,

            keyBoardType: TextInputType.visiblePassword,
            validatorFieldValue: 'password',
            validator: validateNewPassword,
          );
        },
      ),
    );


  }
  Widget conformpasswordfield() {
    return Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            inputHeaderName: 'Password confirmation',
            // key: Key("email1"),
           // floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: 'Password confirmation',
            hintText: 'Re-enter password',
            obsecureText: pass_show1,
            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,

            suffixIcon: TextButton(
                onPressed: () {
                  setState((){
                    pass_show1 = !pass_show1;
                  });
                },
                child:pass_show1? SvgPicture.asset(
                  'assets/fi_eye-off.svg',
                ):SvgPicture.asset(
                  'assets/eye 1.svg',
                )),
            onChanged: (val){
              setState(() {
                print(val.length);
                field5 = val.length;
              });
            },
            controller: txt_conform_pass,
            autofillHints: [AutofillHints.password],
            textInputAction: TextInputAction.done,

            keyBoardType: TextInputType.visiblePassword,
            validatorFieldValue: 'password',
            validator: (PassCurrentValue){
              Pattern pattern = r'^(?=.*?[a-zA-Z])(?=.*?[0-9]).{8,}$';
              // Pattern pattern = r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
              // RegExp regex = new RegExp(pattern);

              RegExp regex =  RegExp(pattern as String);

              if (PassCurrentValue.isEmpty) {
                return 'Password is Required.';
              } else if (PassCurrentValue.length < 8) {
                return 'Password length cannot be less than 8 characters.';
              }
              else if (!regex.hasMatch(PassCurrentValue)) {
                return 'Password must contain numbers, letter, and at least 8 characters';
              } else if (txt_conform_pass.text != txt_pass.text) {
                return 'Passwords do not match';
              }
            },
          );
        },
      ),
    );


  }


  Map toMap() {
    var map =  Map<String, dynamic>();

    map["cust_firstname"] = txt_fist_name.text.toString().trim();
    map["cust_lastname"] = txt_last_name.text.toString().trim();
    map["cust_email"] = txt_email.text.toString().trim();
    map["cust_password"] = txt_pass.text.toString().trim();
    map["cust_login_by"] = divece_type;
    map["cust_type"] = '3';

    return map;
  }
}

