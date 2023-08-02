import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'const.dart';

void FlutterToast_Internet(){
  Fluttertoast.showToast(
      msg: "Please check your Internet connection!!!!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: colorFlutterToast,
      textColor: Colors.white,
      fontSize: 16.0,
  );
}

void FlutterToast_message(String? message){
  Fluttertoast.showToast(
      msg: message.toString(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: colorFlutterToast,
      textColor: Colors.white,
      fontSize: 16.0,
  );
}