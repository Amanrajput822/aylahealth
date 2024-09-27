import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/api_common_fuction.dart';
import '../../../../common/check_screen.dart';
import '../../../../common/direct_logout.dart';
import '../../../../common/styles/Fluttertoast_internet.dart';
import '../../../../models/modules/customerModuleViewStatusModal.dart';
import '../../../../models/modules/modulePagesContentListDataModel.dart';
import '../../../../models/modules/searchModuleModel.dart';
import '../../../../models/modules/updateCustomerModuleViewStatusModal.dart';
import '../../../../models/recipelist/Recipe_details_data_model.dart';


class SearchModuleScreenProvider with ChangeNotifier {
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

  bool? _dataList = false;
  bool? get dataList => _dataList;


  List<searchModuleResponse>? _searchDataList;
  List<searchModuleResponse>? get searchDataList => _searchDataList;

  Future<searchModuleModel?> searchModule_api(searchData) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokenGet = prefs.getString('login_user_token');
    _tokenGet = tokenGet!.replaceAll('"', '');

    check().then((intenet) async {
      if (intenet) {

      } else {FlutterToast_Internet();}
    });
    Map toMap() {
      var map = Map<String, dynamic>();
      map["search"] = searchData??"";
      return map;
    }
    loaderFunction(true);
    print("toMap()${toMap()}");
    var response = await http.post(
        Uri.parse(Endpoints.baseURL + Endpoints.searchModule),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokenGet',
          'Accept': 'application/json'
        }
    );
    print("response:${response.body}");
    if(response.statusCode ==200){
      loaderFunction(false);
      _success = (searchModuleModel.fromJson(json.decode(response.body)).status);
      print("json.decode(response.body)${json.decode(response.body)}");
      if (success == 200) {
        _searchDataList =(searchModuleModel.fromJson(json.decode(response.body)).data);
        _dataList = true;
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


    return (searchModuleModel.fromJson(json.decode(response.body)));
  }


}