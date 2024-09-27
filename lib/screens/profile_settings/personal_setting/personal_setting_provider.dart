
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/api_common_fuction.dart';
import '../../../../common/check_screen.dart';
import '../../../../common/styles/Fluttertoast_internet.dart';
import '../../../common/SharedPrefHelper.dart';
import '../../../common/direct_logout.dart';
import '../../../common/styles/showLoaderDialog_popup.dart';
import '../../../models/deleteCustomerAppModel.dart';
import '../../../models/profile/user_details_model.dart';
import '../../auth/app_cache_clear.dart';
import '../../auth/google_authentication.dart';
import '../../auth/login_screen.dart';
import '../../tabbar_screens/my_meals/calendar_evryday_json.dart';
import '../../tabbar_screens/support_screen/message/chat/firebase_services.dart';

class userprofile_Provider with ChangeNotifier {

  int? _success ;
  int? get success => _success;

  String? _message ;
  String? get message => _message;

  String? _tokanget ;
  String? get tokanget => _tokanget;

  String? _user_id ;
  String? get user_id => _user_id;

  bool loading = false;

  bool _loading1 = false;
  bool get loading1 => _loading1;
  void loaderFunction(newMessage){
    _loading1 = newMessage;
    notifyListeners();
  }

  user_details_esponse? _user_details_data;
  user_details_esponse? get user_details_data => _user_details_data;
  void userdetailsdata( newMessage) {
    _user_details_data = newMessage;
    notifyListeners();
  }
  /// User Details Api ///

  Future<user_details_model> customer_ditels_api(context) async {
    loading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();

      _tokanget = prefs.getString('login_user_token');
      _tokanget = tokanget!.replaceAll('"', '');
      _user_id = prefs.getString('login_user_id');
      _user_id = user_id!.replaceAll('"', '');

    print(tokanget.toString());
    check().then((intenet) async {
      if (intenet != null && intenet) {

      } else {
        FlutterToast_Internet();
      }
    });
    Map toMap() {
      var map =  Map<String, dynamic>();

      map["cust_id"] = user_id;

      return map;
    }
    var response = await http.post(
        Uri.parse(Endpoints.baseURL+Endpoints.customerDetails),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json'
        }
    );
    loading = false;
    if(response.statusCode==200){
    print(response.body.toString());
    _success = (user_details_model.fromJson(json.decode(response.body)).status);
    print("success 123 ==${success}");
    if (success == 200) {
      loading = false;
     // Navigator.pop(context);

      _user_details_data = (user_details_model.fromJson(json.decode(response.body)).data);
      FirebaseData.instance.userUpdate();
      notifyListeners();
      // Get.to(() => Pre_Question_Screen());

    } else {
      loading = false;
    //  Navigator.pop(context);
      print('else==============');

      FlutterToast_message('No Data');

    }}else{
      if(response.statusCode ==401){
        directLogOutPopup();
      }
    }
    return user_details_model.fromJson(json.decode(response.body));
  }

  Future<deleteCustomerAppModel> deleteCustomer_api(context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    _tokanget = prefs.getString('login_user_token');
    _tokanget = tokanget!.replaceAll('"', '');
    _user_id = prefs.getString('login_user_id');
    _user_id = user_id!.replaceAll('"', '');

    print(tokanget.toString());
    check().then((intenet) async {
      if (intenet != null && intenet) {

      } else {
        FlutterToast_Internet();
      }
    });

    Map toMap() {
      var map =  Map<String, dynamic>();
      map["cust_id"] = user_id;
      return map;
    }
    loaderFunction(true);
    var response = await http.post(
        Uri.parse(Endpoints.baseURL+Endpoints.deleteCustomerApp),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json'
        }
    );

    if(response.statusCode==200){
      loaderFunction(false);
      print(response.body.toString());
      _success = (deleteCustomerAppModel.fromJson(json.decode(response.body)).status);
      _message = (deleteCustomerAppModel.fromJson(json.decode(response.body)).message);
      print("success 123 ==${success}");
      if (success == 200) {
        loaderFunction(false);
        Navigator.of(context).pushAndRemoveUntil(
          // the new route
          MaterialPageRoute(
            builder: (BuildContext context) => const LogIn(),
          ), (Route route) => false,
        );
        SharedPreferences prefs =  await SharedPreferences.getInstance();
        await prefs.clear();
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
        deleteCacheDir();
        // _deleteAppDir();
        FlutterToast_message(message);

      } else {
        loaderFunction(false);
        //  Navigator.pop(context);
        print('else==============');

        FlutterToast_message('No Data');

      }}else{
      if(response.statusCode ==401){
        directLogOutPopup();
        loaderFunction(false);
      }
    }
    return deleteCustomerAppModel.fromJson(json.decode(response.body));
  }
}