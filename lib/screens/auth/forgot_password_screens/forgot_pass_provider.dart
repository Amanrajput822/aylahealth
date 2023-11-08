
import 'dart:convert';

import 'package:aylahealth/screens/auth/forgot_password_screens/resetpass_screen.dart';
import 'package:aylahealth/screens/auth/forgot_password_screens/verify_screen.dart';
import 'package:aylahealth/screens/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/api_common_fuction.dart';
import '../../../common/check_screen.dart';
import '../../../common/styles/Fluttertoast_internet.dart';
import '../../../common/styles/const.dart';
import '../../../models/forgot password/forgotPasswordModel.dart';
import '../../../models/forgot password/resetPasswordModel.dart';
import '../../../models/forgot password/verifyForgotPasswordCodeModel.dart';
import '../../../models/recipelist/recipe_like_unlike_data_model.dart';
import '../../onbording_screen/pre_question_loding_screen.dart';




class ForgotPassProvider with ChangeNotifier {
  String error = '';

  int? _success ;
  int? get success => _success;

  String? _message ;
  String? get message => _message;

  bool _loading = false;
  bool get loading => _loading;

  bool _textFieldValidation = false;
  bool get textFieldValidation => _textFieldValidation;
  void textFieldValidationFunction(value){
    _textFieldValidation = value;
    notifyListeners();
  }

  /// recipe_unlike_api ///

  Future<forgotPasswordModel> forgotPasswordApi(context,custEmail) async {
    _loading = true;
    notifyListeners();
    check().then((intenet) async {
      if (intenet) {

      } else {
        FlutterToast_Internet();
      }
    });

    Map toMap() {
      var map = Map<String, dynamic>();
      map["cust_email"] = custEmail??"";
      return map;
    }
    var response = await http.post(
        Uri.parse(Endpoints.baseURL + Endpoints.forgotPassword),
        body: toMap(),
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      _success = (forgotPasswordModel
          .fromJson(json.decode(response.body))
          .status);
      _message = (forgotPasswordModel
          .fromJson(json.decode(response.body))
          .message);
      print("success 123 ==${_success}");
      if (_success == 200) {
        _loading = false;
      //  FlutterToast_message(_message);
        _textFieldValidation = false;
        Get.to(() =>  VerifyScreen(email:custEmail));
        notifyListeners();

      }
      else {
        _loading = false;
        print('else==============');
        warning_popup(context,message);
        notifyListeners();
      }
    }
    else {
      _loading = false;
      notifyListeners();
    }
    return forgotPasswordModel.fromJson(json.decode(response.body));
  }

  /// verify code api

  Future<verifyForgotPasswordCodeModel> verifyCodeApi(context,fpCode) async {
    _loading = true;
    notifyListeners();
    check().then((intenet) async {
      if (intenet) {

      } else {
        FlutterToast_Internet();
      }
    });

    Map toMap() {
      var map = Map<String, dynamic>();
      map["fp_code"] = fpCode??"";
      return map;
    }
    var response = await http.post(
      Uri.parse(Endpoints.baseURL + Endpoints.verifyForgotPasswordCode),
      body: toMap(),
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      _success = (verifyForgotPasswordCodeModel
          .fromJson(json.decode(response.body))
          .status);
      print("success 123 ==${_success}");
      if (_success == 200) {
        _loading = false;
        _textFieldValidation = false;
        Get.off(() => ResetPassScreen(userId: verifyForgotPasswordCodeModel.fromJson(json.decode(response.body)).data.toString()));
        notifyListeners();

      }
      else {
        _loading = false;
        print('else==============');
        _textFieldValidation = true;
        // FlutterToast_message('This is not the right code.');
       // warning_popup(context,'That\'s not the right code.');
        notifyListeners();
      }
    }
    else {
      _loading = false;
      notifyListeners();
    }
    return verifyForgotPasswordCodeModel.fromJson(json.decode(response.body));
  }

  /// reset Password api

  Future<ResetPasswordModel> resetPasswordApi(context,custId,custPassword) async {
    _loading = true;
    notifyListeners();
    check().then((intenet) async {
      if (intenet) {

      } else {
        FlutterToast_Internet();
      }
    });

    Map toMap() {
      var map = Map<String, dynamic>();
      map["cust_id"] = custId??"";
      map["cust_password"] = custPassword??"";
      return map;
    }
    var response = await http.post(
      Uri.parse(Endpoints.baseURL + Endpoints.resetPassword),
      body: toMap(),
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      _success = (ResetPasswordModel
          .fromJson(json.decode(response.body))
          .status);
      _message = (ResetPasswordModel
          .fromJson(json.decode(response.body))
          .message);
      print("success 123 ==${_success}");
      if (_success == 200) {
        _loading = false;
        FlutterToast_message(message);
        Get.off(() => LogIn());
        notifyListeners();

      }
      else {
        _loading = false;
        print('else==============');
        FlutterToast_message(message);

      }
    }
    else {
      _loading = false;
    }
    return ResetPasswordModel.fromJson(json.decode(response.body));
  }

  /// warning message popup ////
  Future warning_popup(context,message){
    return  showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(

            content:  Text(message??""),
            actions: [
              CupertinoDialogAction(
                onPressed: () {

                  Navigator.of(context, rootNavigator: true).pop("Discard");
                  FocusManager.instance.primaryFocus?.unfocus();

                  notifyListeners();

                },

                child:  Text('Ok',style: TextStyle(color: colorBluePigment ),),
              ),
              // The "Yes" button

              // The "No" butt

            ],
          );
        }
    );
  }
}