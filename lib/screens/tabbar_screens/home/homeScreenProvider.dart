import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/api_common_fuction.dart';
import '../../../common/check_screen.dart';
import '../../../common/styles/Fluttertoast_internet.dart';
import '../../../models/meals plans/Meal_Plan_Date_Data_model.dart';
import '../../../models/recipelist/RecipeList_data_model.dart';
import '../../../models/recipelist/filtter_list_models/Recipe_Filtter_model.dart';



class HomeScreenProvider with ChangeNotifier {

  String error = '';

  int? _success ;
  int? get success => _success;

  String? _message ;
  String? get message => _message;

  String? _tokanget ;
  String? get tokanget => _tokanget;


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


  /// recipeList_ditels_api ///

  List<RecipeList_data_Response>? _recipe_data_List ;
  List<RecipeList_data_Response>? get recipe_data_List => _recipe_data_List;

  Future<RecipeList_data_model> recipeList_ditels_api() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokanget = prefs.getString('login_user_token');
    _tokanget = _tokanget!.replaceAll('"', '');
    print(_tokanget.toString());
    check().then((intenet) async {
      _loading = true;
      if (intenet) {
      } else {
        FlutterToast_Internet();
      }
    });

    Map toMap() {
      var map =  Map<String, dynamic>();
      map["index"] = '0';
      map["limit"] = 20;
      map["search"] = "";
      map["fav_status"] = '0';
      map["rec_isfeatured"] = "1";

      return map;
    }

    print(toMap().toString());
    print(Endpoints.baseURL+Endpoints.recipeList.toString());
    var response = await http.post(
        Uri.parse(Endpoints.baseURL+Endpoints.recipeList),
        body: json.encode(toMap()),
        headers: {
          'Authorization': 'Bearer $_tokanget',
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
    );
    _loading = false;
    print(response.body.toString());
    _success = (RecipeList_data_model.fromJson(json.decode(response.body)).status);
    print("success 123 ==${_success}");
    if (_success == 200) {
      _loading = false;
      _recipe_data_List = (RecipeList_data_model.fromJson(json.decode(response.body)).data);
      notifyListeners();

    } else {
      _loading = false;
      print('else==============');
      FlutterToast_message('No Data');
    }
    return RecipeList_data_model.fromJson(json.decode(response.body));
  }


}