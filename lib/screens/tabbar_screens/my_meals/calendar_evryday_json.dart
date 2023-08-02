import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'My_Meals_Provider.dart';



/// calendar year all months and dates json data create andd meals add function
void json_add_api_data_calendar_json_fuction(context,String year, String month,String day,List<Map<String, dynamic>> mealDataList,int index) async{
  // removeDataFromFile();
  final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
  List<Map<String, dynamic>> monthsData = createMonthsData();

  List<Map<String, dynamic>> lodeing_save_data = await loadMonthsDataFromFile(year);

  if(lodeing_save_data.isNotEmpty){
    for(int m=0;m<lodeing_save_data.length;m++){
    for(int day=0;day<lodeing_save_data[m]['days'].length;day++){

      if(lodeing_save_data[m]['days'][day]['mealData'].isNotEmpty){
        for(int j=0;j<lodeing_save_data[m]['days'][day]['mealData'].length;j++){
          List<Map<String, dynamic>> mealDataList = [{
              "rec_id": lodeing_save_data[m]['days'][day]['mealData'][j]['rec_id'].toString(),
              "mt_id": lodeing_save_data[m]['days'][day]['mealData'][j]['mt_id'].toString(),
              "note": lodeing_save_data[m]['days'][day]['mealData'][j]['note'].toString(),
              "logged": lodeing_save_data[m]['days'][day]['mealData'][j]['logged'].toString()
          }];
          addMealDataDynamically(monthsData, lodeing_save_data[m]['month'].toString(), lodeing_save_data[m]['days'][day]['date'].toString(), mealDataList);
        }
      }
    }}
  }

  addMealDataDynamically(monthsData, month.toString(), day.toString(), mealDataList);
  String jsonData = jsonEncode(monthsData[int.parse(month)-1]['days']);
  mealsModel.add_update_meals_api(context,year.toString(),month.toString(),jsonData.toString(),monthsData,index);

  print(jsonData);
}
/// meals data change function
// remove_meals_fuction(2023,7,1,mealsModel.recipe_data_List![index * 2 + 1].recId.toString());
void change_meals_fuction(context,String remove_year,String remove_month,String remove_day,remove_selectedRecId,remove_selectedMtId,int index,  String add_year, String add_month,String add_day,List<Map<String, dynamic>> add_mealDataList) async{
  // removeDataFromFile();
  final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

  List<Map<String, dynamic>> monthsData = createMonthsData();
  List<Map<String, dynamic>> lodeing_save_data = await loadMonthsDataFromFile(remove_year);

  if(lodeing_save_data.isNotEmpty){
    for(int m=0;m<lodeing_save_data.length;m++){
      for(int day=0;day<lodeing_save_data[m]['days'].length;day++){
        print(lodeing_save_data[m]['days'][day]['mealData']);
        print(lodeing_save_data[m]['days'][day]['mealData'].isEmpty);
        if(lodeing_save_data[m]['days'][day]['mealData'].isNotEmpty){
          for(int j=0;j<lodeing_save_data[m]['days'][day]['mealData'].length;j++){
            List<Map<String, dynamic>> mealDataList = [{
              "rec_id": lodeing_save_data[m]['days'][day]['mealData'][j]['rec_id'],
              "mt_id": lodeing_save_data[m]['days'][day]['mealData'][j]['mt_id'],
              "note": lodeing_save_data[m]['days'][day]['mealData'][j]['note'],
              "logged": lodeing_save_data[m]['days'][day]['mealData'][j]['logged']
            }];
            addMealDataDynamically(monthsData, lodeing_save_data[m]['month'].toString(), lodeing_save_data[m]['days'][day]['date'], mealDataList);
          }
        }
      }}
  }


  removeMealDataObject(context,monthsData,int.parse(remove_month), int.parse(remove_day), remove_selectedRecId,remove_selectedMtId,remove_year);
  String remove_jsonData = jsonEncode(monthsData[int.parse(remove_month)-1]['days']);
  mealsModel.add_update_meals_api(context,remove_year.toString(),remove_month.toString(),remove_jsonData.toString(),monthsData,index);

  Timer(Duration(seconds:2), () {

    addMealDataDynamically(monthsData, add_month.toString(), add_day.toString(), add_mealDataList);
    String add_jsonData = jsonEncode(monthsData[int.parse(add_month)-1]['days']);
    mealsModel.add_update_meals_api(context,add_year.toString(),add_month.toString(),add_jsonData.toString(),monthsData,index);
});
}
/// calendar year all months and dates json data create function
void apidata_lode_calendar_json_fuction(String year, String month,List<Map<String, dynamic>> apimonthdata,) async{
  // removeDataFromFile();
  List<Map<String, dynamic>> monthsData = createMonthsData();

  //List<Map<String, dynamic>> lodeing_save_data = await loadMonthsDataFromFile(year);
  List<Map<String, dynamic>> lodeing_save_data = await loadMonthsDataFromFile(year);
  if(lodeing_save_data.isNotEmpty){
    for(int m=0;m<lodeing_save_data.length;m++){
      if(lodeing_save_data[m] == month ){
        for(int day=0;day<apimonthdata.length;day++){
          print(apimonthdata[day]['mealData']);
          print(apimonthdata[day]['mealData'].isEmpty);
          if(apimonthdata[day]['mealData'].isNotEmpty){
            for(int j=0;j<apimonthdata[day]['mealData'].length;j++){
              List<Map<String, dynamic>> mealDataList = [{
                "rec_id": apimonthdata[day]['mealData'][j]['rec_id'].toString(),
                "mt_id": apimonthdata[day]['mealData'][j]['mt_id'].toString(),
                "note": apimonthdata[day]['mealData'][j]['note'].toString(),
                "logged":apimonthdata[day]['mealData'][j]['logged'].toString()
              }];
              addMealDataDynamically(monthsData, month.toString(), apimonthdata[day]['date'].toString(), mealDataList);
            }
          }
        }
      }
      for(int day=0;day<lodeing_save_data[m]['days'].length;day++){
        print(lodeing_save_data[m]['days'][day]['mealData']);
        print(lodeing_save_data[m]['days'][day]['mealData'].isEmpty);
        if(lodeing_save_data[m]['days'][day]['mealData'].isNotEmpty){
          for(int j=0;j<lodeing_save_data[m]['days'][day]['mealData'].length;j++){
            List<Map<String, dynamic>> mealDataList = [{
              "rec_id": lodeing_save_data[m]['days'][day]['mealData'][j]['rec_id'].toString(),
              "mt_id": lodeing_save_data[m]['days'][day]['mealData'][j]['mt_id'].toString(),
              "note": lodeing_save_data[m]['days'][day]['mealData'][j]['note'].toString(),
              "logged": lodeing_save_data[m]['days'][day]['mealData'][j]['logged'].toString()
            }];
            addMealDataDynamically(monthsData, lodeing_save_data[m]['month'].toString(), lodeing_save_data[m]['days'][day]['date'].toString(), mealDataList);
          }
        }
      }}
  }
  else{
    if(apimonthdata.isNotEmpty){
      for(int day=0;day<apimonthdata.length;day++){
        print(apimonthdata[day]['mealData']);
        print(apimonthdata[day]['mealData'].isEmpty);
        if(apimonthdata[day]['mealData'].isNotEmpty){
          for(int j=0;j<apimonthdata[day]['mealData'].length;j++){
            List<Map<String, dynamic>> mealDataList = [{
              "rec_id": apimonthdata[day]['mealData'][j]['rec_id'].toString(),
              "mt_id": apimonthdata[day]['mealData'][j]['mt_id'].toString(),
              "note": apimonthdata[day]['mealData'][j]['note'].toString(),
              "logged":apimonthdata[day]['mealData'][j]['logged'].toString()
            }];
            addMealDataDynamically(monthsData, month.toString(), apimonthdata[day]['date'].toString(), mealDataList);
          }
        }
      }
    } else{}
  }

  String jsonData = jsonEncode(monthsData[int.parse(month)-1]['days']);
  saveMonthsDataToFile(monthsData,year);
  print(jsonData);
}
/// meals data remove function
// remove_meals_fuction(2023,7,1,mealsModel.recipe_data_List![index * 2 + 1].recId.toString());
void remove_meals_fuction(context,String year,String month,String day,selectedRecId,selectedMtId,DateTime selectdate,int index) async{
  // removeDataFromFile();
  final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

  List<Map<String, dynamic>> monthsData = createMonthsData();
  List<Map<String, dynamic>> lodeing_save_data = await loadMonthsDataFromFile(year);

  if(lodeing_save_data.isNotEmpty){
    for(int m=0;m<lodeing_save_data.length;m++){
      for(int day=0;day<lodeing_save_data[m]['days'].length;day++){
        print(lodeing_save_data[m]['days'][day]['mealData']);
        print(lodeing_save_data[m]['days'][day]['mealData'].isEmpty);
        if(lodeing_save_data[m]['days'][day]['mealData'].isNotEmpty){
          for(int j=0;j<lodeing_save_data[m]['days'][day]['mealData'].length;j++){
            List<Map<String, dynamic>> mealDataList = [{
              "rec_id": lodeing_save_data[m]['days'][day]['mealData'][j]['rec_id'],
              "mt_id": lodeing_save_data[m]['days'][day]['mealData'][j]['mt_id'],
              "note": lodeing_save_data[m]['days'][day]['mealData'][j]['note'],
              "logged": lodeing_save_data[m]['days'][day]['mealData'][j]['logged']
            }];
            addMealDataDynamically(monthsData, lodeing_save_data[m]['month'].toString(), lodeing_save_data[m]['days'][day]['date'], mealDataList);
          }
        }
      }}
  }

  removeMealDataObject(context,monthsData,int.parse(month), int.parse(day), selectedRecId,selectedMtId,year);

  String jsonData = jsonEncode(monthsData[int.parse(month)-1]['days']);
  mealsModel.add_update_meals_api(context,year.toString(),month.toString(),jsonData.toString(),monthsData,index);
  print(jsonData);
}

/// update json data create function
void update_json_create_fuction(context,String year,String month,String day,selectedRecId,selectedMtId,String logged,int index,String notes,int indexid) async{
  // removeDataFromFile();
  final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

  List<Map<String, dynamic>> monthsData = createMonthsData();

  List<Map<String, dynamic>> lodeing_save_data = await loadMonthsDataFromFile(year.toString());
  // List<Map<String, dynamic>> mealDataList = [
  //   {"rec_id":"4","mt_id":"2","note":"","logged":"1"},
  //   {"rec_id":"6","mt_id":"2","note":"","logged":"1"}
  if(lodeing_save_data.isNotEmpty){
    for(int m=0;m<lodeing_save_data.length;m++){
      for(int day=0;day<lodeing_save_data[m]['days'].length;day++){
        print(lodeing_save_data[m]['days'][day]['mealData']);
        print(lodeing_save_data[m]['days'][day]['mealData'].isEmpty);
        if(lodeing_save_data[m]['days'][day]['mealData'].isNotEmpty){
          for(int j=0;j<lodeing_save_data[m]['days'][day]['mealData'].length;j++){
            List<Map<String, dynamic>> mealDataList = [{
              "rec_id": lodeing_save_data[m]['days'][day]['mealData'][j]['rec_id'].toString(),
              "mt_id": lodeing_save_data[m]['days'][day]['mealData'][j]['mt_id'].toString(),
              "note": lodeing_save_data[m]['days'][day]['mealData'][j]['note'].toString(),
              "logged": lodeing_save_data[m]['days'][day]['mealData'][j]['logged'].toString()
            }];
            addMealDataDynamically(monthsData, lodeing_save_data[m]['month'].toString(), lodeing_save_data[m]['days'][day]['date'].toString(), mealDataList);
          }
        }
      }}
  }

  editMealData(monthsData, month,int.parse(day), index, notes.toString(), selectedRecId, logged ,selectedMtId);

  String jsonData = jsonEncode(monthsData[int.parse(month)-1]['days']);
  mealsModel.add_update_meals_api(context,year.toString(),month.toString(),jsonData.toString(),monthsData,indexid);

  print(jsonData);
}


 /// get local path function
Future<File> getLocalFile(String year) async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/months_data_$year.json');
}
/// save locale date to file
Future<void> saveMonthsDataToFile(List<Map<String, dynamic>> monthsData,String year) async {
  final String jsonData = jsonEncode(monthsData);
  final file = await getLocalFile(year.toString());

  await file.writeAsString(jsonData);
  print('Months data saved to file.');
}
/// re lode local data on file
Future<List<Map<String, dynamic>>> loadMonthsDataFromFile(String year) async {
  try {
    final file = await getLocalFile(year.toString());
    final jsonData = await file.readAsString();
    final List<dynamic> data = jsonDecode(jsonData);
    return data.cast<Map<String, dynamic>>();

  } catch (e) {
    print('Error loading months datafor year $year: $e');
    return [];
  }
}
/// meals data remove function
void removeMealDataObject(context,List<Map<String, dynamic>> monthsData, int selectedMonth, int selectedDate, String selectedRecId,String selectedMtId,year) {

  int monthIndex = selectedMonth - 1; // Since months are 1-indexed in your data
  int dateIndex = selectedDate - 1;   // Since dates are 1-indexed in your data
  if (monthIndex >= 0 && monthIndex < monthsData.length) {
    List<Map<String, dynamic>> daysData = monthsData[monthIndex]['days'];
    if (dateIndex >= 0 && dateIndex < daysData.length) {
      List mealDataList = daysData[dateIndex]['mealData'];
      for(int i=0;i<mealDataList.length;i++){
        if(mealDataList[i]['rec_id']==selectedRecId.toString()&&mealDataList[i]['mt_id']==selectedMtId.toString()){
          mealDataList.removeWhere((mealData) => mealData['rec_id'] == selectedRecId &&mealData['mt_id'] == selectedMtId);
        }
      }
    }
  }
}

/// file all data remove function
Future<void> removeDataFromFile(String year) async {
  final file = await getLocalFile(year);

  await file.writeAsString('');

  print('Data removed from the file.');
}
/// calendar json create function
List<Map<String, dynamic>> createMonthsData() {
  List<String> monthNames = [
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"
  ];

  List<int> daysInMonths = [
    31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
  ];

  List<Map<String, dynamic>> monthsData = [];
  for (int i = 0; i < monthNames.length; i++) {
    List<Map<String, dynamic>> daysData = [];
    for (int day = 1; day <= daysInMonths[i]; day++) {
      Map<String, dynamic> dayData = {
        'date': day.toString(),
        // 'comment': '',
        'mealData': [],
      };
      daysData.add(dayData);
    }


    Map<String, dynamic> monthData = {
      'month': monthNames[i],
      'days': daysData,
    };
    monthsData.add(monthData);
  }
  return monthsData;
}


/// add meals data function
void addMealDataDynamically(List<Map<String, dynamic>> monthsData, String monthName, String day, List<Map<String, dynamic>> mealDataList) {
  int monthIndex = -1;
  for (int i = 0; i < monthsData.length; i++) {
    if (monthsData[i]['month'] == monthName) {
      monthIndex = i;
      break;
    }
  }

  if (monthIndex != -1) {
    List<Map<String, dynamic>> daysData = monthsData[monthIndex]['days'];
    if (int.parse(day) >= 1 && int.parse(day) <= daysData.length) {
      daysData[int.parse(day) - 1]['mealData'].addAll(mealDataList);
    }
  } else {
    print('Month not found: $monthName');
  }
}
/// edite meals data function
void editMealData(List<Map<String, dynamic>> monthsData, String monthName, int day, int index,  String note,  String recId,  String logged ,String mtId) {
  int monthIndex = -1;
  for (int i = 0; i < monthsData.length; i++) {
    if (monthsData[i]['month'] == monthName) {
      monthIndex = i;
      break;
    }
  }

  if (monthIndex != -1) {
    List<Map<String, dynamic>> daysData = monthsData[monthIndex]['days'];
    if (day >= 1 && day <= daysData.length) {
      if (index >= 0 && index < daysData[day - 1]['mealData'].length) {
        Map<String, dynamic> mealData = daysData[day - 1]['mealData'][index];

        mealData['mt_id'] = mtId;
        mealData['rec_id'] = recId;
        mealData['note'] = note;
        mealData['logged'] = logged;
      } else {
        print('Invalid index: $index');
      }
    } else {
      print('Invalid day: $day');
    }
  } else {
    print('Month not found: $monthName');
  }
}