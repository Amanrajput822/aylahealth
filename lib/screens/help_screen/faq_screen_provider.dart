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
import '../../models/FAQs_Question_Answer_modal.dart';

class FAQsScreenProvider with ChangeNotifier {

  int? _success ;
  int? get success => _success;

  String? _tokanget ;
  String? get tokanget => _tokanget;

  bool? _loading = false;
  bool? get loading => _loading;

  DateTime _selectedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;

  void selectedDay_data( newMessage) {
    _selectedDay = newMessage;
    notifyListeners();
  }
  List<FAQsQuestionAnswerResponse>? _FAQs_Heading_list;
  List<FAQsQuestionAnswerResponse>? get FAQs_Heading_list => _FAQs_Heading_list;


  Future<FAQsQuestionAnswerModal> faq_qus_ans_api() async {
    _loading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _tokanget = prefs.getString('login_user_token');
    _tokanget = _tokanget!.replaceAll('"', '');

    check().then((intenet) async {
      if (intenet != null && intenet) {
        _loading = true;
      } else {
        FlutterToast_Internet();
      }
    });

    var response = await http.post(
        Uri.parse(beasurl + faqList),
        headers: {
          'Authorization': 'Bearer $_tokanget',
          'Accept': 'application/json'
        }
    );
    if (response.statusCode == 200) {
      _loading = false;
      print(response.body.toString());
      _success = (FAQsQuestionAnswerModal.fromJson(json.decode(response.body)).status);
      _FAQs_Heading_list = (FAQsQuestionAnswerModal.fromJson(json.decode(response.body)).data);

      print("success 123 ==${_success}");
      if (_success == 200) {
        _loading = false;
       // FlutterToast_message("");
        notifyListeners();
      }
    }
    else {
      print('else==============');
      FlutterToast_message("no data found");
    }
    return FAQsQuestionAnswerModal.fromJson(json.decode(response.body));
  }



}