import 'package:aylahealth/models/recipelist/RecipeList_data_model.dart';
import 'package:aylahealth/models/recipelist/filtter_list_models/RecipeCategoryList_Model.dart';
import 'package:aylahealth/models/recipelist/filtter_list_models/Recipe_Filtter_model.dart';
import 'package:aylahealth/models/recipelist/recipe_like_unlike_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/api_common_fuction.dart';
import '../../../../common/check_screen.dart';
import '../../../../common/styles/Fluttertoast_internet.dart';
import '../../../common/styles/showLoaderDialog_popup.dart';
import '../../../models/profile/user_details_model.dart';
import '../../tabbar_screens/support_screen/message/chat/firebase_services.dart';

class userprofile_Provider with ChangeNotifier {

  int? _success ;
  int? get success => _success;

  String? _message ;
  String? get message => _message;

  String? _tokanget ;
  String? get tokanget => _tokanget;

  String? _user_id ;
  String? get user_id => _user_id;

  bool loading = false;


  user_details_esponse? _user_details_data;
  user_details_esponse? get user_details_data => _user_details_data;
  void userdetailsdata( newMessage) {
    _user_details_data = newMessage;
    notifyListeners();
  }
  /// User Details Api ///

  Future<user_details_model> customer_ditels_api(context) async {
    loading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();

      _tokanget = prefs.getString('login_user_token');
      _tokanget = tokanget!.replaceAll('"', '');
      _user_id = prefs.getString('login_user_id');
      _user_id = user_id!.replaceAll('"', '');

    print(tokanget.toString());
    check().then((intenet) async {
      if (intenet != null && intenet) {
        // Internet Present Case

       // showLoaderDialog_popup(context,"User Details ...");

      } else {
        FlutterToast_Internet();
      }
    });
    Map toMap() {
      var map =  Map<String, dynamic>();

      map["cust_id"] = user_id;

      return map;
    }
    var response = await http.post(
        Uri.parse(Endpoints.baseURL+Endpoints.customerDetails),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json'
        }
    );
    loading = false;
    print(response.body.toString());
    _success = (user_details_model.fromJson(json.decode(response.body)).status);
    print("success 123 ==${success}");
    if (success == 200) {
      loading = false;
     // Navigator.pop(context);

      _user_details_data = (user_details_model.fromJson(json.decode(response.body)).data);
      FirebaseData.instance.userUpdate();
      notifyListeners();
      // Get.to(() => Pre_Question_Screen());

    } else {
      loading = false;
    //  Navigator.pop(context);
      print('else==============');

      FlutterToast_message('No Data');

    }
    return user_details_model.fromJson(json.decode(response.body));
  }

}