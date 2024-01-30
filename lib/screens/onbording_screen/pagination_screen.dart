import 'dart:convert';

import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/screens/onbording_screen/screen1.dart';
import 'package:aylahealth/screens/onbording_screen/screen12.dart';
import 'package:aylahealth/screens/onbording_screen/screen14.dart';
import 'package:aylahealth/screens/onbording_screen/screen4.dart';
import 'package:aylahealth/screens/onbording_screen/screen7.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:multiple_search_selection/helpers/create_options.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:page_view_indicators/linear_progress_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../common/Custom_chackbox_screen.dart';
import '../../common/api_common_fuction.dart';
import '../../common/check_screen.dart';
import '../../common/direct_logout.dart';
import '../../common/styles/Fluttertoast_internet.dart';
import '../../common/styles/showLoaderDialog_popup.dart';
import '../../models/onboarding_screens_models/Answer_submit_Model.dart';

import '../../models/onboarding_screens_models/Gender_List_Model.dart';
import '../../models/onboarding_screens_models/customerNutritionArea_model.dart';
import '../../models/onboarding_screens_models/ingredient_name_list_model.dart';
import '../../models/onboarding_screens_models/qution_list_model.dart';
import '../subscription_screens/subscription_screen.dart';

class Pagination_screen extends StatefulWidget {
  const Pagination_screen({Key? key}) : super(key: key);

  @override
  State<Pagination_screen> createState() => _Pagination_screenState();
}

class _Pagination_screenState extends State<Pagination_screen> {

  final focusKey=FocusNode();
  DateTime? _selectedDate;

  Future? _future;
  Future? _future1;
  Future? _future3;
  Future? _future4;


  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _boxHeight = 300.0;

  var select  ;
  var success, message, id, email;
  String? divece_type;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('aman');
    _future = qution_list_up();
    _future3 = Ingredient_Name_List_api();
    _future4 = gender_List_api();
  }

//////////////////////// qution_list api //////////////////

  var tokanget;
  List<qution_list_responce>? qustion_data_list;
  Future<qution_list_model> qution_list_up() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokanget = prefs.getString('login_user_token');
      tokanget = tokanget!.replaceAll('"', '');
    });
    print(tokanget.toString());
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case

        showLoaderDialog_popup(context,"Question Option List...");

      } else {
        FlutterToast_Internet();
      }
    });

    var response = await http.post(
      Uri.parse(Endpoints.baseURL+Endpoints.questionOptionList),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json',
        }
    );
    print(response.body.toString());
    success = (qution_list_model.fromJson(json.decode(response.body)).status);
    print("success 123 ==${success}");
    if(response.statusCode==200){
    if (success == 200) {
        Navigator.pop(context);
        qustion_data_list = (qution_list_model.fromJson(json.decode(response.body)).data);
        // Get.to(() => Pre_Question_Screen());
    } else {
      Navigator.pop(context);
      print('else==============');

      FlutterToast_message('No Question Data');
    }}
    else{
      if(response.statusCode ==401){
        directLogOutPopup();
      }
    }
    return qution_list_model.fromJson(json.decode(response.body));
  }



  final List<String> _selectedItems = [];
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }

      print(_selectedItems.length.toString());

    });
  }
 ///////////////////// addOrUpdateCustomerAnswer api //////////////

  Future<Answer_submit_Model> add_Customer_Answer_up(String queid ,String quetype, index_num) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokanget = prefs.getString('login_user_token');
      tokanget = tokanget!.replaceAll('"', '');
    });
    print(tokanget.toString());
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        showLoaderDialog1(context);

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
      }else if(quetype == 'INDEXING'){
       map["optionData"] = [
         for(int i = 0;i<customerNutritionArea_data_list!.length;i++)
           {
             "ops_id": customerNutritionArea_data_list![i].opsId.toString(),
             "ops_index": (i+1).toString()
           }
       ];
      }
       else {
       map["ops_id"] = select.toString();
      };
      return map;
    }

   print(toMap().toString());
   print(json.encode(toMap()).toString());
    var response = await http.post(
        Uri.parse(Endpoints.baseURL+Endpoints.addOrUpdateCustomerAnswer),
        body:(quetype == 'MULTIPLE'|| quetype == 'INDEXING')?json.encode(toMap()):toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json',
        if(quetype == 'MULTIPLE'|| quetype == 'INDEXING') 'Content-Type': 'application/json'
        }
    );
    if(response.statusCode==200){
    print(response.body.toString());
    success = (Answer_submit_Model.fromJson(json.decode(response.body)).status);
    var message = (Answer_submit_Model.fromJson(json.decode(response.body)).message);
    print("success 123 ==${success}");
    if (success == 200) {
      Navigator.pop(context);
      // Get.to(() => Pre_Question_Screen());

      if(qustion_data_list![index_num].queIndex == 2){
        _future1 = customerNutritionArea_data_list_api();
      }else{}
      select = null;
      _selectedItems.clear();
    } else {
      Navigator.pop(context);
      print('else==============');

      FlutterToast_message(message);
    }}
    else{
      if(response.statusCode ==401){
        directLogOutPopup();
      }
    }
    return Answer_submit_Model.fromJson(json.decode(response.body));
  }

  ////////////////////////// customerNutritionArea api /////////////

  List<customerNutritionArea_recponce>? customerNutritionArea_data_list;
  Future<customerNutritionArea_model> customerNutritionArea_data_list_api() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokanget = prefs.getString('login_user_token');
      tokanget = tokanget!.replaceAll('"', '');
    });
    print(tokanget.toString());
    check().then((intenet) {
      if (intenet) {
       // showLoaderDialog(context ,"Customer NutritionArea Data...");
      } else {
        FlutterToast_Internet();
      }
    });

    var response = await http.post(
        Uri.parse(Endpoints.baseURL+Endpoints.customerNutritionArea),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json',
        }
    );
    if(response.statusCode==200){
    print(response.body.toString());
    success = (customerNutritionArea_model.fromJson(json.decode(response.body)).status);
    print("success 123 ==${success}");
    if (success == 200) {
     // Navigator.pop(context);
      setState(() {
        customerNutritionArea_data_list = (customerNutritionArea_model.fromJson(json.decode(response.body)).data);
      });
      // Get.to(() => Pre_Question_Screen());
      print("success 123 ==${customerNutritionArea_data_list!.length.toString()}");
    } else {
     // Navigator.pop(context);
      print('else==============');

      FlutterToast_message('No Data');
    }}
    else{
      if(response.statusCode ==401){
        directLogOutPopup();
      }
    }
    return customerNutritionArea_model.fromJson(json.decode(response.body));
  }

///////////////// Ingredient_Name_List_api //////////////

  List<Country>? countries = [];
  List<Ingredient_Name_List_Risponce>? food_data_list;

  Future<Ingredient_Name_List_Model> Ingredient_Name_List_api() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokanget = prefs.getString('login_user_token');
      print('tokanget.toString()');
      print(tokanget.toString());
      print('tokanget.toString()');
      tokanget = tokanget.replaceAll('"', '');
    });
    print(tokanget.toString());
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
      //  showLoaderDialog(context,'Ingredient Name List....');

      } else {
        FlutterToast_Internet();
      }
    });

    var response = await http.post(
        Uri.parse(Endpoints.baseURL+Endpoints.ingredientNameList),
        headers: {
          'Authorization': 'Bearer $tokanget',
        }
    );
    if(response.statusCode==200){
    print(response.body.toString());
    success = (Ingredient_Name_List_Model.fromJson(json.decode(response.body)).status);
    print("success 123 ==${success}");
    if (success == 200) {
     // Navigator.pop(context);
      food_data_list = (Ingredient_Name_List_Model.fromJson(json.decode(response.body)).data);
      countries = List<Country>.generate(
        food_data_list!.length,
            (index) => Country(
          name: food_data_list![index].ingName!,
          iso: food_data_list![index].ingId!,
        ),
      );

      // Get.to(() => Pre_Question_Screen());
    } else {
    //  Navigator.pop(context);
      print('else==============');
      FlutterToast_message('No Question Data');
    }}
    else{
      if(response.statusCode ==401){
        directLogOutPopup();
      }
    }
    return Ingredient_Name_List_Model.fromJson(json.decode(response.body));
  }

 //////////////////////// gender_List_api api ////////////////////

  List<Gender_List_recponse>? grnder_list;

  Future<Gender_List_Model> gender_List_api() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokanget = prefs.getString('login_user_token');
      tokanget = tokanget.replaceAll('"', '');
    });
    print(tokanget.toString());
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
      //  showLoaderDialog(context,'Gender List....');

      } else {
        FlutterToast_Internet();
      }
    });

    var response = await http.get(
        Uri.parse(Endpoints.baseURL+Endpoints.genderList),
        headers: {
          'Authorization': 'Bearer $tokanget',
        }
    );
    print(response.body.toString());
    success = (Gender_List_Model.fromJson(json.decode(response.body)).status);
    print("success 123 ==${success}");
    if (success == 200) {
     // Navigator.pop(context);

      grnder_list = (Gender_List_Model.fromJson(json.decode(response.body)).data);
      // Get.to(() => Pre_Question_Screen());
    } else {
     // Navigator.pop(context);
      print('else==============');

      FlutterToast_message('No Question Data');
    }
    return Gender_List_Model.fromJson(json.decode(response.body));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: success==500?Container():
      FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return  Container(
              height: deviceheight(context),
              width: deviceWidth(context),
              padding: EdgeInsets.only(top: deviceheight(context,0.08),left: 20,right: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildLinearProgressIndicator(),
                    _buildPageView(),

                  ],
                ),
              ),
            );
          } else {
            return const Center();
          }
        },
      ),
    );
  }

  void _showcontent() {
    showDialog(
      context: context, barrierDismissible: true, // user must tap button!

      builder: (BuildContext context) {
        return  AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          // title:  Text('You clicked on'),
          content:  SingleChildScrollView(
            child:  Column(
              children:  [
                Text('You can select the nutrition interest area and '
                    'then drag and drop it to rank the selection in order of importance.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: fontFamilyText,
                    color: colorBlack,
                    fontWeight: fontWeight400,
                  ),),
              ],
            ),
          ),
        );
      },
    );
  }
  _buildPageView() {
    return Container(
      color: Colors.black87,
      height: deviceheight(context,0.9),

      child: qustion_data_list!.length==null?Container():PageView.builder(
        physics: NeverScrollableScrollPhysics(),
          itemCount: qustion_data_list!.length,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              color: colorWhite,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      height: deviceheight(context,0.8),
                      width: deviceWidth(context),
                      child:
                      qustion_data_list![index].queType == 'MULTIPLE'&&qustion_data_list![index].queAnswerSource == 'INGREDIENT'?
                      Container(
                        width: deviceWidth(context),
                        height: deviceheight(context),
                        padding: EdgeInsets.only(left: 20,right: 20),

                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              sizedboxheight(deviceheight(context,0.1)),
                              Padding(
                                padding:  EdgeInsets.only(left: deviceWidth(context,0.1),right: deviceWidth(context,0.1)),
                                child: Text(qustion_data_list![index].queText??"",
                                  style: TextStyle(
                                    fontSize: 24,
                                    height: 1.5,
                                    fontFamily: fontFamilyText,
                                    color: colorBlack,
                                    fontWeight: fontWeight400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              qustion_data_list![index].queSubtext == null?Container(): sizedboxheight(deviceheight(context,0.02)),

                              Text(qustion_data_list![index].queSubtext??"",
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  fontFamily: fontFamilyText,
                                  color: colorRichblack,
                                  fontWeight: fontWeight400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              sizedboxheight(deviceheight(context,0.02)),
                              success==500?Container():
                              FutureBuilder(
                                future: _future3,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return  Container(
                                      color: colorWhite,
                                      child:  MultipleSearchSelection<Country>.creatable(

                                        onItemAdded: (c) {
                                          _itemChange(c.iso.toString(), true);
                                          print('_selectedItems.length add');
                                          print(_selectedItems.length);
                                          print('_selectedItems.length add');
                                        },
                                        showClearSearchFieldButton: true,
                                        createOptions: CreateOptions(
                                          createItem: (text) {
                                            return Country(name: text, iso: int.parse(text));
                                          },
                                          onItemCreated: (c) => print('Country ${c.name} created'),
                                          createItemBuilder: (text) => Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(' "$text"'),
                                            ),
                                          ),
                                          pickCreatedItem: true,
                                        ),
                                        items: countries!, // List<Country>
                                        fieldToCheck: (c) {
                                          return c.name;
                                        },
                                        itemBuilder: (country, index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 10,
                                              ),
                                              child: Column(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(country.name,style:TextStyle(
                                                      color:  colorRichblack,
                                                      // fontFamily: 'Nunito',
                                                      fontFamily: 'Messina Sans',
                                                      fontWeight: FontWeight.w400,
                                                      fontSize:  16)),
                                                  Divider(
                                                    thickness: 0.6,color: colorgrey,
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        pickedItemsContainerMaxHeight: 100,

                                        pickedItemsScrollPhysics: ScrollPhysics(),
                                        pickedItemBuilder: (country) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(color: Colors.grey[400]!),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Padding(
                                              padding:  EdgeInsets.all(8),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(country.name,style:TextStyle(
                                                      color:  colorRichblack,
                                                      // fontFamily: 'Nunito',
                                                      fontFamily: 'Messina Sans',
                                                      fontWeight: FontWeight.w400,
                                                      fontSize:  16)),
                                                  Icon(Icons.close)
                                                ],
                                              ),
                                            ),
                                          );
                                        },

                                        searchFieldInputDecoration:InputDecoration(
                                          hintText: 'Search',
                                          filled: true,
                                          focusColor: HexColor('#F6F7FB'),
                                          border: InputBorder.none,
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: SvgPicture.asset('assets/Search.svg'),
                                          ),
                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: SvgPicture.asset('assets/Stroke 1.svg'),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(color: colorWhite),

                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(color: colorWhite),
                                          ),
                                        ),
                                        searchFieldTextStyle: TextStyle(
                                            color:  colorRichblack,
                                            // fontFamily: 'Nunito',
                                            fontFamily: 'Messina Sans',
                                            fontWeight: FontWeight.w400,
                                            fontSize:  16),

                                        searchFieldBoxDecoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10)
                                        ),

                                        onItemRemoved: (item) {
                                          _itemChange(item.iso.toString(), false);
                                          print('_selectedItems.length remove');
                                          print(_selectedItems.length);
                                          print('_selectedItems.length remove');
                                        },
                                        sortShowedItems: true,
                                        sortPickedItems: true,
                                        clearSearchFieldOnSelect: true,

                                        caseSensitiveSearch: false,
                                        fuzzySearch: FuzzySearch.none,
                                        itemsVisibility: ShowedItemsVisibility.alwaysOn,
                                        showSelectAllButton: false,
                                        showClearAllButton: false,
                                        maximumShowItemsHeight: deviceheight(context,0.4),
                                        showedItemsBoxDecoration: BoxDecoration(
                                            color: colorWhite
                                        ),
                                        maxSelectedItems: food_data_list!.length,
                                        textFieldFocus: focusKey,
                                      ),
                                    );
                                  } else {
                                    return const Center();
                                  }
                                },
                              ),

                            ],
                          ),
                        ),
                      ):
                      qustion_data_list![index].queType == 'MULTIPLE'? Container(
                        width: deviceWidth(context),
                        height: deviceheight(context),
                        padding: EdgeInsets.only(left: deviceWidth(context,0.13),right: deviceWidth(context,0.12)),
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: Column(
                            children: [
                              sizedboxheight(deviceheight(context,0.1)),
                              Text(qustion_data_list![index].queText??"",
                                style: TextStyle(
                                  fontSize: 24,
                                  height: 1.5,
                                  fontFamily: fontFamilyText,
                                  color: colorBlack,
                                  fontWeight: fontWeight400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              qustion_data_list![index].queSubtext == null?Container(height: 0,): sizedboxheight(deviceheight(context,0.05)),
                              qustion_data_list![index].queSubtext == null?Container(height: 0,):  Text(qustion_data_list![index].queSubtext??"",
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  fontFamily: fontFamilyText,
                                  color: colorRichblack,
                                  fontWeight: fontWeight400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:qustion_data_list![index].optionData!.length,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context , int index1)
                                  {return  Container(
                                    height: 50,
                                    width: deviceWidth(context),
                                    padding: EdgeInsets.only(left: 5,bottom: 5),
                                    child: Custom_chackbox(
                                      action:(){
                                        setState(() {
                                          qustion_data_list![index].optionData![index1].isSelected = !qustion_data_list![index].optionData![index1].isSelected!;
                                          _itemChange(qustion_data_list![index].optionData![index1].opsId.toString(), qustion_data_list![index].optionData![index1].isSelected!);

                                        });
                                      },
                                      // buttoninout: chaeckbutton,
                                      buttontext:qustion_data_list![index].optionData![index1].opsText.toString(),
                                      unchackborderclor: HexColor('#CCCCCC'),
                                      chackborderclor: colorBluePigment,
                                      chackboxunchackcolor: colorWhite,
                                      chackboxchackcolor: colorWhite,
                                    ),
                                  );})
                            ],
                          ),
                        ),
                      ):
                      qustion_data_list![index].queType == 'INDEXING'? Container(
                        width: deviceWidth(context),
                        height: deviceheight(context),
                        padding: EdgeInsets.only(left: deviceWidth(context,0.11),right: deviceWidth(context,0.11)),

                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: Column(
                            children: [
                              sizedboxheight(deviceheight(context,0.1)),
                              Text.rich(
                                textAlign: TextAlign.center,
                                TextSpan(

                                  children: [
                                    TextSpan(text: qustion_data_list![index].queText??"",
                                      style: TextStyle(
                                      fontSize: 24,
                                      height: 1.5,
                                      fontFamily: fontFamilyText,
                                      color: colorBlack,
                                      fontWeight: fontWeight400,
                                    ),),
                                    const TextSpan(text: ' '),
                                    WidgetSpan(
                                      child: InkWell(
                                          onTap: (){
                                            _showcontent();
                                          },
                                          child: Icon(Icons.info_outline,color: colorgrey,)),
                                    ),

                                  ],
                                ),
                              ),

                              sizedboxheight(deviceheight(context,0.05)),
                              FutureBuilder(
                                future: _future1,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return   ReorderableListView(
                                      shrinkWrap: true,
                                      children: customerNutritionArea_data_list!.map((item) => Container(
                                          key: Key("${item.opsId}"),
                                          height: 60,
                                          child: Card(
                                            elevation: 3,
                                            borderOnForeground: true,

                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10,top: 15,bottom: 15),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height:25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        color:colorWhite,
                                                        border: Border.all(color: colorBluePigment,width: 2)
                                                    ),
                                                    child:Center(child: Text("${customerNutritionArea_data_list!.indexOf(item)+1}"),
                                                    ),),
                                                  sizedboxwidth(deviceWidth(context,0.03)),
                                                  Container(
                                                    width: deviceWidth(context,0.45),
                                                    child: Text(item.opsText!,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: fontFamilyText,
                                                        color: colorRichblack,
                                                        fontWeight: fontWeight400,
                                                        overflow: TextOverflow.ellipsis
                                                      ),maxLines: 2,),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )

                                        // Custom_chackbox(
                                        //   buttontext: item.toString(),
                                        //   unchackborderclor: HexColor('#CCCCCC'),
                                        //   chackborderclor: colorBluePigment,
                                        //   chackboxunchackcolor: colorWhite,
                                        //   chackboxchackcolor: colorWhite,
                                        //   chackboxicon: "${_checked.indexOf(item)+1}",
                                        // ),
                                      )).toList(),
                                      onReorder: (int oldindex, int newindex){
                                        setState(() {
                                          if(newindex>oldindex){
                                            newindex-=1;
                                          }
                                          final items =customerNutritionArea_data_list!.removeAt(oldindex);
                                          customerNutritionArea_data_list!.insert(newindex, items);
                                        });
                                      },
                                      // onReorder: (int start, int current) {
                                      //   String? startItem;
                                      //
                                      //   // dragging from top to bottom
                                      //   if (start < current) {
                                      //     int end = current - 1;
                                      //      startItem = customerNutritionArea_data_list![start].opsText.toString();
                                      //     int i = 0;
                                      //     int local = start;
                                      //     do {
                                      //       customerNutritionArea_data_list![local].opsText = customerNutritionArea_data_list![++local].opsText;
                                      //       i++;
                                      //     } while (i < end - start);
                                      //     customerNutritionArea_data_list![end].opsText = startItem;
                                      //   }
                                      //   // dragging from bottom to top
                                      //   else if (start > current) {
                                      //      startItem = customerNutritionArea_data_list![start].opsText!;
                                      //     for (int i = start; i > current; i--) {
                                      //       customerNutritionArea_data_list![i].opsText = customerNutritionArea_data_list![i - 1].opsText;
                                      //     }
                                      //     customerNutritionArea_data_list![current].opsText = startItem;
                                      //   }
                                      //   setState(() {
                                      //    final  customerNutritionArea_data_list1 = customerNutritionArea_data_list!.removeAt(start) ;
                                      //      customerNutritionArea_data_list!.insert(current, customerNutritionArea_data_list1);
                                      //   });
                                      // },
                                    );
                                  } else {
                                    return  Center(
                                      child: Container (
                                        width: deviceWidth(context),
                                        height: deviceheight(context,0.1),
                                        child:  Text('No nutrition interest area selected, click on the edit '
                                            'icon on top right and add nutrition interest details.' , style: TextStyle(
                                          fontSize: 14,
                                          height: 1.3,
                                          fontFamily: fontFamilyText,
                                          color: colorRichblack,
                                          fontWeight: fontWeight400,
                                        ),),
                                      ),
                                    );
                                  }
                                },
                              ),

                            ],
                          ),
                        ),
                      ) :
                      qustion_data_list![index].queType == 'SINGLE'? Container(
                        width: deviceWidth(context),
                        height: deviceheight(context),
                        padding: EdgeInsets.only(left: deviceWidth(context,0.13),right: deviceWidth(context,0.12)),
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              sizedboxheight(deviceheight(context,0.1)),
                              Text(qustion_data_list![index].queText??"",
                                style: TextStyle(
                                  fontSize: 24,
                                  height: 1.5,
                                  fontFamily: fontFamilyText,
                                  color: colorBlack,
                                  fontWeight: fontWeight400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              qustion_data_list![index].queSubtext == null?Container(): sizedboxheight(deviceheight(context,0.05)),
                              Text(qustion_data_list![index].queSubtext??"",
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.8,
                                  fontFamily: fontFamilyText,
                                  color: colorRichblack,
                                  fontWeight: fontWeight400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              ListView.builder(
                                padding: EdgeInsets.only(top: 10),
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:qustion_data_list![index].optionData!.length,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context , int index1) {
                                    return Align(
                                        alignment: Alignment.center,
                                        child: addRadioButton(index1,qustion_data_list![index].optionData![index1].opsText.toString(),index));})
                            ],
                          ),
                        ),
                      ):
                      qustion_data_list![index].queType == 'SINGLE_GENDER'? Container(
                        width: deviceWidth(context),
                        height: deviceheight(context),
                        padding: EdgeInsets.only(left: deviceWidth(context,0.13),right: deviceWidth(context,0.12)),
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              sizedboxheight(deviceheight(context,0.1)),
                              Text(qustion_data_list![index].queText??"",
                                style: TextStyle(
                                  fontSize: 24,
                                  height: 1.5,
                                  fontFamily: fontFamilyText,
                                  color: colorBlack,
                                  fontWeight: fontWeight400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              qustion_data_list![index].queSubtext == null?Container(): sizedboxheight(deviceheight(context,0.05)),
                              Text(qustion_data_list![index].queSubtext??"",
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.8,
                                  fontFamily: fontFamilyText,
                                  color: colorRichblack,
                                  fontWeight: fontWeight400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              ListView.builder(
                                padding: EdgeInsets.only(top: 20),
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:grnder_list!.length,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context , int index1) {
                                    return Align(
                                        alignment: Alignment.center,
                                        child: addRadioButton1(index1,grnder_list![index1].genName.toString(),index));})
                            ],
                          ),
                        ),
                      ):
                      qustion_data_list![index].queType == 'SCREEN-1'?Screen1():
                      qustion_data_list![index].queType == 'SCREEN-2'?Screen4():
                      qustion_data_list![index].queType == 'SCREEN-3'?Screen12():
                      qustion_data_list![index].queType == 'SCREEN-4'?Screen14():
                      qustion_data_list![index].queType == 'DATE'?Container(
                        width: deviceWidth(context),
                        height: deviceheight(context),
                        padding: EdgeInsets.only(left: deviceWidth(context,0.12),right: deviceWidth(context,0.12)),

                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: Column(
                            children: [
                              sizedboxheight(deviceheight(context,0.1)),
                              Text(qustion_data_list![index].queText!??"",
                                style: TextStyle(
                                  fontSize: 24,
                                  height: 1.6,
                                  fontFamily: fontFamilyText,
                                  color: colorBlack,
                                  fontWeight: fontWeight400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              qustion_data_list![index].queSubtext == null?Container(): sizedboxheight(deviceheight(context,0.06)),

                              Text(qustion_data_list![index].queSubtext??"",
                                style: TextStyle(
                                  fontSize: 14,
                                 // height: 1.8,
                                  fontFamily: fontFamilyText,
                                  color: colorRichblack,
                                  fontWeight: fontWeight400,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              sizedboxheight(deviceheight(context,0.01)),
                        // BottomPicker.date(
                        //   title: 'Select your date of birth.',
                        //   buttonSingleColor: Colors.black12,
                        //   backgroundColor:Colors.white ,
                        //   bottomPickerTheme: BottomPickerTheme.orange,
                        //   height: 200,
                        //   displaySubmitButton: false,
                        //   dismissable: false,
                        //   displayCloseIcon: false,
                        //   initialDateTime: DateTime.now(),
                        //   maxDateTime: DateTime.now(),
                        //   minDateTime: DateTime(1850),
                        //   dateOrder: DatePickerDateOrder.dmy,
                        //   pickerTextStyle: TextStyle(color: Colors.black, fontSize: 14 ,fontFamily: 'Messina Sans',
                        //                 fontWeight: fontWeight400,),
                        //
                        //   titleStyle: TextStyle(
                        //     fontSize: 14,
                        //     // height: 1.8,
                        //     fontFamily: fontFamilyText,
                        //     color: colorRichblack,
                        //     fontWeight: fontWeight400,
                        //   ),
                        //   onChange: (index) {
                        //     print(index);
                        //     setState(() {
                        //       var  selectedDate =  DateFormat("dd-MMMM-yyyy").format(index);
                        //       print('selectedDate');
                        //       print(selectedDate);
                        //       print('selectedDate');
                        //              _selectedDate = index;
                        //               select = selectedDate;
                        //               print(select.toString());
                        //             });
                        //   },
                        //   onSubmit: (index) {
                        //     print(index);
                        //     setState(() {
                        //     var  selectedDate =  DateFormat("dd-MMMM-yyyy").format(index);
                        //     print('selectedDate');
                        //     print(selectedDate);
                        //     print('selectedDate');
                        //       _selectedDate = index;
                        //       select = selectedDate;
                        //       print(select.toString());
                        //     });
                        //   },
                        //   //bottomPickerTheme: BottomPickerTheme.plumPlate,
                        // ),
                              Container(

                                child: DatePickerWidget(
                                  looping: false, // default is not looping
                                  firstDate: DateTime(1900), //DateTime(1960),
                                  lastDate: DateTime.now(),
//                        initialDate: DateTime.now(),
                                  dateFormat: "dd/MMMM/yyyy",
                                  //  locale: DatePicker.localeFromString('th'),
                                  onChange: (DateTime newDate, _) {
                                    setState(() {
                                      var  selectedDate =  DateFormat("dd-MMMM-yyyy").format(newDate);
                                    print(selectedDate.toString());
                                     _selectedDate = newDate;
                                      select = selectedDate;
                                      print(select.toString());
                                    });
                                  },
                                  pickerTheme: DateTimePickerTheme(

                                    backgroundColor: Colors.transparent,
                                    itemTextStyle:
                                    TextStyle(color: Colors.black, fontSize: 18 ,fontFamily: 'Messina Sans',
                                        fontWeight: fontWeight400),
                                    dividerColor: Colors.white,

                                  ),
                                ),

                              )
                            ],
                          ),
                        ),
                      ):Screen14(),
                    ),

                    index == 0? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(onTap: (){
                          setState(() {
                            Get.off(() => SubscriptionScreen());
                           //  _currentPageNotifier.value = qustion_data_list!.length;
                           //  _pageController.jumpToPage(qustion_data_list!.length);
                          });
                        },
                         child: Text('skip ',  style: TextStyle(
                          fontSize: 14,
                          fontFamily: fontFamilyText,
                          color: colorBluePigment,
                          fontWeight: fontWeight600,
                        ),)),
                        Text('/',  style: TextStyle(
                          fontSize: 14,
                          fontFamily: fontFamilyText,
                          color: colorBluePigment,
                          fontWeight: fontWeight600,
                        ),),
                        GestureDetector(onTap: (){
                          setState(() {

                            _currentPageNotifier.value = _currentPageNotifier.value+1;
                            _pageController.nextPage( duration: Duration(microseconds: 1000),
                                curve: Curves.easeIn);

                          });
                        }, child: Text(' tap to continue',  style: TextStyle(
                          fontSize: 14,
                          fontFamily: fontFamilyText,
                          color: colorBluePigment,
                          fontWeight: fontWeight600,
                        ),))
                      ],
                    ):
                    TextButton(onPressed: (){
                      setState(() {
                        _currentPageNotifier.value = _currentPageNotifier.value+1;
                        _pageController.nextPage( duration: Duration(microseconds: 1000),
                            curve: Curves.easeIn);
                        print(qustion_data_list![index].queType == 'SINGLE');

                        if(qustion_data_list![index].queType == 'MULTIPLE'){
                          print(_selectedItems.length.toString());
                          if(_selectedItems.length!=0){
                            add_Customer_Answer_up(qustion_data_list![index].queId.toString(),qustion_data_list![index].queType.toString(),index);
                          }
                          if(qustion_data_list![index].queIndex == 2){
                            customerNutritionArea_data_list_api();
                          }else{

                          }
                        }
                        else if(qustion_data_list![index].queType == 'INDEXING'){
                          if(customerNutritionArea_data_list!.length!=0){
                            add_Customer_Answer_up(qustion_data_list![index].queId.toString(),qustion_data_list![index].queType.toString(),index);
                          }
                        }
                        else if(qustion_data_list![index].queType == 'SINGLE'){

                          select=select??qustion_data_list![index].optionData![0].opsId.toString();

                          add_Customer_Answer_up(qustion_data_list![index].queId.toString(),qustion_data_list![index].queType.toString(),index);
                        }
                        else if(qustion_data_list![index].queType == 'SINGLE_GENDER'){
                         print('???????????????');
                         print(select.toString());
                         print('???????????????');
                         if(select != null){
                           add_Customer_Answer_up(qustion_data_list![index].queId.toString(),qustion_data_list![index].queType.toString(),index);
                         }

                        }
                        else if(qustion_data_list![index].queType == 'DATE'){
                          select= select??DateTime.now().toString().split(' ')[0];
                          add_Customer_Answer_up(qustion_data_list![index].queId.toString(),qustion_data_list![index].queType.toString(),index);
                        }

                        if(qustion_data_list!.length == index+1)
                        {
                          Get.off(() => SubscriptionScreen());
                        }else{

                        }
                      });
                    }, child: Text('tap to continue',  style: TextStyle(
                      fontSize: 14,
                      fontFamily: fontFamilyText,
                      color: colorBluePigment,
                      fontWeight: fontWeight600,
                    ),))
                  ],
                ),
              ),
            );
          },
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          }),
    );
  }

  _buildLinearProgressIndicator() {
    return qustion_data_list!.length==null?Container():LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          LinearProgressPageIndicator(
            backgroundColor: HexColor('#E9ECF1'),
            itemCount: qustion_data_list!.length,
            currentPageNotifier: _currentPageNotifier,
            progressColor: colorBluePigment,
            width: constraints.maxWidth,
            height: 6,
          ),
    );
  }
  Row addRadioButton(int btnValue, String title , int index) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Radio(
          activeColor: colorBluePigment,
          value:qustion_data_list![index].optionData![btnValue].opsId,
          groupValue: select??qustion_data_list![index].optionData![0].opsId,
          focusColor: colorWhite,

          onChanged: (value){
            setState(() {
              print(value.toString());
              select=value;
            });
          },
        ),
        Container(
          width: deviceWidth(context,0.45),
          child: InkWell(
            onTap: (){
              setState(() {
                select=qustion_data_list![index].optionData![btnValue].opsId;
              });
            },
            child: Text(title,style: TextStyle(
              fontSize: 16,
              fontFamily: fontFamilyText,
              color: colorRichblack,
              fontWeight: fontWeight400,
              overflow: TextOverflow.ellipsis
            ),
              maxLines: 2,
            ),
          ),
        )
      ],
    );
  }
  Row addRadioButton1(int btnValue, String title , int index) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Radio(
          activeColor: colorBluePigment,
          value:grnder_list![btnValue].genId,
          groupValue: select ,
          focusColor: colorWhite,

          onChanged: (value){
            setState(() {
              print(value.toString());
              select=value;

            });
          },
        ),
        Container(
          width: deviceWidth(context,0.45),
          child: InkWell(
            onTap: (){
              setState(() {

                select=grnder_list![btnValue].genId;

              });
            },
            child: Text(title,style: TextStyle(
              fontSize: 16,
              fontFamily: fontFamilyText,
              color: colorRichblack,
              fontWeight: fontWeight400,
            ),
            ),
          ),
        )
      ],
    );
  }
}
