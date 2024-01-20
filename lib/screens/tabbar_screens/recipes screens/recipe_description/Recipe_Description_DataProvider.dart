import 'package:flutter/cupertino.dart';


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/api_common_fuction.dart';
import '../../../../common/check_screen.dart';
import '../../../../common/direct_logout.dart';
import '../../../../common/styles/Fluttertoast_internet.dart';
import '../../../../models/recipelist/Recipe_details_data_model.dart';
import '../../../../models/recipelist/recipe_like_unlike_data_model.dart';


class Recipe_Description_DataProvider with ChangeNotifier {
  int? _success ;
  int? get success => _success;

  String? _message ;
  String? get message => _message;

  String? _tokanget ;
  String? get tokanget => _tokanget;

  String? _user_id ;
  String? get user_id => _user_id;

  bool _loading = false;
  bool get loading => _loading;

  int? _server_count ;
  int? get server_count => _server_count;


  Recipe_details_data_model post = Recipe_details_data_model();
  Recipe_details_data_recponse? _recipe_ditels_data ;
  Recipe_details_data_recponse? get recipe_ditels_data => _recipe_ditels_data;


  getRecipeData(context,rec_id) async {
    _loading = true;
    post = (await recipe_ditels_api(context,rec_id))!;
    _recipe_ditels_data = post.data;
    _server_count = recipe_ditels_data!.recServes;
    _loading = false;
    notifyListeners();
  }
  void updateeatingPattern( newMessage) {

    _server_count = newMessage;
    notifyListeners();
  }
  String error = '';

  Future<Recipe_details_data_model?> recipe_ditels_api(context, rec_id) async {
    Recipe_details_data_model? result;
    try {
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
        var map = Map<String, dynamic>();
        map["rec_id"] = rec_id.toString();
        map["cust_id"] = user_id.toString();
        // map["checkNutritionSetting"] = '1';
        return map;
      }
      print(toMap());
      print(Endpoints.baseURL + Endpoints.recipeDetails);
      var response = await http.post(
          Uri.parse(Endpoints.baseURL + Endpoints.recipeDetails),
          body: toMap(),
          headers: {
            'Authorization': 'Bearer $tokanget',
            'Accept': 'application/json'
          }
      );
      if(response.statusCode == 200){

        _success = (Recipe_details_data_model
            .fromJson(json.decode(response.body))
            .status);
        print("json.decode(response.body)${json.decode(response.body)}");
        if (success == 200) {
          final item = json.decode(response.body);
          result = (Recipe_details_data_model.fromJson(item));
          _recipe_ditels_data = (Recipe_details_data_model
              .fromJson(item)
              .data);
          notifyListeners();
          // Get.to(() => Pre_Question_Screen());
        } else {
          // Navigator.pop(context);
          print('else==============');
          FlutterToast_message('No Data');

        }
      }
      else{
        if(response.statusCode ==401){
          directLogOutPopup();
        }
        FlutterToast_message(json.decode(response.body)['message']);
      }

    } catch (e) {
      error = e.toString();
    }
    return result;
  }


  /// recipe_like_api //////////////////

  Future<recipe_like_unlike_data_model> recipe_like_api(context,recipe_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _tokanget = prefs.getString('login_user_token');
    _tokanget = _tokanget!.replaceAll('"', '');
    _user_id = prefs.getString('login_user_id');
    _user_id = _user_id!.replaceAll('"', '');

    print(_tokanget.toString());
    check().then((intenet) async {
      if (intenet != null && intenet) {

      } else {
        FlutterToast_Internet();
      }
    });

    Map toMap() {
      var map = Map<String, dynamic>();
      map["rec_id"] = recipe_id.toString();
      map["cust_id"] = _user_id.toString();

      return map;
    }
    var response = await http.post(
        Uri.parse(Endpoints.baseURL + Endpoints.markRecipeFavorite),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $_tokanget',
          'Accept': 'application/json'
        }
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      _success = (recipe_like_unlike_data_model
          .fromJson(json.decode(response.body))
          .status);
      _message = (recipe_like_unlike_data_model
          .fromJson(json.decode(response.body))
          .message);
      print("success 123 ==${_success}");
      if (_success == 200) {
        // Navigator.pop(context);
        FlutterToast_message(_message);
        notifyListeners();
        // Get.to(() => Pre_Question_Screen());
      }
      else {
        print('else==============');
        FlutterToast_message(_message);
      }
    }
    else{
      if(response.statusCode ==401){
        directLogOutPopup();
      }
      FlutterToast_message(json.decode(response.body)['message']);
    }
    return recipe_like_unlike_data_model.fromJson(json.decode(response.body));
  }

  /// recipe_unlike_api ///////////////////

  Future<recipe_like_unlike_data_model> recipe_unlike_api(context,recipe_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _tokanget = prefs.getString('login_user_token');
    _tokanget = _tokanget!.replaceAll('"', '');
    _user_id = prefs.getString('login_user_id');
    _user_id = _user_id!.replaceAll('"', '');

    print(_tokanget.toString());
    check().then((intenet) async {
      if (intenet != null && intenet) {

      } else {
        FlutterToast_Internet();
      }
    });

    Map toMap() {
      var map = Map<String, dynamic>();
      map["rec_id"] = recipe_id.toString();
      map["cust_id"] = _user_id.toString();
      return map;
    }
    var response = await http.post(
        Uri.parse(Endpoints.baseURL + Endpoints.unmarkRecipeFromFavorite),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $_tokanget',
          'Accept': 'application/json'
        }
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      _success = (recipe_like_unlike_data_model
          .fromJson(json.decode(response.body))
          .status);
      _message = (recipe_like_unlike_data_model
          .fromJson(json.decode(response.body))
          .message);
      print("success 123 ==${_success}");
      if (_success == 200) {

        FlutterToast_message(_message);

        notifyListeners();
        // Get.to(() => Pre_Question_Screen());
      }
      else{
        FlutterToast_message(_message);
      }
    }
    else {
      if(response.statusCode ==401){
        directLogOutPopup();
      }
      FlutterToast_message(json.decode(response.body)['message']);

    }
    return recipe_like_unlike_data_model.fromJson(json.decode(response.body));
  }

}