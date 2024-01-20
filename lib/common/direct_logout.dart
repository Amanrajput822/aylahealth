import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../myapp.dart';
import '../screens/auth/login_screen.dart';
import '../screens/tabbar_screens/my_meals/calendar_evryday_json.dart';
import 'SharedPrefHelper.dart';

Future<void> directLogOutPopup() async {
  Navigator.of(navigationKey.currentContext!).pushAndRemoveUntil(
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
}