import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/api_common_fuction.dart';
import '../../../common/check_screen.dart';
import '../../../common/styles/Fluttertoast_internet.dart';
import '../../../models/meals plans/Meal_Plan_Date_Data_model.dart';



class HomeScreenProvider with ChangeNotifier {

  String error = '';

  int? _success ;
  int? get success => _success;

  String? _message ;
  String? get message => _message;

  String? _tokenGet ;
  String? get tokenGet => _tokenGet;


   bool _loading = false;
  bool get loading => _loading;

  bool? _iconColor = false;
  bool? get iconColor => _iconColor;

  void IconColor(newMessage){
    _iconColor = newMessage;
    notifyListeners();
  }

  // Meal_Plan_Date_Data_Response? _singleDayaData;
  // Meal_Plan_Date_Data_Response? get singleDayaData => _singleDayaData;
  //
  // List<MealData_list>? _mealData;
  // List<MealData_list>?get mealData => _mealData;
  //
  // Future<Meal_Plan_Date_Data_model?> singal_day_data_gate_api(DateTime selectDate) async {
  //
  //   Meal_Plan_Date_Data_model? result;
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     _tokenGet = prefs.getString('login_user_token');
  //     _tokenGet = tokenGet!.replaceAll('"', '');
  //     _loading = true;
  //     check().then((intenet) async {
  //       if (intenet) {} else {FlutterToast_Internet();}
  //     });
  //     Map toMap() {
  //       var map = Map<String, dynamic>();
  //       map["mlp_year"] = selectDate.year.toString();
  //       map["mlp_month"] = selectDate.month.toString();
  //       map["date"] = selectDate.day.toString();
  //       // map["mlp_id"] = '1';
  //       return map;
  //     }
  //     print(toMap());
  //     print(Endpoints.baseURL + Endpoints.customerMealOfDay);
  //     var response = await http.post(
  //         Uri.parse(Endpoints.baseURL + Endpoints.customerMealOfDay),
  //         body: toMap(),
  //         headers: {
  //           'Authorization': 'Bearer $tokenGet',
  //           'Accept': 'application/json'
  //         }
  //     );
  //     _loading = false;
  //     _success = (Meal_Plan_Date_Data_model.fromJson(json.decode(response.body)).status);
  //     print("json.decode(response.body)${json.decode(response.body)}");
  //     if (success == 200) {
  //       _loading = false;
  //       _singleDayaData =(Meal_Plan_Date_Data_model.fromJson(json.decode(response.body)).data);
  //       _mealData = singleDayaData!.mealData;
  //        notifyListeners();
  //     } else {
  //       print('else==============');
  //       FlutterToast_message('No Data');
  //     }
  //   } catch (e) {
  //     notifyListeners();
  //     error = e.toString();
  //   }
  //   return result;
  // }

//
// Future<Recipe_details_data_model?> recipe_ditels_api(context, rec_id) async {
//   Recipe_details_data_model? result;
//   try {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     _tokenGet = prefs.getString('login_user_token');
//     _tokenGet = tokenGet!.replaceAll('"', '');
//     _user_id = prefs.getString('login_user_id');
//     _user_id = user_id!.replaceAll('"', '');
//
//     print(tokenGet.toString());
//     check().then((intenet) async {
//       if (intenet != null && intenet) {
//
//       } else {
//         FlutterToast_Internet();
//       }
//     });
//     Map toMap() {
//       var map = Map<String, dynamic>();
//       map["rec_id"] = rec_id.toString();
//       map["cust_id"] = user_id.toString();
//       map["checkNutritionSetting"] = '1';
//       return map;
//     }
//     print(toMap());
//     print(beasurl + recipeDetails);
//     var response = await http.post(
//         Uri.parse(beasurl + recipeDetails),
//         body: toMap(),
//         headers: {
//           'Authorization': 'Bearer $tokenGet',
//           'Accept': 'application/json'
//         }
//     );
//     print(response.body.toString());
//     _success = (Recipe_details_data_model
//         .fromJson(json.decode(response.body))
//         .status);
//     print("json.decode(response.body)${json.decode(response.body)}");
//     if (success == 200) {
//       final item = json.decode(response.body);
//       result = (Recipe_details_data_model.fromJson(item));
//       _recipe_ditels_data = (Recipe_details_data_model
//           .fromJson(item)
//           .data);
//       notifyListeners();
//       // Get.to(() => Pre_Question_Screen());
//     } else {
//       // Navigator.pop(context);
//       print('else==============');
//       FlutterToast_message('No Data');
//
//     }
//   } catch (e) {
//     error = e.toString();
//   }
//   return result;
// }
//


}