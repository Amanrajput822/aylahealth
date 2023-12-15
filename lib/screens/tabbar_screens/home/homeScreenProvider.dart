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



class HomeScreenProvider extends ChangeNotifier {

  String error = '';

  int? _success ;
  int? get success => _success;


  String? _user_id ;
  String? get user_id => _user_id;

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

  bool _loading2 = false;
  bool get loading2 => _loading2;

  void loaderFunction2(newMessage){
    _loading2 = newMessage;
    notifyListeners();
  }

  bool? _iconColor = false;
  bool? get iconColor => _iconColor;

  void IconColor(newMessage){
    _iconColor = newMessage;
    notifyListeners();
  }



  /// recipeList_ditels_api ///

  List<RecipeList_data_Response>? _recipe_data_List = [];
  List<RecipeList_data_Response>? get recipe_data_List => _recipe_data_List;

  Future<RecipeList_data_model> recipeList_ditels_api() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokanget = prefs.getString('login_user_token');
    _tokanget = _tokanget!.replaceAll('"', '');
    print(_tokanget.toString());
    check().then((intenet) async {
      loaderFunction(true);

      if (intenet) {
      } else {
        FlutterToast_Internet();
      }
    });

    Map toMap() {
      var map =  Map<String, dynamic>();
      map["index"] = '0';
      map["limit"] = 10;
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
    if(response.statusCode == 200 ){

     loaderFunction(false);
     _success = (RecipeList_data_model.fromJson(json.decode(response.body)).status);

      if (_success == 200) {

    loaderFunction(false);
    _recipe_data_List = (RecipeList_data_model.fromJson(json.decode(response.body)).data);
    notifyListeners();

  } else {
       loaderFunction(false);
       _recipe_data_List = [];
       print('else==============');

     }
   }else{
      loaderFunction(false);
      _recipe_data_List = [];
      notifyListeners();
      FlutterToast_message(json.decode(response.body)['message']);
    }

    return RecipeList_data_model.fromJson(json.decode(response.body));
  }

  /// Home screen single day api
   List<MealData_list> _select_tab_data_list1 = [];
  List<MealData_list>? get select_tab_data_list1 =>_select_tab_data_list1;


  List<MealData_list>? _mealData1 = [];
  List<MealData_list>? get mealData1 =>_mealData1;

  void mealDataFunction(value){
    _mealData1 = value;
    notifyListeners();
  }

  Future<Meal_Plan_Date_Data_model?> singal_day_data_gate_api1(DateTime selectDate) async {
    select_tab_data_list1!.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokanget = prefs.getString('login_user_token');
    _tokanget = tokanget!.replaceAll('"', '');

    check().then((intenet) async {
      if (intenet) {

      } else {FlutterToast_Internet();}
    });
    Map toMap() {
      var map = Map<String, dynamic>();
      map["mlp_year"] = selectDate.year.toString();
      map["mlp_month"] = selectDate.month.toString();
      map["date"] = selectDate.day.toString();
      // map["mlp_id"] = '1';
      return map;
    }
    loaderFunction2(true);
    print(Endpoints.baseURL + Endpoints.customerMealOfDay);
    var response = await http.post(
        Uri.parse(Endpoints.baseURL + Endpoints.customerMealOfDay),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json'
        }
    );

    if(response.statusCode == 200){
      loaderFunction2(false);
      _success = (Meal_Plan_Date_Data_model.fromJson(json.decode(response.body)).status);
      if (success == 200)  {
        _mealData1!.clear();
        _mealData1 =  (Meal_Plan_Date_Data_model.fromJson(json.decode(response.body))).data!.mealData;
        notifyListeners();

        for(var item1 in get_meals_planlist_data!){
          for(var item in mealData1!){

            if(int.parse(item.mtId.toString()) == item1.mtId){
              _select_tab_data_list1.add(item);
              // notifyListeners();
              print(select_tab_data_list1!.length.toString());
            }
          }
        }
        loaderFunction2(false);
        notifyListeners();
      } else {

        loaderFunction2(false);
        print('else==============');
        // FlutterToast_message('No meals includes on the selected date.');
      }
    }
    else{
      loaderFunction2(false);

      FlutterToast_message(json.decode(response.body)['message']);
    }


    return Meal_Plan_Date_Data_model.fromJson(json.decode(response.body));
  }
  List<MealPlaneLestData_Response>? _get_meals_planlist_data;
  List<MealPlaneLestData_Response>? get get_meals_planlist_data =>_get_meals_planlist_data;


  Future<MealPlaneLestData_Model?> get_meals_plantypelist_api() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokanget = prefs.getString('login_user_token');
    _tokanget = tokanget!.replaceAll('"', '');

    check().then((intenet) async {
      if (intenet != null && intenet) {

      } else {FlutterToast_Internet();}
    });
    loaderFunction2(true);
    var response = await http.get(
        Uri.parse(Endpoints.baseURL + Endpoints.mealTimeList),

        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json'
        }
    );
    if(response.statusCode ==200){
      _success = (MealPlaneLestData_Model.fromJson(json.decode(response.body)).status);
      print("json.decode(response.body)${json.decode(response.body)}");
      if (success == 200) {

        _get_meals_planlist_data = (MealPlaneLestData_Model.fromJson(json.decode(response.body))).data;
        singal_day_data_gate_api1(DateTime.now());
        recipeList_ditels_api();
        notifyListeners();
        // Get.to(() => Pre_Question_Screen());
      } else {
        // Navigator.pop(context);
        print('else==============');
        FlutterToast_message('No Data');
      }
    }
    else{
      loaderFunction(false);
      _get_meals_planlist_data = [];

      notifyListeners();
      FlutterToast_message(json.decode(response.body)['message']);
    }


    return (MealPlaneLestData_Model.fromJson(json.decode(response.body)));
  }



  /// Recipe like api function  ///
  likeRecipeData1(context,recipeId) async {
    recipe_like_api(recipeId);
    notifyListeners();
  }
  /// recipe_like_api //////////////////

  Future<recipe_like_unlike_data_model> recipe_like_api(recipeId) async {
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
      map["rec_id"] = recipeId.toString();
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
      }else {
        print('else==============');
        FlutterToast_message(_message);

      }
    }
    else{
      loaderFunction(false);
      FlutterToast_message(json.decode(response.body)['message']);
    }
    return recipe_like_unlike_data_model.fromJson(json.decode(response.body));
  }



  /// Recipe like api function  ///
  unlikeRecipeData1(context,recipeId,txtSearch,favFilter) async {
    recipe_unlike_api(context,recipeId,txtSearch,favFilter);
    notifyListeners();
  }

  /// recipe_unlike_api ///////////////////

  Future<recipe_like_unlike_data_model> recipe_unlike_api(context,recipeId,txtSearch,favFilter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _tokanget = prefs.getString('login_user_token');
    _tokanget = _tokanget!.replaceAll('"', '');
    _user_id = prefs.getString('login_user_id');
    _user_id = _user_id!.replaceAll('"', '');

    print(_tokanget.toString());
    check().then((intenet) async {
      if (intenet) {

      } else {
        FlutterToast_Internet();
      }
    });

    Map toMap() {
      var map = Map<String, dynamic>();
      map["rec_id"] = recipeId.toString();
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
      }else {
        print('else==============');
        FlutterToast_message(_message);

      }
    }
    else{
      loaderFunction(false);
      FlutterToast_message(json.decode(response.body)['message']);
    }
    return recipe_like_unlike_data_model.fromJson(json.decode(response.body));
  }

  /// recipe Collection List ///////////////////

  List<RecipeCollectionListResponse>? _recipeCollectionList = [];
  List<RecipeCollectionListResponse>? get recipeCollectionList => _recipeCollectionList;

  Future<RecipeCollectionListModel> recipeCollectionList_api() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _tokanget = prefs.getString('login_user_token');
    _tokanget = _tokanget!.replaceAll('"', '');

    print(_tokanget.toString());
    check().then((intenet) async {
      if (intenet) {

      } else {
        FlutterToast_Internet();
      }
    });

    var response = await http.get(
        Uri.parse(Endpoints.baseURL + Endpoints.recipeCollectionList),
        headers: {
          'Authorization': 'Bearer $_tokanget',
          'Accept': 'application/json'
        }
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      _success = (RecipeCollectionListModel
          .fromJson(json.decode(response.body))
          .status);

      print("success 123 ==${_success}");
      if (_success == 200) {
        _recipeCollectionList =  (RecipeCollectionListModel.fromJson(json.decode(response.body)).data);
        notifyListeners();
      }else {
        print('else==============');

      }
    }
    else{
      loaderFunction(false);
      FlutterToast_message(json.decode(response.body)['message']);
    }
    return RecipeCollectionListModel.fromJson(json.decode(response.body));
  }

}