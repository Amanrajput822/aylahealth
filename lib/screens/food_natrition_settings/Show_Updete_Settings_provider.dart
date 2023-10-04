import 'package:aylahealth/models/recipelist/RecipeList_data_model.dart';
import 'package:aylahealth/models/recipelist/filtter_list_models/RecipeCategoryList_Model.dart';
import 'package:aylahealth/models/recipelist/filtter_list_models/Recipe_Filtter_model.dart';
import 'package:aylahealth/models/recipelist/recipe_like_unlike_data_model.dart';
import 'package:aylahealth/screens/food_natrition_settings/Country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/api_common_fuction.dart';
import '../../../../common/check_screen.dart';
import '../../../../common/styles/Fluttertoast_internet.dart';
import '../../../common/styles/showLoaderDialog_popup.dart';
import '../../../models/profile/user_details_model.dart';
import '../../models/food_nutrition_settings/customerFoodSettingData_model.dart';
import '../../models/food_nutrition_settings/customerFoodSettingHeadingList_model.dart';
import '../../models/onboarding_screens_models/Answer_submit_Model.dart';
import '../../models/onboarding_screens_models/customerNutritionArea_model.dart';
import '../../models/onboarding_screens_models/ingredient_name_list_model.dart';
import 'Food_Nutrition_Settings_provider.dart';

class Show_Updete_Settings_provider with ChangeNotifier {

  int? _success ;
  int? get success => _success;

  String? _message ;
  String? get message => _message;

  String? _tokanget ;
  String? get tokanget => _tokanget;


  bool loading = false;

  final List<String> _selectedItems = [];
   List<String> get selectedItems => _selectedItems;
  void itemChange(String itemValue, bool isSelected) {

      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
      print(_selectedItems.length.toString());
      print('_selectedItems.length.toString()');
      print(_selectedItems.length.toString());
      print(itemValue);
      notifyListeners();

  }

  List<Country>? _countries = [];
  List<Country>? get countries => _countries;

  List<Country>? _countries1=[];
  List<Country>? get countries1 => _countries1;


  List<Ingredient_Name_List_Risponce>? _food_data_list;
  List<Ingredient_Name_List_Risponce>? get food_data_list =>_food_data_list;

  Future<Ingredient_Name_List_Model> Ingredient_Name_List_api(context) async {
    loading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();

      _tokanget = prefs.getString('login_user_token');
      _tokanget = tokanget!.replaceAll('"', '');

    print(tokanget.toString());
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        // showLoaderDialog(context,'Ingredient Name List....');

      } else {
        FlutterToast_Internet();
      }
    });

    var response = await http.post(
        Uri.parse(baseURL+ingredientNameList),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json'
        }
    );
    loading = false;
    print(response.body.toString());
    _success = (Ingredient_Name_List_Model.fromJson(json.decode(response.body)).status);
    print("success 123 ==${success}");
    if (success == 200) {
      loading = false;
      // Navigator.pop(context);
      _food_data_list = (Ingredient_Name_List_Model.fromJson(json.decode(response.body)).data);
      _countries = List<Country>.generate(
        food_data_list!.length,
            (index) => Country(
          name: food_data_list![index].ingName!,
          iso: food_data_list![index].ingId!,
        ),
      );
      notifyListeners();
      // Get.to(() => Pre_Question_Screen());
    } else {
      loading = false;
      print('else==============');

      FlutterToast_message('No Question Data');
    }
    return Ingredient_Name_List_Model.fromJson(json.decode(response.body));
  }
///////////////////// customerFoodSettingData_api API /////////////////


  //List<Options>? options_list;
  String? _select ;
  String? get select => _select;
  void select_fuction(newMessage){
    _select = newMessage;
    notifyListeners();
  }

  List<CustomerAnswer1>? customerAnswer_list;
  Future<customerFoodSettingData_model> customerFoodSettingData_api(context,qut_id,que_AnswerSource,qut_type) async {
    loading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();

      _tokanget = prefs.getString('login_user_token');
    _tokanget = tokanget!.replaceAll('"', '');

    print(tokanget.toString());
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
       // showLoaderDialog1(context);


      } else {
        FlutterToast_Internet();
      }
    });

    Map toMap() {
      var map =  Map<String, dynamic>();
      map["que_id"] = qut_id.toString();
      map["que_answer_source"] = que_AnswerSource.toString();
      return map;
    }
    print(toMap());
    var response = await http.post(
        Uri.parse(baseURL+customerFoodSettingData),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json'
        }
    );
    loading = false;
    print(response.body.toString());
    _success = (customerFoodSettingData_model.fromJson(json.decode(response.body)).status);
    print("success 123 ==${success}");
    if (success == 200) {
      loading = false;
      // options_list = (customerFoodSettingData_model.fromJson(json.decode(response.body)).data!.options);
      customerAnswer_list = (customerFoodSettingData_model.fromJson(json.decode(response.body)).data!.customerAnswer);

      notifyListeners();
      for(int i=0;i<customerAnswer_list!.length;i++)

      {

          if(qut_type=="MULTIPLE"&& que_AnswerSource=='INGREDIENT'){

            itemChange(customerAnswer_list![i].ingId.toString(), true);
            // countries1!.add(Country(name:customerAnswer_list![i].opsText.toString(), iso:customerAnswer_list![i].ingId!));
            _countries1 = List<Country>.generate(
              customerAnswer_list!.length,
                  (index) => Country(
                name: customerAnswer_list![index].opsText!,
                iso: customerAnswer_list![index].ingId!,
              ),
            );
          }

          else if(qut_type=="SINGLE"){
            if(customerAnswer_list![i].isAnswer == 1){
              _select = customerAnswer_list![i].opsId.toString();
            }
          }

          else if(qut_type=="MULTIPLE"&&que_AnswerSource=="OPTION"){
            itemChange(customerAnswer_list![i].opsId.toString(), customerAnswer_list![i].isAnswer == 1?true:false);
            //   options_list!.removeWhere((m) => m.opsId == int.parse(customerAnswer_list![i].opsId.toString()));
            //  options_list!.add(Options( opsText: customerAnswer_list![i].opsText.toString(),isSelected: true,opsId:int.parse(customerAnswer_list![i].opsId.toString()) ));
          }


      }
      notifyListeners();
      // Get.to(() => Pre_Question_Screen());
    } else {
      loading = false;
      print('else==============');

      FlutterToast_message('No Question Data');

    }
    return customerFoodSettingData_model.fromJson(json.decode(response.body));
  }

  Future<Answer_submit_Model> add_Customer_Answer_up(context,String queid ,String quetype) async {
    print('add_Customer_Answer_up');
    SharedPreferences prefs = await SharedPreferences.getInstance();

      _tokanget = prefs.getString('login_user_token');
    _tokanget = tokanget!.replaceAll('"', '');

    print(tokanget.toString());
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        showLoaderDialog_popup(context,"submit Answer ...");

      } else {
        FlutterToast_Internet();
      }
    });
    Map toMap() {
      var map =  Map<String, dynamic>();
      map["que_id"] = queid;
      map["que_type"] = quetype;
      if(quetype == 'MULTIPLE'){
        map["opsIds"] = _selectedItems;
      }
      else if(quetype == 'SINGLE') {
        map["ops_id"] = select.toString();
      }else if(quetype == 'INDEXING'){
        map["optionData"] = [
          for(int i = 0;i<customerNutritionArea_data_list!.length;i++)
            {
              "ops_id": customerNutritionArea_data_list![i].opsId.toString(),
              "ops_index": (i+1).toString()
            }
        ];

      };
      return map;
    }
    notifyListeners();
    print(toMap().toString());
    print(json.encode(toMap()).toString());
    var response = await http.post(
        Uri.parse(baseURL+addOrUpdateCustomerAnswer),
        body:(quetype == 'MULTIPLE'|| quetype == 'INDEXING')?json.encode(toMap()):toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json',
          if(quetype == 'MULTIPLE'|| quetype == 'INDEXING') 'Content-Type': 'application/json'
        }
    );
    print(response.body.toString());
    _success = (Answer_submit_Model.fromJson(json.decode(response.body)).status);
    var message = (Answer_submit_Model.fromJson(json.decode(response.body)).message);
    print("success 123 ==${success}");
    if (success == 200) {
      Navigator.pop(context);
      // Get.to(() => Pre_Question_Screen());
      FlutterToast_message('Settings updated successfully');
      Provider.of<Food_Nutrition_Settings_provider>(context, listen: false).customerFoodSettingHeadingList_api(context);


      _select = null;
      _selectedItems.clear();
      notifyListeners();
    } else {
      Navigator.pop(context);
      print('else==============');

      FlutterToast_message(message);

    }
    return Answer_submit_Model.fromJson(json.decode(response.body));
  }


  List<customerNutritionArea_recponce>? _customerNutritionArea_data_list;
  List<customerNutritionArea_recponce>?get customerNutritionArea_data_list =>_customerNutritionArea_data_list;

  Future<customerNutritionArea_model> customerNutritionArea_data_list_api(context) async {
   loading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _tokanget = prefs.getString('login_user_token');
    _tokanget = tokanget!.replaceAll('"', '');

    print(tokanget.toString());
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        // showLoaderDialog(context ,"Customer NutritionArea Data...");

      } else {
        FlutterToast_Internet();
      }
    });

    var response = await http.post(
        Uri.parse(baseURL+customerNutritionArea),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json',
        }
    );

    print(response.body.toString());
    _success = (customerNutritionArea_model.fromJson(json.decode(response.body)).status);
    print("success 1233434 ==${success}");
    if (success == 200) {
      // Navigator.pop(context);
      loading = false;
        _customerNutritionArea_data_list = (customerNutritionArea_model.fromJson(json.decode(response.body)).data);
        notifyListeners();
      // Get.to(() => Pre_Question_Screen());
      print("success 123 ==${customerNutritionArea_data_list!.length.toString()}");
    } else {
      loading = false;
      print('else==============');

      FlutterToast_message('No Data');

    }
    return customerNutritionArea_model.fromJson(json.decode(response.body));
  }

}