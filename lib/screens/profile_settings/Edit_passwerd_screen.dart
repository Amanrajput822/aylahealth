import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/api_common_fuction.dart';
import '../../common/check_screen.dart';
import '../../common/commonwidgets/button.dart';
import '../../common/direct_logout.dart';
import '../../common/formtextfield/mytextfield.dart';
import '../../common/formtextfield/validations_field.dart';
import '../../common/styles/Fluttertoast_internet.dart';
import '../../common/styles/const.dart';
import 'package:http/http.dart' as http;

import '../../common/styles/showLoaderDialog_popup.dart';
import '../../models/auth model/change_password_model.dart';
class Edit_Passwers_Screen extends StatefulWidget {
  const Edit_Passwers_Screen({Key? key}) : super(key: key);

  @override
  State<Edit_Passwers_Screen> createState() => _Edit_Passwers_ScreenState();
}

class _Edit_Passwers_ScreenState extends State<Edit_Passwers_Screen> {

  var _formKey = GlobalKey<FormState>();

  TextEditingController txt_current_pass = TextEditingController();
  TextEditingController txt_new_pass = TextEditingController();
  TextEditingController txt_confirm_pass = TextEditingController();
  bool pass_show1 = true;
  bool pass_show2 = true;
  bool pass_show3 = true;

  int? field1 = 0;
  int? field2 = 0;
  int? field3 = 0;


  var success, message;
  var tokanget;
  Future<change_password_model> update_password() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokanget = prefs.getString('login_user_token');
      tokanget = tokanget.replaceAll('"', '');
    });

    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        showLoaderDialog_popup(context,"Sign In...");
      } else {
        FlutterToast_Internet();
      }
    });
    Map toMap() {
      var map =  Map<String, dynamic>();

      map["oldPassword"] = txt_current_pass.text.toString().trim();
      map["newPassword"] = txt_new_pass.text.toString().trim();
      return map;
    }
    print(toMap());
    var response = await http.post(
      Uri.parse(Endpoints.baseURL+Endpoints.changePassword),
      body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json'
        }
    );
    if(response.statusCode==200){
    print(response.body.toString());
    success = (change_password_model.fromJson(json.decode(response.body)).status);
    message = (change_password_model.fromJson(json.decode(response.body)).message);
    print("success 123 ==${success}");
    if (success == 200) {

        Navigator.pop(context);

        FlutterToast_message(message);

        txt_current_pass.clear();
        txt_new_pass.clear();
        txt_confirm_pass.clear();

    } else {
      Navigator.pop(context);
      print('else==============');
      FlutterToast_message(message);

    }}
    else{
      if(response.statusCode ==401){
        directLogOutPopup();
      }
    }
    return change_password_model.fromJson(json.decode(response.body));
  }




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
      body: Form(
        key: _formKey,
        child: Container(
          height: deviceheight(context),
          width: deviceWidth(context),
          padding: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reset password',
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

                Text('Current password',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamilyText,
                    color: colorRichblack,
                    fontWeight: fontWeight400,
                  ),
                ),
                sizedboxheight(8.0),
                current_passwordfield(),
                sizedboxheight(15.0),

                Text('New password',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamilyText,
                    color: colorRichblack,
                    fontWeight: fontWeight400,
                  ),
                ),
                sizedboxheight(8.0),
                new_passwordfield(),
                sizedboxheight(15.0),

                Text('Confirm new password',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamilyText,
                    color: colorRichblack,
                    fontWeight: fontWeight400,
                  ),
                ),
                sizedboxheight(8.0),
                confirm_passwordfield(),
                sizedboxheight(40.0),
                updateBtn(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget updateBtn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Update password',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor: ((field1 !=0 && field2 !=0 && field3 != 0)? colorEnabledButton:colorDisabledButton),
        onPressed: () {
          if(field1 !=0 && field2 !=0 && field3 != 0){
            if (_formKey.currentState!.validate()) {
              update_password();
            } else {
              // model.toggleautovalidate();
            }

            // Get.to(() => Pre_Question_Screen());
          }

        },
      ),
    );
  }

  Widget current_passwordfield() {
    return Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
           // inputHeaderName: 'Password',
            // key: Key("email1"),
            floatingLabelBehavior: FloatingLabelBehavior.never,
           // labelText: 'Current Password',


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
                field1 = val.length;
              });
            },
            controller: txt_current_pass,
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
  Widget new_passwordfield() {
    return Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            // inputHeaderName: 'Password',
            // key: Key("email1"),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            // labelText: 'Current Password',


            obsecureText: pass_show2,
            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            suffixIcon: TextButton(
                onPressed: () {
                  setState((){
                    pass_show2 = !pass_show2;
                  });
                },
                child:pass_show2? SvgPicture.asset(
                  'assets/fi_eye-off.svg',
                ):SvgPicture.asset(
                  'assets/eye 1.svg',
                )),
            onChanged: (val){
              setState(() {
                print(val.length);
                field2 = val.length;
              });
            },
            controller: txt_new_pass,
            autofillHints: [AutofillHints.password],
            textInputAction: TextInputAction.next,

            keyBoardType: TextInputType.visiblePassword,
            validatorFieldValue: 'new password',
            validator: validateNewPassword,
          );
        },
      ),
    );


  }
  Widget confirm_passwordfield() {
    return Focus(
      child: Builder(
        builder: (BuildContext context) {
          final FocusNode focusNode = Focus.of(context);
          final bool hasFocus = focusNode.hasFocus;
          return  AllInputDesign(
            // inputHeaderName: 'Password',
            // key: Key("email1"),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            // labelText: 'Current Password',


            obsecureText: pass_show3,
            fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            suffixIcon: TextButton(
                onPressed: () {
                  setState((){
                    pass_show3 = !pass_show3;
                  });
                },
                child:pass_show3? SvgPicture.asset(
                  'assets/fi_eye-off.svg',
                ):SvgPicture.asset(
                  'assets/eye 1.svg',
                )),
            onChanged: (val){
              setState(() {
                print(val.length);
                field3 = val.length;
              });
            },
            controller: txt_confirm_pass,
            autofillHints: [AutofillHints.password],
            textInputAction: TextInputAction.done,

            keyBoardType: TextInputType.visiblePassword,
            validatorFieldValue: 'confirm password',
            validator:  (PassCurrentValue){
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
            } else if (txt_new_pass.text != txt_confirm_pass.text) {
              return 'Passwords do not match';
            }
          },
          );
        },
      ),
    );


  }
}
