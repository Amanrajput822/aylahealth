import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/api_common_fuction.dart';
import '../../../../common/check_screen.dart';
import '../../../../common/direct_logout.dart';
import '../../../../common/new_bottombar_screen/New_Bottombar_Screen.dart';
import '../../../../common/styles/Fluttertoast_internet.dart';
import '../../../../models/modules/customerModuleViewStatusModal.dart';
import '../../../../models/modules/moduleDetailsForAppDataModel.dart';
import '../../../../models/modules/modulePagesContentListDataModel.dart';
import '../../../../models/modules/updateCustomerModuleViewStatusModal.dart';
import '../../../../models/recipelist/Recipe_details_data_model.dart';
import '../../../../models/recipelist/recipe_like_unlike_data_model.dart';
import '../modules_screen/modules_screen_provider.dart';


class ModulesDescriptionScreenProvider with ChangeNotifier {

   PageController _pageController = PageController();
   PageController get pageController => _pageController;



  int? _success ;
  int? get success => _success;

  String? _message ;
  String? get message => _message;

  String? _tokenGet ;
  String? get tokenGet => _tokenGet;



  String? _user_id ;
  String? get user_id => _user_id;


  String? _buttonType = 'Start Module';
  String? get buttonType => _buttonType;

  void buttonTypeFunction(newMessage){
    _buttonType = newMessage;
  //  notifyListeners();
  }


  bool _loading = false;
  bool get loading => _loading;
  void loaderFunction(newMessage){
    _loading = newMessage;
    notifyListeners();
  }
  int _pageLearnIndex = 0;
  int get pageLearnIndex => _pageLearnIndex;
  void pageLearnIndexFunction(newMessage){
    _pageLearnIndex = newMessage;
    notifyListeners();
  }

  int _pageApplyIndex = 0;
  int get pageApplyIndex => _pageApplyIndex;
  void pageApplyIndexFunction(newMessage){
    _pageApplyIndex = newMessage;
    notifyListeners();
  }
  /// module pages content list api

  List<modulePagesContentListDataResponse>? _modulePagesContentListData;
  List<modulePagesContentListDataResponse>? get modulePagesContentListData => _modulePagesContentListData;

  Future<modulePagesContentListDataModel?> modulePagesContentList_api(mdId,mpType) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokenGet = prefs.getString('login_user_token');
    _tokenGet = tokenGet!.replaceAll('"', '');

    check().then((intenet) async {
      if (intenet != null && intenet) {

      } else {FlutterToast_Internet();}
    });
    Map toMap() {
      var map = Map<String, dynamic>();
      map["md_id"] = mdId??"";
      map["mp_type"] = mpType??"";

      // map["mlp_id"] = '1';
      return map;
    }
    loaderFunction(true);
    print("toMap()${toMap()}");
    var response = await http.post(
        Uri.parse(Endpoints.baseURL + Endpoints.modulePagesContentList),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokenGet',
          'Accept': 'application/json'
        }
    );
    if(response.statusCode ==200){
      loaderFunction(false);
      _success = (modulePagesContentListDataModel.fromJson(json.decode(response.body)).status);
      print("json.decode(response.body)${json.decode(response.body)}");
      if (success == 200) {
        loaderFunction(false);
        _modulePagesContentListData = (modulePagesContentListDataModel.fromJson(json.decode(response.body)).data);
        notifyListeners();
        // Get.to(() => Pre_Question_Screen());
      } else {
        loaderFunction(false);
        // Navigator.pop(context);
        print('else==============');
        FlutterToast_message('No Data');
      }
    }
    else{
      loaderFunction(false);

      if(response.statusCode ==401){
        directLogOutPopup();
      }
      notifyListeners();
      FlutterToast_message(json.decode(response.body)['message']);
    }


    return (modulePagesContentListDataModel.fromJson(json.decode(response.body)));
  }
  /// update customer module view status api

  Future<updateCustomerModuleViewStatusModal?> updateCustomerModuleViewStatus_api(mdId,cmvsStatus) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokenGet = prefs.getString('login_user_token');
    _tokenGet = tokenGet!.replaceAll('"', '');

    check().then((intenet) async {
      if (intenet) {

      } else {FlutterToast_Internet();}
    });
    Map toMap() {
      var map = Map<String, dynamic>();
      map["md_id"] = mdId??"";
      map["cmvs_status"] = cmvsStatus??"";

      return map;
    }
    loaderFunction(true);
    print("toMap()${toMap()}");
    var response = await http.post(
        Uri.parse(Endpoints.baseURL + Endpoints.updateCustomerModuleViewStatus),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokenGet',
          'Accept': 'application/json'
        }
    );
    print("response:${response.body}");
    if(response.statusCode ==200){
      loaderFunction(false);
      _success = (updateCustomerModuleViewStatusModal.fromJson(json.decode(response.body)).status);
      print("json.decode(response.body)${json.decode(response.body)}");
      if (success == 200) {

        customerModuleViewStatus_api(mdId);
        loaderFunction(false);
        notifyListeners();
        // Get.to(() => Pre_Question_Screen());
      } else {
        loaderFunction(false);
        // Navigator.pop(context);
        print('else==============');
        FlutterToast_message('No Data');
      }
    }
    else{
      loaderFunction(false);

      if(response.statusCode ==401){
        directLogOutPopup();
      }
      notifyListeners();
      FlutterToast_message(json.decode(response.body)['message']);
    }


    return (updateCustomerModuleViewStatusModal.fromJson(json.decode(response.body)));
  }

  /// customer module view status api

  customerModuleViewStatusResponse? _customerModuleViewStatusData;
  customerModuleViewStatusResponse? get customerModuleViewStatusData =>_customerModuleViewStatusData;


  Future<customerModuleViewStatusModal?> customerModuleViewStatus_api(mdId) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokenGet = prefs.getString('login_user_token');
    _tokenGet = tokenGet!.replaceAll('"', '');

    check().then((intenet) async {
      if (intenet) {

      } else {FlutterToast_Internet();}
    });
    Map toMap() {
      var map = Map<String, dynamic>();
      map["md_id"] = mdId??"";
      return map;
    }
    loaderFunction(true);
    print("toMap()${toMap()}");
    var response = await http.post(
        Uri.parse(Endpoints.baseURL + Endpoints.customerModuleViewStatus),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokenGet',
          'Accept': 'application/json'
        }
    );
    if(response.statusCode ==200){
      loaderFunction(false);
      _success = (customerModuleViewStatusModal.fromJson(json.decode(response.body)).status);
      print("json.decode(response.body) customerModuleViewStatus ${json.decode(response.body)}");

      // if(customerModuleViewStatusModal.fromJson(json.decode(response.body)).data == null ||
      //     customerModuleViewStatusModal.fromJson(json.decode(response.body)).data == "null"){
      //  // updateCustomerModuleViewStatus_api(mdId,"1");
      //
      //   _customerModuleViewStatusData = null;
      //
      //   buttonTypeCheckFunction();
      //   notifyListeners();
      //   print('start module first time');
      // }
      if (success == 200) {

        _customerModuleViewStatusData =(customerModuleViewStatusModal.fromJson(json.decode(response.body)).data);
        final modulesProviderData = Provider.of<ModulesScreenProvider>(testContext!, listen: false);
      //  modulesProviderData.continueLearningModuleList_api();
        modulesProviderData.freeModuleList_api();
        buttonTypeCheckFunction();
        loaderFunction(false);
        notifyListeners();
        // Get.to(() => Pre_Question_Screen());
      } else {
        loaderFunction(false);
        // Navigator.pop(context);
        print('else==============');
        FlutterToast_message('No Data');
      }
    }
    else{
      loaderFunction(false);

      if(response.statusCode ==401){
        directLogOutPopup();
      }
      notifyListeners();
      FlutterToast_message(json.decode(response.body)['message']);
    }


    return (customerModuleViewStatusModal.fromJson(json.decode(response.body)));
  }

  ///  module details api
  bool _loading1 = false;
  bool get loading1 => _loading1;
  void loader1Function(newMessage){
    _loading1 = newMessage;
    notifyListeners();
  }

  moduleDetailsForAppDataResponse? _moduleDetailsForAppData;
  moduleDetailsForAppDataResponse? get moduleDetailsForAppData => _moduleDetailsForAppData;

  Future<moduleDetailsForAppDataModel?> moduleDetailsForApp_api(mdId) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokenGet = prefs.getString('login_user_token');
    _tokenGet = tokenGet!.replaceAll('"', '');

    check().then((intenet) async {
      if (intenet) {

      } else {FlutterToast_Internet();}
    });
    Map toMap() {
      var map = Map<String, dynamic>();
      map["md_id"] = mdId??"";
      return map;
    }
    loader1Function(true);
    print("toMap()${toMap()}");
    var response = await http.post(
        Uri.parse(Endpoints.baseURL + Endpoints.moduleDetailsForApp),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokenGet',
          'Accept': 'application/json'
        }
    );
    if(response.statusCode ==200){
      loader1Function(false);
      _success = (moduleDetailsForAppDataModel.fromJson(json.decode(response.body)).status);
      print("json.decode(response.body) moduleDetailsForApp:${json.decode(response.body)}");
     customerModuleViewStatus_api(mdId??"");

      if (success == 200) {
        _moduleDetailsForAppData = (moduleDetailsForAppDataModel.fromJson(json.decode(response.body)).data);

        loader1Function(false);
        notifyListeners();
        // Get.to(() => Pre_Question_Screen());
      } else {
        loader1Function(false);
        // Navigator.pop(context);
        print('else==============');
        FlutterToast_message('No Data');
      }
    }
    else{
      loader1Function(false);

      if(response.statusCode ==401){
        directLogOutPopup();
      }
      notifyListeners();
      FlutterToast_message(json.decode(response.body)['message']);
    }


    return (moduleDetailsForAppDataModel.fromJson(json.decode(response.body)));
  }

  /// next button name change function

  void buttonTypeCheckFunction(){
    if(customerModuleViewStatusData!= null){
      if(customerModuleViewStatusData!.cmvsStatus == 1){
        buttonTypeFunction('Start Module');
        notifyListeners();
      }
      else if(customerModuleViewStatusData!.cmvsStatus == 2){
        buttonTypeFunction('Start Applying');
        notifyListeners();
      }
      else if(customerModuleViewStatusData!.cmvsStatus == 3){
        buttonTypeFunction('Back to Modules');
        notifyListeners();
      }
    } else {
      buttonTypeFunction('Start Module');
      notifyListeners();
    }
  }
  /// Recipe like api function  ///
  likeRecipeData1(context,recipe_id) async {
    recipe_like_api(recipe_id);
    notifyListeners();
  }
  /// Recipe like api function  ///
  unlikeRecipeData1(context,recipe_id) async {
    recipe_unlike_api(context,recipe_id);
    notifyListeners();
  }

  /// recipe_like_api //////////////////

  Future<recipe_like_unlike_data_model> recipe_like_api(recipe_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _tokenGet = prefs.getString('login_user_token');
    _tokenGet = _tokenGet!.replaceAll('"', '');
    _user_id = prefs.getString('login_user_id');
    _user_id = _user_id!.replaceAll('"', '');

    print(_tokenGet.toString());
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
          'Authorization': 'Bearer $_tokenGet',
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

    _tokenGet = prefs.getString('login_user_token');
    _tokenGet = _tokenGet!.replaceAll('"', '');
    _user_id = prefs.getString('login_user_id');
    _user_id = _user_id!.replaceAll('"', '');

    print(_tokenGet.toString());
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
          'Authorization': 'Bearer $_tokenGet',
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
        // if(fav_filter=='1'){
        //   getRecipeData(context,txt_search.toString(),fav_filter,select_cat_id,save_eatingPattern_id,selected_filter);
        //
        //   //getRecipeData(context,search_test,favorite,cat_id,eat_id,tagIds_list)
        // }
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