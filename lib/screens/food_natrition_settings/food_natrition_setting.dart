import 'dart:convert';

import 'package:aylahealth/screens/food_natrition_settings/show_updete_setting_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/api_common_fuction.dart';
import '../../common/check_screen.dart';
import '../../common/styles/Fluttertoast_internet.dart';
import '../../common/styles/const.dart';
import '../../common/styles/showLoaderDialog_popup.dart';
import '../../models/food_nutrition_settings/customerFoodSettingHeadingList_model.dart';

import 'package:http/http.dart' as http;


class Food_Nutrition_Settings extends StatefulWidget {
  int? screen;
  List<customerFoodSettingHeadingList_responce>? customerFoodSettingHeading_list;
   Food_Nutrition_Settings({Key? key,this.screen,this.customerFoodSettingHeading_list}) : super(key: key);

  @override
  State<Food_Nutrition_Settings> createState() => _Food_Nutrition_SettingsState();
}

class _Food_Nutrition_SettingsState extends State<Food_Nutrition_Settings> {
  Future? _future;
  var success, message;
  var tokanget;
  List<customerFoodSettingHeadingList_responce>? customerFoodSettingHeading_list;
  Future<customerFoodSettingHeadingList_model> customerFoodSettingHeadingList_api() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokanget = prefs.getString('login_user_token');
      tokanget = tokanget!.replaceAll('"', '');

    });
    print(tokanget.toString());
    check().then((intenet) async {
      if (intenet != null && intenet) {
        // Internet Present Case
        showLoaderDialog1(context);

      } else {
        FlutterToast_Internet();
      }
    });

    var response = await http.post(
        Uri.parse(beasurl+customerFoodSettingHeadingList),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json'
        }
    );
    print(response.body.toString());
    print("success 123 ==");
    success = (customerFoodSettingHeadingList_model.fromJson(json.decode(response.body)).status);
    print("success 123 ==${success}");
    if (success == 200) {
      Navigator.pop(context);
      setState(() {
        customerFoodSettingHeading_list = (customerFoodSettingHeadingList_model.fromJson(json.decode(response.body)).data);
      });
      // Get.to(() => Pre_Question_Screen());
    } else {
      Navigator.pop(context);
      print('else==============');

      FlutterToast_message('No Data');
    }
    return customerFoodSettingHeadingList_model.fromJson(json.decode(response.body));
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.screen == 1){
      customerFoodSettingHeading_list = widget.customerFoodSettingHeading_list;
    }
    else{
      _future = customerFoodSettingHeadingList_api();
    }

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
      body:widget.screen == 1?Container(
        height: deviceheight(context),
        width: deviceWidth(context),
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text('Food & Nutrition Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: fontFamilyText,
                    color: colorPrimaryColor,
                    fontWeight: fontWeight600,
                  ),
                ),
              ),
              sizedboxheight(20.0),
              ListView.builder(
                  shrinkWrap: true,
                  physics:NeverScrollableScrollPhysics(),
                  itemCount: customerFoodSettingHeading_list!.length ,
                  itemBuilder: (context,int index){
                    return  ListTile(
                        trailing: Icon(Icons.arrow_forward_ios_rounded),
                        title: Text(customerFoodSettingHeading_list![index].fshText??"".toString(),
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: fontFamilyText,
                              color: colorRichblack,
                              fontWeight: fontWeight400,
                              overflow: TextOverflow.ellipsis
                          ),
                          maxLines: 1,
                        ),

                        subtitle: Text(
                          (customerFoodSettingHeading_list![index].customerAnswer!.length != 0?
                          ("${customerFoodSettingHeading_list![index].customerAnswer!.length >= 2?"${customerFoodSettingHeading_list![index].customerAnswer![0].opsText}, "  "${customerFoodSettingHeading_list![index].customerAnswer![1].opsText}" :customerFoodSettingHeading_list![index].customerAnswer![0].opsText}"):customerFoodSettingHeading_list![index].fshDescription??"Select any that apply."),
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: fontFamilyText,
                              color: HexColor('#79879C'),
                              fontWeight: fontWeight400,
                              overflow: TextOverflow.ellipsis
                          ),
                          maxLines: 1,
                        ),
                        tileColor: colorWhite,
                        textColor: colorRichblack,
                        onTap: (){
                          Get.off(() => Show_Updete_Settings_Screen(
                              fsh_text:customerFoodSettingHeading_list![index].fshText,
                              qut_id:customerFoodSettingHeading_list![index].queId,
                              que_AnswerSource:customerFoodSettingHeading_list![index].queAnswerSource,
                              qut_type:customerFoodSettingHeading_list![index].queType,
                              fsh_description:customerFoodSettingHeading_list![index].fshDescription,
                              edit:0,
                              customerFoodSettingHeading_list:customerFoodSettingHeading_list));

                        }
                    );
                  }),

              // commenlisttile('Eating pattern', 'Omnivore', (){
              //   Get.to(() => Eating_Pattern_Screen());
              // }),
              //
              //
              // commenlisttile('Allergies', 'None selected', (){
              //   Get.to(() => Allergies_Screen());
              // }),
              //
              // commenlisttile('Food dislikes', 'None selected', (){
              //  // Get.to(() => Food_dislikes_Screen());
              //   Get.to(() => Show_Updete_Settings_Screen());
              // }),
              //
              // commenlisttile('Nutrient content information', 'Show nutrient content', (){
              //   Get.to(() => Nutrient_Content_Screen());
              // }),
              //
              // commenlisttile('Medical conditions', 'None selected', (){
              //   Get.to(() => Medical_Conditions_Screen());
              // }),
              //
              // commenlisttile('Nutrition interest areas', 'Gut health', (){
              //   Get.to(() => Nitrition_Interest_Screen());
              // }),
            ],
          ),
        ),
      ): FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return  Container(
              height: deviceheight(context),
              width: deviceWidth(context),
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text('Food & Nutrition Settings',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: fontFamilyText,
                          color: colorPrimaryColor,
                          fontWeight: fontWeight600,
                        ),
                      ),
                    ),
                    sizedboxheight(20.0),
                    ListView.builder(
                        shrinkWrap: true,
                        physics:NeverScrollableScrollPhysics(),
                        itemCount: customerFoodSettingHeading_list!.length ,
                        itemBuilder: (context,int index){
                      return  ListTile(
                        trailing: Icon(Icons.arrow_forward_ios_rounded),
                        title: Text(customerFoodSettingHeading_list![index].fshText??"".toString(),
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: fontFamilyText,
                              color: colorRichblack,
                              fontWeight: fontWeight400,
                              overflow: TextOverflow.ellipsis
                          ),
                          maxLines: 1,
                        ),

                        subtitle: Text(
                          (customerFoodSettingHeading_list![index].customerAnswer!.length != 0?
                          ("${customerFoodSettingHeading_list![index].customerAnswer!.length >= 2?"${customerFoodSettingHeading_list![index].customerAnswer![0].opsText}, "  "${customerFoodSettingHeading_list![index].customerAnswer![1].opsText}" :customerFoodSettingHeading_list![index].customerAnswer![0].opsText}"):customerFoodSettingHeading_list![index].fshDescription??"Select any that apply."),
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: fontFamilyText,
                              color: HexColor('#79879C'),
                              fontWeight: fontWeight400,
                             overflow: TextOverflow.ellipsis
                          ),
                          maxLines: 1,
                        ),
                        tileColor: colorWhite,
                        textColor: colorRichblack,
                        onTap: (){
                          Get.off(() => Show_Updete_Settings_Screen(
                              fsh_text:customerFoodSettingHeading_list![index].fshText,
                              qut_id:customerFoodSettingHeading_list![index].queId,
                              que_AnswerSource:customerFoodSettingHeading_list![index].queAnswerSource,
                              qut_type:customerFoodSettingHeading_list![index].queType,
                              fsh_description:customerFoodSettingHeading_list![index].fshDescription,
                              edit:0,
                              customerFoodSettingHeading_list:customerFoodSettingHeading_list));

                        }
                      );
                    }),

                    // commenlisttile('Eating pattern', 'Omnivore', (){
                    //   Get.to(() => Eating_Pattern_Screen());
                    // }),
                    //
                    //
                    // commenlisttile('Allergies', 'None selected', (){
                    //   Get.to(() => Allergies_Screen());
                    // }),
                    //
                    // commenlisttile('Food dislikes', 'None selected', (){
                    //  // Get.to(() => Food_dislikes_Screen());
                    //   Get.to(() => Show_Updete_Settings_Screen());
                    // }),
                    //
                    // commenlisttile('Nutrient content information', 'Show nutrient content', (){
                    //   Get.to(() => Nutrient_Content_Screen());
                    // }),
                    //
                    // commenlisttile('Medical conditions', 'None selected', (){
                    //   Get.to(() => Medical_Conditions_Screen());
                    // }),
                    //
                    // commenlisttile('Nutrition interest areas', 'Gut health', (){
                    //   Get.to(() => Nitrition_Interest_Screen());
                    // }),
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

  Widget commenlisttile(String _title,String _subtitle, Function action){
    return  ListTile(
      trailing: Icon(Icons.arrow_forward_ios_rounded),
      title: Text(_title.toString(),
        style: TextStyle(
            fontSize: 16,
            fontFamily: fontFamilyText,
            color: colorRichblack,
            fontWeight: fontWeight400,
            overflow: TextOverflow.ellipsis
        ),
        maxLines: 1,
      ),
      subtitle: Text(_subtitle.toString(),
        style: TextStyle(
            fontSize: 12,
            fontFamily: fontFamilyText,
            color: HexColor('#79879C'),
            fontWeight: fontWeight400,
            overflow: TextOverflow.ellipsis
        ),
        maxLines: 1,
      ),
      tileColor: colorWhite,
      textColor: colorRichblack,
      onTap: () => action() ,

    );
  }

}
