import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/api_common_fuction.dart';
import '../../../../common/check_screen.dart';
import '../../../../common/styles/Fluttertoast_internet.dart';

import '../../models/food_nutrition_settings/customerFoodSettingHeadingList_model.dart';

class Food_Nutrition_Settings_provider with ChangeNotifier {

  int? _success ;
  int? get success => _success;

  String? _message ;
  String? get message => _message;

  String? _tokanget ;
  String? get tokanget => _tokanget;


  bool loading = false;


  List<customerFoodSettingHeadingList_responce>? _customerFoodSettingHeading_list;
  List<customerFoodSettingHeadingList_responce>? get customerFoodSettingHeading_list => _customerFoodSettingHeading_list;

  /// Customer Food Setting Heading Api ///

  Future<customerFoodSettingHeadingList_model> customerFoodSettingHeadingList_api(context) async {
    loading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();

      _tokanget = prefs.getString('login_user_token');
      _tokanget = tokanget!.replaceAll('"', '');

    print(tokanget.toString());
    check().then((intenet) async {
      if (intenet != null && intenet) {
        // Internet Present Case
        //showLoaderDialog1(context);

      } else {
        FlutterToast_Internet();
      }
    });

    var response = await http.post(
        Uri.parse(Endpoints.baseURL+Endpoints.customerFoodSettingHeadingList),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json'
        }
    );
    loading = false;
    if(response.statusCode == 200){
      print(response.body.toString());
      print("success 123 ==");
      _success = (customerFoodSettingHeadingList_model.fromJson(json.decode(response.body)).status);
      print("success 123 ==${success}");

      if (success == 200) {
        loading = false;
        _customerFoodSettingHeading_list = (customerFoodSettingHeadingList_model.fromJson(json.decode(response.body)).data);
        notifyListeners();
        // Get.to(() => Pre_Question_Screen());
      } else {
        loading = false;
        print('else==============');

        FlutterToast_message('No Data');
      }
    }else{
      loading = false;
      FlutterToast_message('No Data');
    }

    return customerFoodSettingHeadingList_model.fromJson(json.decode(response.body));
  }

}