import 'dart:convert';

import 'package:aylahealth/models/food_nutrition_settings/customerFoodSettingHeadingList_model.dart';
import 'package:aylahealth/screens/food_natrition_settings/Country.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:multiple_search_selection/helpers/create_options.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../common/Custom_chackbox_screen.dart';
import '../../common/api_common_fuction.dart';
import '../../common/check_screen.dart';
import '../../common/commonwidgets/button.dart';
import '../../common/direct_logout.dart';
import '../../common/styles/Fluttertoast_internet.dart';
import '../../common/styles/const.dart';
import '../../common/styles/showLoaderDialog_popup.dart';
import '../../models/onboarding_screens_models/Answer_submit_Model.dart';
import '../../models/food_nutrition_settings/customerFoodSettingData_model.dart';
import '../../models/onboarding_screens_models/customerNutritionArea_model.dart';
import '../../models/onboarding_screens_models/ingredient_name_list_model.dart';
import 'Food_Nutrition_Settings_provider.dart';
import 'food_natrition_setting.dart';
import 'nutrition_interest_screen.dart';


class Show_Updete_Settings_Screen extends StatefulWidget {
  var fsh_text;
  var qut_id;
  var que_AnswerSource;
  var qut_type;
  var fsh_description;
  int? edit;

  List<customerFoodSettingHeadingList_responce>? customerFoodSettingHeading_list;
   Show_Updete_Settings_Screen({Key? key,
     this.fsh_text,
     this.qut_id,
     this.que_AnswerSource,
     this.qut_type,
     this.fsh_description,
     this.edit,
     this.customerFoodSettingHeading_list}) : super(key: key);

  @override
  State<Show_Updete_Settings_Screen> createState() => _Show_Updete_Settings_ScreenState();
}

class _Show_Updete_Settings_ScreenState extends State<Show_Updete_Settings_Screen> {
  final focusKey=FocusNode();
  Future? _future;
  Future? _future3;
  Future? _future4;
  var success, message,tokanget;
  bool loading = false;

   /// Ingredient_Name_List_api API ////////////

  final List<String> _selectedItems = [];
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
      print(_selectedItems.length.toString());
      print('_selectedItems.length.toString()');
      print(_selectedItems.length.toString());
      print(itemValue);
    });
  }
  List<Country>? countries = [];
  List<Country>? countries1 = [];
  List<Ingredient_Name_List_Risponce>? food_data_list;

  Future<Ingredient_Name_List_Model> Ingredient_Name_List_api() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokanget = prefs.getString('login_user_token');
      tokanget = tokanget!.replaceAll('"', '');
    });
    print(tokanget.toString());
    check().then((intenet) {
      if (intenet != null && intenet) {


      } else {
        FlutterToast_Internet();
      }
    });

    var response = await http.post(
        Uri.parse(Endpoints.baseURL+Endpoints.ingredientNameList),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json'
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
      Navigator.pop(context);
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

  /// customerFoodSettingData_api API /////////////////


  //List<Options>? options_list;
  List<CustomerAnswer1>? customerAnswer_list;
  Future<customerFoodSettingData_model> customerFoodSettingData_api() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokanget = prefs.getString('login_user_token');
      tokanget = tokanget!.replaceAll('"', '');
    });
    print(tokanget.toString());
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
      //  showLoaderDialog1(context);
        loading = true;

      } else {
        FlutterToast_Internet();
      }
    });

    Map toMap() {
      var map =  Map<String, dynamic>();
      map["que_id"] = widget.qut_id.toString();
      map["que_answer_source"] = widget.que_AnswerSource.toString();
      return map;
    }
    print(toMap());
    var response = await http.post(
        Uri.parse(Endpoints.baseURL+Endpoints.customerFoodSettingData),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json'
        }
    );
    setState(() {
      loading = false;
    });
 if(response.statusCode==200) {
    print(response.body.toString());
    success = (customerFoodSettingData_model.fromJson(json.decode(response.body)).status);
    print("success 123 ==${success}");

    if (success == 200) {
    //  Navigator.pop(context);
     // options_list = (customerFoodSettingData_model.fromJson(json.decode(response.body)).data!.options);
      customerAnswer_list = (customerFoodSettingData_model.fromJson(json.decode(response.body)).data!.customerAnswer);


      for(int i=0;i<customerAnswer_list!.length;i++)

      {
        setState(() {
          if(widget.qut_type=="MULTIPLE"&&widget.que_AnswerSource=='INGREDIENT'){

            _itemChange(customerAnswer_list![i].ingId.toString(), true);
             // countries1!.add(Country(name:customerAnswer_list![i].opsText.toString(), iso:customerAnswer_list![i].ingId!));
            countries1 = List<Country>.generate(
              customerAnswer_list!.length,
                  (index) => Country(
                name: customerAnswer_list![index].opsText!,
                iso: customerAnswer_list![index].ingId!,
              ),
            );
          }

          else if(widget.qut_type=="SINGLE"){
            if(customerAnswer_list![i].isAnswer == 1){
              select = customerAnswer_list![i].opsId.toString();
            }
          }

         else if(widget.qut_type=="MULTIPLE"&&widget.que_AnswerSource=="OPTION"){
            _itemChange(customerAnswer_list![i].opsId.toString(), customerAnswer_list![i].isAnswer == 1?true:false);
          //   options_list!.removeWhere((m) => m.opsId == int.parse(customerAnswer_list![i].opsId.toString()));
          //  options_list!.add(Options( opsText: customerAnswer_list![i].opsText.toString(),isSelected: true,opsId:int.parse(customerAnswer_list![i].opsId.toString()) ));
          }

        });
      }
      // Get.to(() => Pre_Question_Screen());
    } else {
      loading = false;
     // Navigator.pop(context);
      print('else==============');

      FlutterToast_message('No Question Data');

    }}
 else{
   if(response.statusCode ==401){
     directLogOutPopup();
   }
 }
    return customerFoodSettingData_model.fromJson(json.decode(response.body));
  }

  ////////////////// add_Customer_Answer_up api /////////////////

  Future<Answer_submit_Model> add_Customer_Answer_up(String queid ,String quetype) async {
    print('add_Customer_Answer_up');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokanget = prefs.getString('login_user_token');
      tokanget = tokanget!.replaceAll('"', '');
    });
    print(tokanget.toString());
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        showLoaderDialog_popup(context,"submit Answer ...");

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
      }
     else if(quetype == 'SINGLE') {
        map["ops_id"] = select.toString();
      }else if(quetype == 'INDEXING'){
        map["optionData"] = [
          for(int i = 0;i<customerNutritionArea_data_list!.length;i++)
            {
              "ops_id": customerNutritionArea_data_list![i].opsId.toString(),
              "ops_index": (i+1).toString()
            }
        ];

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
      FlutterToast_message('Settings updated successfully');
      Provider.of<Food_Nutrition_Settings_provider>(context, listen: false).customerFoodSettingHeadingList_api(context);


    //  select = null;
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

  /// customer nutrition aria API

  List<customerNutritionArea_recponce>? customerNutritionArea_data_list;
  Future<customerNutritionArea_model> customerNutritionArea_data_list_api() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokanget = prefs.getString('login_user_token');
      tokanget = tokanget!.replaceAll('"', '');
    });
    print(tokanget.toString());
    check().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
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
    print("success 1233434 ==${success}");
    if (success == 200) {
     // Navigator.pop(context);
      setState(() {
        customerNutritionArea_data_list = (customerNutritionArea_model.fromJson(json.decode(response.body)).data);
      });
      // Get.to(() => Pre_Question_Screen());
      print("success 123 ==${customerNutritionArea_data_list!.length.toString()}");
    } else {
      Navigator.pop(context);
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.que_AnswerSource == 'INGREDIENT'){
      _future3 = Ingredient_Name_List_api();
    }
    if(widget.qut_type == 'INDEXING'){
      _future4= customerNutritionArea_data_list_api();
    }
      _future = customerFoodSettingData_api();

    select = null;
    _selectedItems.clear();

  }

  String? select ;
  void dispose(){

    super.dispose();
    select = null;
    _selectedItems.clear();
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
                Text('You can select the nutrition interest area and then '
                    'drag and drop it to rank the selection in order of importance.',
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new,color: colorRichblack,),
        ),
      ),
      body: Container(
        height: deviceheight(context),
        width: deviceWidth(context),
        child: Stack(
          children: [
            loading
                ? Container(
              child: const Center(child: CircularProgressIndicator(),),
            ) : Container(
              height: deviceheight(context),
              width: deviceWidth(context),
              padding: const EdgeInsets.only(left: 15,right: 15,top: 5,bottom:15 ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.qut_type == 'INDEXING'?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: deviceWidth(context,0.78),
                          child:   Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(

                              children: [
                                TextSpan(text: widget.fsh_text??"",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: fontFamilyText,
                                    color: colorPrimaryColor,
                                    fontWeight: fontWeight600,
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



                        ),

                       InkWell(
                           onTap: (){
                             Get.off(() => Nitrition_Interest_Screen(
                                 fsh_text:widget.fsh_text,
                                 qut_id:widget.qut_id,
                                 que_AnswerSource:widget.que_AnswerSource,
                                 qut_type:widget.qut_type,
                                 fsh_description:widget.fsh_description

                             ));
                             widget.edit = 1;
                             // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Nitrition_Interest_Screen(
                             // fsh_text:widget.fsh_text,
                             // qut_id:widget.qut_id,
                             // que_AnswerSource:widget.que_AnswerSource,
                             // qut_type:widget.qut_type,
                             // fsh_description:widget.fsh_description
                             //
                             // )));
                           },
                           child: SvgPicture.asset('assets/image/edit 1.svg'))
                      ],
                    ) :Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(widget.fsh_text,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: fontFamilyText,
                          color: colorPrimaryColor,
                          fontWeight: fontWeight600,
                        ),

                      ),
                    ),
                Padding(
                      padding: const EdgeInsets.only(left: 8.0,top: 5),
                      child: Text(widget.fsh_description.toString(),
                        style: TextStyle(
                          fontSize: 14,height: 1.5,
                          fontFamily: fontFamilyText,
                          color: HexColor('#6A707F'),
                          fontWeight: fontWeight400,
                        ),
                      ),
                    ),
                    sizedboxheight(20.0),
                    if(widget.qut_type == 'INDEXING')Container(
                      width: deviceWidth(context),
                      height: deviceheight(context),
                      padding: EdgeInsets.only(left: deviceWidth(context,0.02)),

                      child:  FutureBuilder(
                        future: _future4,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return  customerNutritionArea_data_list!.length !=0? ReorderableListView(
                              shrinkWrap: true,
                              children: customerNutritionArea_data_list!.map((item) => Container(
                                  key: Key("${item.opsId}"),
                                  height: 60,
                                  child: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
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
                                              ),),
                                          )
                                        ],
                                      ),
                                    ),
                                  )

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
                              //     print('start < current');
                              //     int end = current - 1;
                              //     startItem = customerNutritionArea_data_list![start].opsText.toString();
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
                              //     print('start > current');
                              //     startItem = customerNutritionArea_data_list![start].opsText!;
                              //     for (int i = start; i > current; i--) {
                              //       customerNutritionArea_data_list![i].opsText = customerNutritionArea_data_list![i - 1].opsText;
                              //     }
                              //     customerNutritionArea_data_list![current].opsText = startItem;
                              //   }
                              //   setState(() {
                              //     print('current');
                              //     print(current);
                              //     print('current');
                              //     print('start');
                              //     print(start);
                              //     print('start');
                              //     final  customerNutritionArea_data_list1 = customerNutritionArea_data_list!.removeAt(start) ;
                              //     customerNutritionArea_data_list!.insert(current, customerNutritionArea_data_list1);
                              //   });
                              // },
                            ):Center(
                              child: Container (
                                width: deviceWidth(context),
                                height: deviceheight(context,0.5),
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
                          } else {
                            return  Center(
                              child: Container (
                                width: deviceWidth(context),
                                height: deviceheight(context,0.1),
                                child: const Center(
                                  child: Text('No Select Nutrition Data'),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    if(widget.qut_type=="MULTIPLE"&&widget.que_AnswerSource=='INGREDIENT')
                      FutureBuilder(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return   FutureBuilder(
                              future: _future3,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return  Container(
                                    color: colorWhite,
                                    child:  MultipleSearchSelection<Country>.creatable(
                                      initialPickedItems: countries1!.toList(),
                                      onItemAdded: (c) {
                                        setState(() {
                                          _itemChange(c.iso.toString(), true);
                                          print('_selectedItems.length add');
                                          print(_selectedItems.length);
                                          print('_selectedItems.length add');
                                        });
                                      },

                                      showClearSearchFieldButton: false,
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
                                              children: [
                                                Text(country.name,style:TextStyle(
                                                    color:  colorRichblack,
                                                    // fontFamily: 'Nunito',
                                                    fontFamily: 'Messina Sans',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:  16)),
                                                Divider(thickness: 0.5,color: colorgrey,)
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
                                            padding:  EdgeInsets.all(5),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(country.name,style:TextStyle(
                                                    color:  colorRichblack,
                                                    // fontFamily: 'Nunito',
                                                    fontFamily: 'Messina Sans',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:  15)),
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
                                          fontSize:  16,

                                      ),

                                      searchFieldBoxDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),

                                      ),

                                      onItemRemoved: (item) {
                                        setState(() {
                                          _itemChange(item.iso.toString(), false);
                                          print('_selectedItems.length remove');
                                          print(_selectedItems.length);
                                          print('_selectedItems.length remove');
                                        });

                                      },

                                      sortShowedItems: true,
                                      clearSearchFieldOnSelect: true,
                                      sortPickedItems: true,

                                      caseSensitiveSearch: false,
                                      fuzzySearch: FuzzySearch.none,
                                      itemsVisibility: ShowedItemsVisibility.alwaysOn,
                                      showSelectAllButton: false,
                                      showClearAllButton: false,
                                      maximumShowItemsHeight: deviceheight(context,0.4),

                                      showedItemsBoxDecoration: BoxDecoration(
                                          color: colorWhite
                                      ),
                                      maxSelectedItems: countries!.length,
                                      textFieldFocus:  focusKey,

                                    ),
                                  );
                                } else {
                                  return const Center();
                                }
                              },
                            );
                          } else {
                            return const Center();
                          }
                        },
                      ),
                    if(widget.qut_type=="SINGLE")FutureBuilder(
                      future: _future,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return   ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: customerAnswer_list!.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context , int index) {
                                return Align(
                                    alignment: Alignment.center,
                                    child: addRadioButton(index, customerAnswer_list![index].opsText.toString()));});
                        } else {
                          return const Center();
                        }
                      },
                    ),
                    if(widget.qut_type=="MULTIPLE"&&widget.que_AnswerSource=='OPTION')
                      FutureBuilder(
                      future: _future,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return  Container(
                            width: deviceWidth(context),
                            height: deviceheight(context),
                            //padding: EdgeInsets.only(left: deviceWidth(context,0.13),right: deviceWidth(context,0.12)),
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:customerAnswer_list!.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context , int index1)
                                {return  Container(
                                  height: 50,
                                  width: deviceWidth(context),
                                  padding: EdgeInsets.only(left: 10,),
                                  child: InkWell(
                                    // onTap: (){
                                    //   chaeckbutton= !chaeckbutton;
                                    //   print(index.toString());
                                    //   _itemChange(widget.qustion_data_list![widget.index!].optionData![index].opsText.toString(), chaeckbutton);
                                    // },
                                    child: Custom_chackbox(
                                      screentype: 1,
                                      action:(){
                                        setState(() {
                                         // options_list![index1].isSelected = !options_list![index1].isSelected!;
                                          if(customerAnswer_list![index1].isAnswer == 0){
                                            customerAnswer_list![index1].isAnswer = 1;
                                          }else if(customerAnswer_list![index1].isAnswer == 1){
                                            customerAnswer_list![index1].isAnswer = 0;
                                          }

                                          _itemChange(customerAnswer_list![index1].opsId.toString(), customerAnswer_list![index1].isAnswer==1?true:false);

                                        });
                                      },
                                       buttoninout: customerAnswer_list![index1].isAnswer==1?true:false,
                                      buttontext:customerAnswer_list![index1].opsText??"",
                                      unchackborderclor: HexColor('#CCCCCC'),
                                      chackborderclor: colorBluePigment,
                                      chackboxunchackcolor: colorWhite,
                                      chackboxchackcolor: colorWhite,
                                    ),
                                  ),
                                );}),
                          );
                        } else {
                          return const Center();
                        }
                      },
                    ),


                  ],
                ),
              ),
            ),
            Positioned(
               bottom: 10,
                child: Container(
                  width: deviceWidth(context),
                  child: Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: Center(child: nextBtn(context)),
                  ),
                ))
          ],
        ),
      ),
    );
  }
  Widget nextBtn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(

        buttonName: 'Done',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context,0.9),
        btnColor: colorEnabledButton,
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          if(widget.qut_type == "MULTIPLE"){

              add_Customer_Answer_up(widget.qut_id.toString(),widget.qut_type.toString());

          }
          else if(widget.qut_type == "SINGLE"){
            if(select != null){
              add_Customer_Answer_up(widget.qut_id.toString(),widget.qut_type.toString());
            }
          }
          else if(widget.qut_type == 'INDEXING'){
            if(customerNutritionArea_data_list!.length!=0){
              add_Customer_Answer_up(widget.qut_id.toString(),widget.qut_type.toString());
            }
          }
        },
      ),
    );
  }
  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Radio(
          activeColor: colorBluePigment,
          value: customerAnswer_list![btnValue].opsId.toString(),
          groupValue: select,
          focusColor: colorWhite,

          onChanged: (value){
            setState(() {
              print(value);
              select=value.toString();
              print(select);
            });
          },
        ),
        Container(
          width: deviceWidth(context,0.7),
          child: InkWell(
            onTap: (){
              setState(() {

                select=customerAnswer_list![btnValue].opsId.toString();
                print(select);
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

