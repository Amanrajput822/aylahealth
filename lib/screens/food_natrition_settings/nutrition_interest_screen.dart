import 'dart:convert';

import 'package:aylahealth/screens/food_natrition_settings/show_updete_setting_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/Custom_chackbox_screen.dart';
import '../../common/api_common_fuction.dart';
import '../../common/check_screen.dart';
import '../../common/commonwidgets/button.dart';
import '../../common/styles/Fluttertoast_internet.dart';
import '../../common/styles/const.dart';
import '../../common/styles/showLoaderDialog_popup.dart';
import '../../models/onboarding_screens_models/Answer_submit_Model.dart';
import '../../models/food_nutrition_settings/customerFoodSettingData_model.dart';
import 'package:http/http.dart' as http;


class Nitrition_Interest_Screen extends StatefulWidget {
  var fsh_text;
  var qut_id;
  var que_AnswerSource;
  var qut_type;
  var fsh_description;

  Nitrition_Interest_Screen({Key? key,this.fsh_text, this.qut_id, this.que_AnswerSource, this.qut_type, this.fsh_description}) : super(key: key);


  @override
  State<Nitrition_Interest_Screen> createState() => _Nitrition_Interest_ScreenState();
}

class _Nitrition_Interest_ScreenState extends State<Nitrition_Interest_Screen> {

  Future? _future;
  var success, message,tokanget;

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
        showLoaderDialog1(context);

      } else {
        FlutterToast_Internet();
      }
    });

    Map toMap() {
      var map =  Map<String, dynamic>();
      map["que_id"] = widget.qut_id.toString();
      map["que_answer_source"] = 'OPTION';
      return map;
    }
    print(toMap());
    var response = await http.post(
        Uri.parse(baseURL+customerFoodSettingData),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json'
        }
    );
    print(response.body.toString());
    success = (customerFoodSettingData_model.fromJson(json.decode(response.body)).status);
    print("success 123 ==${success}");
    if (success == 200) {
      Navigator.pop(context);
      // options_list = (customerFoodSettingData_model.fromJson(json.decode(response.body)).data!.options);
      customerAnswer_list = (customerFoodSettingData_model.fromJson(json.decode(response.body)).data!.customerAnswer);
      for(int i=0;i<customerAnswer_list!.length;i++)
      {
        setState(() {
          _itemChange(customerAnswer_list![i].opsId.toString(), customerAnswer_list![i].isAnswer == 1?true:false);

        });
      }
      // Get.to(() => Pre_Question_Screen());
    } else {
      Navigator.pop(context);
      print('else==============');

      FlutterToast_message('No Question Data');
    }
    return customerFoodSettingData_model.fromJson(json.decode(response.body));
  }

  ///////////////// add_Customer_Answer_up api //////////

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
        showLoaderDialog1(context);

      } else {
        FlutterToast_Internet();
      }
    });
    Map toMap() {
      var map =  Map<String, dynamic>();
      map["que_id"] = queid;
      map["que_type"] = quetype;
      map["opsIds"] = _selectedItems;

      return map;
    }

    print(toMap().toString());
    print(json.encode(toMap()).toString());
    var response = await http.post(
        Uri.parse(baseURL+addOrUpdateCustomerAnswer),
        body:(quetype == 'MULTIPLE'|| quetype == 'INDEXING')?json.encode(toMap()):toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json',
          if(quetype == 'MULTIPLE'|| quetype == 'INDEXING') 'Content-Type': 'application/json'
        }
    );
    print(response.body.toString());
    success = (Answer_submit_Model.fromJson(json.decode(response.body)).status);
    var message = (Answer_submit_Model.fromJson(json.decode(response.body)).message);
    print("success 123 ==${success}");
    if (success == 200) {
      Navigator.pop(context);
      Get.off(() => Show_Updete_Settings_Screen(
          fsh_text:widget.fsh_text,
          qut_id:widget.qut_id,
          que_AnswerSource:widget.que_AnswerSource,
          qut_type:widget.qut_type,
          fsh_description:widget.fsh_description
      ));

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Show_Updete_Settings_Screen(
      //     fsh_text:widget.fsh_text,
      //     qut_id:widget.qut_id,
      //     que_AnswerSource:widget.que_AnswerSource,
      //     qut_type:widget.qut_type,
      //     fsh_description:widget.fsh_description
      //
      // )));

      FlutterToast_message('Settings updated successfully');

      _selectedItems.clear();
    } else {
      Navigator.pop(context);
      print('else==============');

      FlutterToast_message(message);

    }
    return Answer_submit_Model.fromJson(json.decode(response.body));
  }


  //////////////////// check internet ////////


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = customerFoodSettingData_api();
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
            Container(
              height: deviceheight(context),
              width: deviceWidth(context),
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0,bottom: 5),
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
                      padding: const EdgeInsets.only(left: 8.0,bottom: 30),
                      child: Text('Select any that apply.',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: fontFamilyText,
                          color: colorSlateGray,
                          fontWeight: fontWeight400,
                        ),

                      ),
                    ),
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
                    padding: const EdgeInsets.all(8.0),
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
        buttonName: 'Next',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context,0.9),
        btnColor: colorEnabledButton,
        onPressed: () {
        add_Customer_Answer_up(widget.qut_id.toString(),'MULTIPLE');

        },
      ),
    );
  }
}
