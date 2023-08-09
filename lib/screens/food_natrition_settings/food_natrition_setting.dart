import 'dart:convert';

import 'package:aylahealth/screens/food_natrition_settings/show_updete_setting_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/api_common_fuction.dart';
import '../../common/check_screen.dart';
import '../../common/styles/Fluttertoast_internet.dart';
import '../../common/styles/const.dart';
import '../../common/styles/showLoaderDialog_popup.dart';
import '../../models/food_nutrition_settings/customerFoodSettingHeadingList_model.dart';

import 'package:http/http.dart' as http;

import 'Food_Nutrition_Settings_provider.dart';


class Food_Nutrition_Settings extends StatefulWidget {

   Food_Nutrition_Settings({Key? key}) : super(key: key);

  @override
  State<Food_Nutrition_Settings> createState() => _Food_Nutrition_SettingsState();
}

class _Food_Nutrition_SettingsState extends State<Food_Nutrition_Settings> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final Food_Nutrition_Settings_modal = Provider.of<Food_Nutrition_Settings_provider>(context, listen: false);
    Food_Nutrition_Settings_modal.customerFoodSettingHeadingList_api(context);
  }
  @override
  Widget build(BuildContext context) {
    final Food_Nutrition_Settings_modal = Provider.of<Food_Nutrition_Settings_provider>(context);

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
      body:Food_Nutrition_Settings_modal.loading
          ? Container(
        child: const Center(child: CircularProgressIndicator(),),
      ) : Container(
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
                  itemCount: Food_Nutrition_Settings_modal.customerFoodSettingHeading_list!.length ,
                  itemBuilder: (context,int index){
                    return  ListTile(
                        trailing: Icon(Icons.arrow_forward_ios_rounded),
                        title: Text(Food_Nutrition_Settings_modal.customerFoodSettingHeading_list![index].fshText??"".toString(),
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
                          (Food_Nutrition_Settings_modal.customerFoodSettingHeading_list![index].customerAnswer!.isNotEmpty?
                          ("${Food_Nutrition_Settings_modal.customerFoodSettingHeading_list![index].customerAnswer!.length >= 2?"${Food_Nutrition_Settings_modal.customerFoodSettingHeading_list![index].customerAnswer![0].opsText}, "  "${Food_Nutrition_Settings_modal.customerFoodSettingHeading_list![index].customerAnswer![1].opsText}" :Food_Nutrition_Settings_modal.customerFoodSettingHeading_list![index].customerAnswer![0].opsText}"):Food_Nutrition_Settings_modal.customerFoodSettingHeading_list![index].fshDescription??"Select any that apply."),
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
                          Get.to(() => Show_Updete_Settings_Screen(
                              fsh_text:Food_Nutrition_Settings_modal.customerFoodSettingHeading_list![index].fshText,
                              qut_id:Food_Nutrition_Settings_modal.customerFoodSettingHeading_list![index].queId,
                              que_AnswerSource:Food_Nutrition_Settings_modal.customerFoodSettingHeading_list![index].queAnswerSource,
                              qut_type:Food_Nutrition_Settings_modal.customerFoodSettingHeading_list![index].queType,
                              fsh_description:Food_Nutrition_Settings_modal.customerFoodSettingHeading_list![index].fshDescription,
                              edit:0,
                              customerFoodSettingHeading_list:Food_Nutrition_Settings_modal.customerFoodSettingHeading_list));

                        }
                    );
                  }),

            ],
          ),
        ),
      )
    );
  }


}
