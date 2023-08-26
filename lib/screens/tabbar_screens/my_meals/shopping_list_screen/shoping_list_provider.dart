
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ShoppingListProvider with ChangeNotifier {

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
  void selectEndDate_function( newMessage) {
    _selectEnddate = newMessage;
    notifyListeners();
  }

  DateTime _focusedEndDay = DateTime.now();
  DateTime get focusedEndDay => _focusedEndDay;

  void focusedEndDay_function( newMessage) {
    _focusedEndDay = newMessage;
    notifyListeners();
  }

  String? _endDayString ;
  String? get endtDayString  => _endDayString ;
  void selectEndDayString_function( newMessage) {
    _endDayString = newMessage;
    notifyListeners();
  }

  // DateTime? _selectdate = DateTime.now();
  // DateTime? get selectdate => _selectdate;
  // void selectDate_function( newMessage) {
  //   _selectdate = newMessage;
  //   notifyListeners();
  // }

  // DateTime _focusedDay = DateTime.now();
  // DateTime get focusedDay => _focusedDay;
  //
  // void focusedDay_function( newMessage) {
  //   _focusedDay = newMessage;
  //   notifyListeners();
  // }

  // String? _selectDayString ;
  // String? get selectDayString  => _selectDayString ;
  // void selectDayString_function( newMessage) {
  //   _selectDayString = newMessage;
  //   notifyListeners();
  // }
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

  final List<String> _dairy_list = [ 'milk 100ml','yoghurt 2tbsp'];
  List<String> get dairy_list => _dairy_list;



}