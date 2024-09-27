import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/SharedPrefHelper.dart';
import '../../../../common/api_common_fuction.dart';
import '../../../../common/check_screen.dart';
import '../../../../common/direct_logout.dart';
import '../../../../common/styles/Fluttertoast_internet.dart';
import '../../../../models/meals plans/MealPlaneLestData_Model.dart';
import '../../../../models/modules/continueLearningModuleListModal.dart';
import '../../../../models/modules/freeModuleListModel.dart';
import '../../../../models/modules/moduleLibraryDataModel.dart';
import '../../../../models/recipelist/Recipe_details_data_model.dart';


class ModulesScreenProvider with ChangeNotifier {
  int? _success ;
  int? get success => _success;

  String? _message ;
  String? get message => _message;

  String? _tokenGet ;
  String? get tokenGet => _tokenGet;


   bool _loading = false;
  bool get loading => _loading;
  void loaderFunction(newMessage){
    _loading = newMessage;
    notifyListeners();
  }







  // bool? _iconColor = false;
  // bool? get iconColor => _iconColor;
  //
  // void IconColor(newMessage){
  //   _iconColor = newMessage;
  //   notifyListeners();
  // }

  List<moduleLibraryDataResponse>? _moduleLibraryData;
  List<moduleLibraryDataResponse>? get moduleLibraryData => _moduleLibraryData;

  void updateCmvsStatus(int mdId, int newStatus) {

    // Locate the module by mdId and update its status
    for (var module in moduleLibraryData!) {
      for (var subCategory in module.subCategory!) {
        for (var moduleData in subCategory.moduleData!) {
          if (moduleData.mdId == mdId) {
            moduleData.cmvsStatus = newStatus;
            print(moduleData.cmvsStatus);
            print(newStatus);
            notifyListeners(); // Notify listeners to update the UI
            return;
          }
        }
      }
    }}

   ///  get module Library api
  Future<moduleLibraryDataModel?> get_moduleLibrary_api() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokenGet = prefs.getString('login_user_token');
    _tokenGet = tokenGet!.replaceAll('"', '');

    check().then((intenet) async {
      if (intenet != null && intenet) {

      } else {FlutterToast_Internet();}
    });
    loaderFunction(true);
    var response = await http.post(
        Uri.parse(Endpoints.baseURL + Endpoints.moduleLibrary),

        headers: {
          'Authorization': 'Bearer $tokenGet',
          'Accept': 'application/json'
        }
    );
    print("json.decode(response.body):${json.decode(response.body)}");
    if(response.statusCode ==200){
      loaderFunction(false);
      _success = (moduleLibraryDataModel.fromJson(json.decode(response.body)).status);
      print("json.decode(response.body)${json.decode(response.body)}");
      if (success == 200) {
        _moduleLibraryData = (moduleLibraryDataModel.fromJson(json.decode(response.body)).data);
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


    return (moduleLibraryDataModel.fromJson(json.decode(response.body)));
  }

  ///  continue Learning Module List

  List<continueLearningModuleListResponse>? _continueLearningModuleListData;
  List<continueLearningModuleListResponse>? get continueLearningModuleListData => _continueLearningModuleListData;

  bool _loading1 = false;
  bool get loading1 => _loading1;
  void loader1Function(newMessage){
    _loading1 = newMessage;
    notifyListeners();
  }

  String? _learningStatus = "Start Learning";
  String? get learningStatus => _learningStatus;
  void learningStatusFunction(newMessage){
    _learningStatus = newMessage;

    print("newMessage ${newMessage}");

    notifyListeners();
  }

  Future<continueLearningModuleListModal?> continueLearningModuleList_api() async {
    print("continueLearningModuleList data:0");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokenGet = prefs.getString('login_user_token');
    _tokenGet = tokenGet!.replaceAll('"', '');

    check().then((intenet) async {
      if (intenet != null && intenet) {

      } else {FlutterToast_Internet();}
    });
    loader1Function(true);
    // var body = json.encode({
    //   "cmvs_status": [cmvsStatus]
    // });
    // print("continueLearningModuleList body ${body}");

    var response = await http.post(
        Uri.parse(Endpoints.baseURL + Endpoints.continueLearningModuleList),
      //  body: body,
        headers: {
          'Authorization': 'Bearer $tokenGet',
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
    );
    print("continueLearningModuleList data:1${json.decode(response.body)}");
    if(response.statusCode ==200){
      loader1Function(false);
      _success = (continueLearningModuleListModal.fromJson(json.decode(response.body)).status);
      print("continueLearningModuleList data:2${continueLearningModuleListModal.fromJson(json.decode(response.body)).data}");
      print("continueLearningModuleList data:2${continueLearningModuleListModal.fromJson(json.decode(response.body)).data!.isEmpty}");
      if (success == 200) {
        learningStatusFunction("Continue Learning");
        SharedPrefHelper.learningStatus =  "Continue Learning";
         var data = (continueLearningModuleListModal.fromJson(json.decode(response.body)).data);
       //  print("data!.isEmpty${data!.isEmpty}");
       //  print("cmvsStatus == 1${cmvsStatus == 1}");
       //  print("data!.isEmpty && cmvsStatus == 1${data!.isEmpty && cmvsStatus == 1}");
       // if(cmvsStatus == 1){
       //   learningStatusFunction("Start Learning");
       // }else{
       //   learningStatusFunction("Continue Learning");
       // }
        // if ( data.isEmpty && cmvsStatus == 1) {
        //
        //   // If data is empty and cmvsStatus is 1, call the API again with cmvsStatus 2
        //   await continueLearningModuleList_api(2);
        // } else {
        //   _continueLearningModuleListData = data;
        //   notifyListeners();
        // }

        _continueLearningModuleListData = data;
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


    return (continueLearningModuleListModal.fromJson(json.decode(response.body)));
  }


  List<freeModuleListResponse>? _freeModuleListData;
  List<freeModuleListResponse>? get freeModuleListData => _freeModuleListData;

  Future<freeModuleListModel?> freeModuleList_api() async {
    print("freeModuleList_api data:0");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokenGet = prefs.getString('login_user_token');
    _tokenGet = tokenGet!.replaceAll('"', '');

    check().then((intenet) async {
      if (intenet != null && intenet) {

      } else {FlutterToast_Internet();}
    });
    loader1Function(true);
    // var body = json.encode({
    //   "cmvs_status": [cmvsStatus]
    // });
    // print("continueLearningModuleList body ${body}");

    var response = await http.post(
        Uri.parse(Endpoints.baseURL + Endpoints.freeModuleList),
        //  body: body,
        headers: {
          'Authorization': 'Bearer $tokenGet',
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
    );
    print("freeModuleList_api data:1${json.decode(response.body)}");
    if(response.statusCode ==200){
      loader1Function(false);
      _success = (freeModuleListModel.fromJson(json.decode(response.body)).status);
      print("freeModuleList_api data:2${freeModuleListModel.fromJson(json.decode(response.body)).data}");
      print("freeModuleList_api data:2${freeModuleListModel.fromJson(json.decode(response.body)).data!.isEmpty}");
      if (success == 200) {
        var data = (freeModuleListModel.fromJson(json.decode(response.body)).data);
        //  print("data!.isEmpty${data!.isEmpty}");
        //  print("cmvsStatus == 1${cmvsStatus == 1}");
        //  print("data!.isEmpty && cmvsStatus == 1${data!.isEmpty && cmvsStatus == 1}");
        // if(cmvsStatus == 1){
        //   learningStatusFunction("Start Learning");
        // }else{
        //   learningStatusFunction("Continue Learning");
        // }
        if ( data!.isEmpty  ) {
          _freeModuleListData = null;
          // If data is empty and cmvsStatus is 1, call the API again with cmvsStatus 2
          await continueLearningModuleList_api();
        } else {
          learningStatusFunction("Start Learning");
          SharedPrefHelper.learningStatus =  "Start Learning";
          _freeModuleListData = data;
          notifyListeners();
        }

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


    return (freeModuleListModel.fromJson(json.decode(response.body)));
  }

}