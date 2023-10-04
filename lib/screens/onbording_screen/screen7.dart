import 'dart:convert';

import 'package:aylahealth/common/styles/const.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:multiple_search_selection/helpers/create_options.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../common/api_common_fuction.dart';

import '../../common/check_screen.dart';
import '../../common/styles/Fluttertoast_internet.dart';
import '../../common/styles/showLoaderDialog_popup.dart';
import '../../models/onboarding_screens_models/ingredient_name_list_model.dart';
import '../../models/onboarding_screens_models/qution_list_model.dart';


class Screen7 extends StatefulWidget {
  List<qution_list_responce>? qustion_data_list;
  int? index;
  Screen7({Key? key,this.qustion_data_list, this.index}) : super(key: key);

  @override
  State<Screen7> createState() => _Screen7State();
}

class _Screen7State extends State<Screen7> {
  var success, message, id, email;
  Future? _future3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('aman');
    _future3 = Ingredient_Name_List_api();
  }

  List<Country>? countries = [];
  var tokanget;
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
        showLoaderDialog_popup(context,"Question Option List...");
      } else {
        FlutterToast_Internet();
      }
    });

    var response = await http.post(
        Uri.parse(baseURL+ingredientNameList),
        headers: {
          'Authorization': 'Bearer $tokanget',
        }
    );
    print(response.body.toString());
    success = (Ingredient_Name_List_Model.fromJson(json.decode(response.body)).status);
    print("success 123 ==${success}");
    if (success == 200) {
      Navigator.pop(context);
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
    }
    return Ingredient_Name_List_Model.fromJson(json.decode(response.body));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: Container(
        width: deviceWidth(context),
        height: deviceheight(context),
        padding: EdgeInsets.only(left: 20,right: 20),

        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              sizedboxheight(deviceheight(context,0.1)),
              Padding(
                padding:  EdgeInsets.only(left: deviceWidth(context,0.1),right: deviceWidth(context,0.1)),
                child: Text(widget.qustion_data_list![widget.index!].queText!??"",
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
              sizedboxheight(deviceheight(context,0.05)),

              Text('Select any that apply.',
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

                        onItemAdded: (c) {},
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
                              child: Text('Create "$text"'),
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
                              child: Text(country.name,style:TextStyle(
                                  color:  colorRichblack,
                                  // fontFamily: 'Nunito',
                                  fontFamily: 'Messina Sans',
                                  fontWeight: FontWeight.w400,
                                  fontSize:  16)),
                            ),
                          );
                        },
                        pickedItemsContainerMaxHeight: 150,
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

                        onItemRemoved: (item) {},
                        sortShowedItems: true,
                        sortPickedItems: true,
                        clearSearchFieldOnSelect: true,

                        caseSensitiveSearch: false,
                        fuzzySearch: FuzzySearch.none,
                        itemsVisibility: ShowedItemsVisibility.alwaysOn,
                        showSelectAllButton: false,
                        showClearAllButton: false,
                        maximumShowItemsHeight: food_data_list!.length*50,
                        showedItemsBoxDecoration: BoxDecoration(
                            color: colorWhite
                        ),
                        maxSelectedItems: food_data_list!.length,
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
      ),
    );
  }

}

class Country {
  final String name;
  final int iso;



  const Country({
    required this.name,
    required this.iso,
  });
}
