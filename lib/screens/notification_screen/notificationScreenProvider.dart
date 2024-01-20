import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/api_common_fuction.dart';
import '../../../common/check_screen.dart';
import '../../../common/styles/Fluttertoast_internet.dart';
import '../../../models/home model/RecipeCollectionListModel.dart';
import '../../../models/meals plans/MealPlaneLestData_Model.dart';
import '../../../models/meals plans/Meal_Plan_Date_Data_model.dart';
import '../../../models/recipelist/RecipeList_data_model.dart';
import '../../../models/recipelist/filtter_list_models/Recipe_Filtter_model.dart';
import '../../../models/recipelist/recipe_like_unlike_data_model.dart';
import '../../common/direct_logout.dart';
import '../../models/notificatio_screen/customerNotificationSettingModel.dart';
import '../../models/notificatio_screen/updateCustomerNotificationSettingModel.dart';



class NotificationScreenProvider extends ChangeNotifier {

  String error = '';

  int? _success ;
  int? get success => _success;


  String? _message ;
  String? get message => _message;

  String? _tokanget ;
  String? get tokanget => _tokanget;


  bool _loading = false;
  bool get loading => _loading;
  void loaderFunction(newMessage){
    _loading = newMessage;
    notifyListeners();
  }

  List <customerNotificationSettingresponce>? _notificationSettingData;
  List <customerNotificationSettingresponce>? get notificationSettingData => _notificationSettingData;
  void notificationSettingDataFunction(newMessage){
    _notificationSettingData = newMessage;
    notifyListeners();
  }
  /// customer Notification Setting api //////////////////

  Future<customerNotificationSettingModel> customerNotificationSetting_api() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokanget = prefs.getString('login_user_token');
    _tokanget = _tokanget!.replaceAll('"', '');

    check().then((intenet) async {
      if (intenet != null && intenet) {}
      else {
        FlutterToast_Internet();
      }
    });

    loaderFunction(true);
    var response = await http.post(
        Uri.parse(Endpoints.baseURL + Endpoints.customerNotificationSetting),
        headers: {
          'Authorization': 'Bearer $_tokanget',
          'Accept': 'application/json'
        }
    );
    if (response.statusCode == 200) {
      _loading = false;
      print('response.body.toString()');
      print(response.body.toString());
      print('response.body.toString()');
      _success = (customerNotificationSettingModel.fromJson(json.decode(response.body)).status);

      if (_success == 200) {
        _loading = false;
        _notificationSettingData = customerNotificationSettingModel.fromJson(json.decode(response.body)).data;
       // FlutterToast_message(_message);
        notifyListeners();
      }else {
        _loading = false;
        print('else==============');
        FlutterToast_message(_message);
        notifyListeners();
      }
      notifyListeners();
    }
    else{
      loaderFunction(false);
      if(response.statusCode ==401){
        directLogOutPopup();
      }
      FlutterToast_message(json.decode(response.body)['message']);
    }
    return customerNotificationSettingModel.fromJson(json.decode(response.body));
  }



  /// update Customer Notification Setting api //////////////////

  Future<updateCustomerNotificationSettingModel> updateCustomerNotificationSetting_api(cnsId,cnsRecipeStatus,cnsModuleStatus,buttonType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokanget = prefs.getString('login_user_token');
    _tokanget = _tokanget!.replaceAll('"', '');

    check().then((intenet) async {
      if (intenet != null && intenet) {}
      else {
        FlutterToast_Internet();
      }
    });

    Map toMap() {
      var map = Map<String, dynamic>();
      map["cns_id"] = cnsId.toString();
      if(buttonType == 'cns_module_status'){
      map["cns_module_status"] = cnsModuleStatus.toString();
      }
      else if(buttonType == 'cns_recipe_status'){
        map["cns_recipe_status"] = cnsRecipeStatus.toString();
      }
      return map;
    }
    print(toMap());
    var response = await http.post(
        Uri.parse(Endpoints.baseURL + Endpoints.updateCustomerNotificationSetting),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $_tokanget',
          'Accept': 'application/json'
        }
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      _success = (updateCustomerNotificationSettingModel.fromJson(json.decode(response.body)).status);
      _message = (updateCustomerNotificationSettingModel.fromJson(json.decode(response.body)).message);

      if (_success == 200) {

        // FlutterToast_message(_message);
        notifyListeners();
      }else {
        print('else==============');
        FlutterToast_message(_message);
      }
    }
    else{
      loaderFunction(false);
      if(response.statusCode ==401){
        directLogOutPopup();
      }
      FlutterToast_message(json.decode(response.body)['message']);
    }
    return updateCustomerNotificationSettingModel.fromJson(json.decode(response.body));
  }


}