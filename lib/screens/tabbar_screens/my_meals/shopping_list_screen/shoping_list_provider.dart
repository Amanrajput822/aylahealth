
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/api_common_fuction.dart';
import '../../../../common/check_screen.dart';
import '../../../../common/styles/Fluttertoast_internet.dart';
import '../../../../common/styles/const.dart';
import '../../../../models/meals plans/Meals_Update_MealsPlane_nodel.dart';
import '../../../../models/shopping_list/customerShoppingListModel.dart';
import '../../../../models/shopping_list/updateShoppingItemStatus_Model.dart';

class ShoppingListProvider with ChangeNotifier {
  String error = '';

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

  /// shopping list and calendar hide show condition //
  bool _viewList_function = false;
  bool get viewList_function => _viewList_function;

  void viewListFunction( newMessage) {
    _viewList_function = newMessage;
    notifyListeners();
  }

  /// start date select function and params

  DateTime? _selectStartdate = DateTime.now();
  DateTime? get selectStartdate => _selectStartdate;
  void selectStartDate_function( newMessage) {
    _selectStartdate = newMessage;
    notifyListeners();
  }

  DateTime _focusedStartDay = DateTime.now();
  DateTime get focusedStartDay => _focusedStartDay;

  void focusedStartDay_function( newMessage) {
    _focusedStartDay = newMessage;
    notifyListeners();
  }

  String? _startDayString ;
  String? get startDayString  => _startDayString ;
  void selectStartDayString_function( newMessage) {
    _startDayString = newMessage;
    notifyListeners();
  }
  /// End date select function and params

  DateTime? _selectEnddate = DateTime.now();
  DateTime? get selectEnddate => _selectEnddate;
  void selectEndDate_function(DateTime? newMessage) {
    _selectEnddate = newMessage;
    notifyListeners();
  }

  DateTime? _focusedEndDay = DateTime.now();
  DateTime? get focusedEndDay => _focusedEndDay;

  void focusedEndDay_function(DateTime? newMessage) {
    _focusedEndDay = newMessage!;
    notifyListeners();
  }

  String? _endDayString ;
  String? get endtDayString  => _endDayString ;
  void selectEndDayString_function( newMessage) {
    _endDayString = newMessage;
    notifyListeners();
  }

  /// calendar controller
  PageController? _pageController;
  PageController? get pageController => _pageController;
  void calendarController_function( newMessage) {
    _pageController = newMessage;
    notifyListeners();
  }


  String? _dayTypeString ;
  String? get dayTypeString  => _dayTypeString ;
  void selectDayType_function( newMessage) {
    _dayTypeString = newMessage;
    notifyListeners();
  }

  List<customerShoppingListResponse>? _customerShoppingList_data = [];
  List<customerShoppingListResponse>? get customerShoppingList_data => _customerShoppingList_data;

  var _sl_startdate;
   get sl_startdate => _sl_startdate;

  var _sl_enddate;
  get sl_enddate => _sl_enddate;
  /// create Shopping List Api
  Future<customerShoppingListModel?> createShoppingList_api(context, startDate, endDate ) async {
    _customerShoppingList_data = [];
    customerShoppingListModel? result;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      _tokanget = prefs.getString('login_user_token');
      _tokanget = tokanget!.replaceAll('"', '');
      print(tokanget.toString());

      check().then((intenet) async {
        if (intenet != null && intenet) {

        } else {
          FlutterToast_Internet();
        }
      });
      Map toMap() {
        var map = Map<String, dynamic>();
        map["sl_startdate"] = startDate.toString();
        map["sl_enddate"] = endDate.toString();

        return map;
      }
      print('aman1???????????????');
      print(toMap());
      print(beasurl + createShoppingList);
      var response = await http.post(
          Uri.parse(beasurl + createShoppingList),
          body: toMap(),
          headers: {
            'Authorization': 'Bearer $tokanget',
            'Accept': 'application/json',
          }
      );
      print(response.body);
      _success = (customerShoppingListModel.fromJson(json.decode(response.body)).status);
      print(json.decode(response.body));
      if (success == 200) {
        final item = json.decode(response.body);
        result = (customerShoppingListModel.fromJson(item));
        _customerShoppingList_data = result.data;
        _sl_startdate = result.slStartdate;
        _sl_enddate = result.slEnddate;

       if(customerShoppingList_data!.isEmpty){
         warning_popup(context);
       }else{
         customerShoppingList_api(context );
       }
       //0 FlutterToast_message('Add Shopping List Data');
        notifyListeners();

      } else {
        // Navigator.pop(context);
        print('else==============');
        FlutterToast_message('No Data');
      }
    } catch (e) {
      error = e.toString();
    }
    return result;
  }


  /// customer Shopping List Api

  Future<customerShoppingListModel?> customerShoppingList_api(context ) async {
    customerShoppingListModel? result;
    try {
      _loading = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      _tokanget = prefs.getString('login_user_token');
      _tokanget = tokanget!.replaceAll('"', '');
      print(tokanget.toString());

      check().then((intenet) async {
        if (intenet) {

        } else {
          FlutterToast_Internet();
        }
      });

      print(beasurl + customerShoppingList);
      var response = await http.post(
          Uri.parse(beasurl + customerShoppingList),

          headers: {
            'Authorization': 'Bearer $tokanget',
            'Accept': 'application/json',
          }
      );
      print(json.decode(response.body));
      _success = (customerShoppingListModel.fromJson(json.decode(response.body)).status);

      if (success == 200) {
        _loading = false;
        final item = json.decode(response.body);
        result = (customerShoppingListModel.fromJson(item));
        _customerShoppingList_data = result.data;
        _sl_startdate = result.slStartdate;
        _sl_enddate = result.slEnddate;
        viewListFunction(true);
        if(customerShoppingList_data!.isNotEmpty){
          _viewList_function = true;
        }else{
          _viewList_function = false;
        }

      //  FlutterToast_message('Shopping List Data');
        notifyListeners();

      } else {
        _loading = false;
        // Navigator.pop(context);
        print('else==============');
        FlutterToast_message('No Data');
      }
    } catch (e) {
      _loading = false;
      error = e.toString();
    }
    return result;
  }

  /// update Shopping Item Status Api
  Future<updateShoppingItemStatus_Model?> updateShoppingItemStatus_api(context, slId, slItemStatus ) async {
    updateShoppingItemStatus_Model? result;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      _tokanget = prefs.getString('login_user_token');
      _tokanget = tokanget!.replaceAll('"', '');
      print(tokanget.toString());

      check().then((intenet) async {
        if (intenet != null && intenet) {

        } else {
          FlutterToast_Internet();
        }
      });
      Map toMap() {
        var map = Map<String, dynamic>();
        map["sl_id"] = slId.toString();
        map["sl_item_status"] = slItemStatus.toString();

        return map;
      }
      print('aman1???????????????');
      print(toMap());
      print(beasurl + updateShoppingItemStatus);
      var response = await http.post(
          Uri.parse(beasurl + updateShoppingItemStatus),
          body: toMap(),
          headers: {
            'Authorization': 'Bearer $tokanget',
            'Accept': 'application/json',
          }
      );
      print(response.body);
      _success = (updateShoppingItemStatus_Model.fromJson(json.decode(response.body)).status);
      _message = (updateShoppingItemStatus_Model.fromJson(json.decode(response.body)).message);
      print(json.decode(response.body));
      if (success == 200) {
        final item = json.decode(response.body);
        result = (updateShoppingItemStatus_Model.fromJson(item));

      //  FlutterToast_message(message);
        notifyListeners();
      } else {
        // Navigator.pop(context);
        print('else==============');
        FlutterToast_message('No Data');
      }
    } catch (e) {
      error = e.toString();
    }
    return result;
  }

  Future warning_popup(context){
    return   showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(

            content: const Text('You do not have any meals or snacks added to your meal planner. Please add in recipes or select a different date range.'),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  viewListFunction( false);
                  Navigator.of(context, rootNavigator: true).pop("Discard");
                  FocusManager.instance.primaryFocus?.unfocus();
                  _viewList_function = false;
                 _startDayString=null;
                 _endDayString=null;
                },

                child:  Text('Ok',style: TextStyle(color: colorBluePigment ),),
              ),
              // The "Yes" button

              // The "No" butt

            ],
          );
        }
    );
  }
}