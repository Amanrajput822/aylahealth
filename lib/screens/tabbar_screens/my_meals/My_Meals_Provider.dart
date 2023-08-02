
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../common/api_common_fuction.dart';
import '../../../common/check_screen.dart';
import '../../../common/styles/Fluttertoast_internet.dart';
import 'calendar_evryday_json.dart';
import '../../../models/meals plans/Get_Meals_Plane_model.dart';
import '../../../models/meals plans/MealPlaneLestData_Model.dart';
import '../../../models/meals plans/Meal_Plan_Date_Data_model.dart';
import '../../../models/meals plans/Meals_Update_MealsPlane_nodel.dart';
import '../../../models/month_json_model.dart';



class MyMeals_Provider with ChangeNotifier {
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



  /// tabbat tab index save /////

  int? _selecttab = 0;
  int? get selecttab => _selecttab;
  void selecttab_fuction( newMessage) {
    _selecttab = newMessage;
    notifyListeners();
  }

/// get date on bottom bar tab change date change //
  DateTime? _finel_select_date = DateTime.now();
  DateTime? get finel_select_date => _finel_select_date;
  void finel_date_fuction( newMessage) {
    _finel_select_date = newMessage;
    notifyListeners();
  }

  /// single calender select date save /////
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  CalendarFormat get calendarFormat => _calendarFormat;



  DateTime _selectedDay = DateTime.now();
  DateTime? get selectedDay => _selectedDay;
  void singlecalendar_selectedDay( newMessage) {
    _selectedDay = newMessage;
    notifyListeners();
  }

  DateTime _singlecalendar_startdate = DateTime.now();
  DateTime? get singlecalendar_startdate => _singlecalendar_startdate;
  void singlecalendarstartdate_set( newMessage) {
    _singlecalendar_startdate = newMessage;
    notifyListeners();
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? get focusedDay => _focusedDay;

  void singlecalendar_focuseday( newMessage) {
    _focusedDay = newMessage;
    notifyListeners();
  }

  String?  _user_select_day ;
  String? get user_select_day => _user_select_day;
  void userSelectDay_set( newMessage) {
    _user_select_day = newMessage;
    notifyListeners();
  }

  /// multiple calender select date ///

  DateTime _selectedDays = DateTime.now();
  DateTime? get selectedDays => _selectedDays;

  void multiple_calender_selected( newMessage) {
    _selectedDays = newMessage;
    notifyListeners();
  }

  /// year listview scroll controller //
  ScrollController? _scrollController;
  ScrollController? get scrollController => _scrollController;

  void listviwe_controller( newMessage) {
    _scrollController = newMessage;
    notifyListeners();
  }

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  void selectDate( newMessage) {
    _selectedDate = newMessage;
    notifyListeners();
  }

  int _total_Months = 12;
  int get total_Months => _total_Months;
  void listviwe_months_set( newMessage) {
    _total_Months = newMessage;
    notifyListeners();
  }

  bool _calendar_listview = false;
  bool get calendar_listview => _calendar_listview;
  void listviewCalendar_hideShow( newMessage) {
    _calendar_listview = newMessage;
    notifyListeners();
  }
 /// Notes ///
  bool _notes = true;
  bool get notes => _notes;

  void notes_fuction( newMessage) {
    _notes = newMessage;
    notifyListeners();
  }
  /// add and update meals  calendar data
  Future<Meals_Update_MealsPlane_model?> add_update_meals_api(context,String year,String month,String datelist,List<Map<String, dynamic>> monthsData,index) async {
    Meals_Update_MealsPlane_model? result;
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
        map["mlp_year"] = year.toString();
        map["mlp_month"] = month.toString();
        map["mlp_calender_data"] = datelist;
       // map["mlp_id"] = '1';
        return map;
      }
      print('aman1???????????????');
      print(toMap());
      print(beasurl + addOrUpdateMealPlan);
      var response = await http.post(
          Uri.parse(beasurl + addOrUpdateMealPlan),
          body: toMap(),
          headers: {
            'Authorization': 'Bearer $tokanget',
            'Accept': 'application/json',
          }
      );
      _success = (Meals_Update_MealsPlane_model.fromJson(json.decode(response.body)).status);
      _message = (Meals_Update_MealsPlane_model.fromJson(json.decode(response.body)).message);
      print("json.decode(response.body)${json.decode(response.body)}");
      if (success == 200) {
        final item = json.decode(response.body);
        result = (Meals_Update_MealsPlane_model.fromJson(item));
        saveMonthsDataToFile(monthsData,year.toString());
        singal_day_data_gate_api(selectedDay!,true,index);
        FlutterToast_message(message);
        notifyListeners();
        // Get.to(() => Pre_Question_Screen());
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

  /// Get meals calendar data
  Get_Meals_Plane_responsa? _get_meals_calendar_data;
  Get_Meals_Plane_responsa? get get_meals_calendar_data =>_get_meals_calendar_data;

  List<Month_all_Date_json_model> _jsondata =[];
  List<Month_all_Date_json_model> get jsondata => _jsondata;

  Future<Get_Meals_Plane_model?> get_meals_calendardata_api(context, year,month,index) async {
    Get_Meals_Plane_model? result;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _tokanget = prefs.getString('login_user_token');
      _tokanget = tokanget!.replaceAll('"', '');

      check().then((intenet) async {
        if (intenet != null && intenet) {

        } else {FlutterToast_Internet();}
      });

      Map toMap() {
        var map = Map<String, dynamic>();
        map["mlp_year"] = year.toString();
        map["mlp_month"] = month.toString();
        return map;
      }
      print('aman1');
      print(toMap());
      print(beasurl + customerMealPlanData);
      var response = await http.post(
          Uri.parse(beasurl + customerMealPlanData),
          body: toMap(),
          headers: {
            'Authorization': 'Bearer $tokanget',
            'Accept': 'application/json'
          }
      );
      _success = (Get_Meals_Plane_model.fromJson(json.decode(response.body)).status);
      print("json.decode(response.body)${json.decode(response.body)}");
      if (success == 200) {
        final item = json.decode(response.body);
        result = (Get_Meals_Plane_model.fromJson(item));
        _get_meals_calendar_data = result.data;
        String jsondata = Get_Meals_Plane_model.fromJson(json.decode(response.body)).data!.mlpCalenderData!;

        print('person.toString()');
        print('121212');
        List<Map<String, dynamic>> dataList = (json.decode(jsondata) as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();

        print(dataList.runtimeType);
        print('person.toString()${dataList}');
        // for(int i = 0; i<person.length;i++){
        //   _jsondata.add(Month_all_Date_json_model(date: person[i]['date'], mealData:person[i]['comment'] ,comment: person[i]['mealData']));
        // }
        apidata_lode_calendar_json_fuction(get_meals_calendar_data!.mlpYear.toString(), get_meals_calendar_data!.mlpMonth.toString(),dataList);
        singal_day_data_gate_api(selectedDay!,true,index);
        notifyListeners();
        // Get.to(() => Pre_Question_Screen());
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

  /// Get meals plan types list data api
  String? _select_mealplanID ;
  String? get select_mealplanID => _select_mealplanID ;
  void meal_plan_id_select_fuction( newMessage) {
    _select_mealplanID = newMessage;
    notifyListeners();
  }

  List<MealPlaneLestData_Response>? _get_meals_planlist_data;
  List<MealPlaneLestData_Response>? get get_meals_planlist_data =>_get_meals_planlist_data;


  Future<MealPlaneLestData_Model?> get_meals_plantypelist_api() async {
    MealPlaneLestData_Model? result;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _tokanget = prefs.getString('login_user_token');
      _tokanget = tokanget!.replaceAll('"', '');

      check().then((intenet) async {
        if (intenet != null && intenet) {

        } else {FlutterToast_Internet();}
      });

      var response = await http.get(
          Uri.parse(beasurl + mealTimeList),

          headers: {
            'Authorization': 'Bearer $tokanget',
            'Accept': 'application/json'
          }
      );
      _success = (MealPlaneLestData_Model.fromJson(json.decode(response.body)).status);
      print("json.decode(response.body)${json.decode(response.body)}");
      if (success == 200) {
        final item = json.decode(response.body);
        result = (MealPlaneLestData_Model.fromJson(item));
        _get_meals_planlist_data = result.data;

        print('person.toString()');

        notifyListeners();
        // Get.to(() => Pre_Question_Screen());
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

  /// single date meal plan data gate api

  Meal_Plan_Date_Data_Response? _single_day_data;
  Meal_Plan_Date_Data_Response? get single_day_data => _single_day_data;

  List<MealData_list>? _mealData = [];
  List<MealData_list>? get mealData =>_mealData;

  List<MealData_list>? _select_tab_data_list = [];
  List<MealData_list>? get select_tab_data_list =>_select_tab_data_list;
  // void tabbar_tab_select(tab){
  //   _select_tab_data_list = tab;
  //   notifyListeners();
  // }
  List<bool> _boolDataList = [];
  List<bool> get boolDataList => _boolDataList;
  void updateItem(int index, bool newValue) {

    _boolDataList[index] = newValue;
      notifyListeners();
  }

  Future<Meal_Plan_Date_Data_model?> singal_day_data_gate_api(DateTime selectDate,bool loder,int index) async {


   if(loder) {
     _loading = true;
   };
    select_tab_data_list!.clear();
    mealData!.clear();
    Meal_Plan_Date_Data_model? result;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _tokanget = prefs.getString('login_user_token');
      _tokanget = tokanget!.replaceAll('"', '');

      check().then((intenet) async {
        if (intenet != null && intenet) {

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
      print(toMap());
      print(beasurl + customerMealOfDay);
      var response = await http.post(
          Uri.parse(beasurl + customerMealOfDay),
          body: toMap(),
          headers: {
            'Authorization': 'Bearer $tokanget',
            'Accept': 'application/json'
          }
      );
      if(loder) {
        _loading = false;
      };

      _success = (Meal_Plan_Date_Data_model.fromJson(json.decode(response.body)).status);
      print("json.decode(response.body)${json.decode(response.body)}");
      if (success == 200) {
        if(loder) {
          _loading = false;
        };
        final item = json.decode(response.body);
        result = (Meal_Plan_Date_Data_model.fromJson(item));
        _single_day_data = result.data;
        _mealData = result.data!.mealData;
        select_tab_data_list!.clear();
        for(var item in mealData!){
          print(item);
          print(int.parse(item.mtId.toString()) == get_meals_planlist_data![index].mtId);
          if(int.parse(item.mtId.toString()) == get_meals_planlist_data![index].mtId){
            select_tab_data_list!.add(item);
            _boolDataList.add(false);
            print(select_tab_data_list!.length.toString());
          }
        }
        _selecttab = index;
        _select_mealplanID = get_meals_planlist_data![index].mtId.toString();
        selecttab_fuction(index);
        meal_plan_id_select_fuction(get_meals_planlist_data![index].mtId.toString());

       // notifyListeners();
        // Get.to(() => Pre_Question_Screen());
      } else {
        if(loder) {
          _loading = false;
        };
        // Navigator.pop(context);
        print('else==============');
        FlutterToast_message('No Data');
      }
    } catch (e) {
      notifyListeners();
      if(loder) {
        _loading = false;
      };
      error = e.toString();
    }
    return result;
  }
}