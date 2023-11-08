import 'dart:convert';

import 'package:aylahealth/common/formtextfield/mytextfield.dart';
import 'package:aylahealth/screens/tabbar_screens/recipes%20screens/recipe_description/recipes_description_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:http/http.dart' as http;

import '../../../../common/api_common_fuction.dart';
import '../../../../common/check_screen.dart';
import '../../../../common/styles/Fluttertoast_internet.dart';
import '../../../../common/styles/const.dart';
import '../../../../models/recipelist/RecipeList_data_model.dart';

class ModulesSearchBar extends StatefulWidget {
  const ModulesSearchBar({Key? key}) : super(key: key);

  @override
  State<ModulesSearchBar> createState() => _ModulesSearchBarState();
}

class _ModulesSearchBarState extends State<ModulesSearchBar> {
  TextEditingController txt_search = TextEditingController();
  List<String> widgetList = ['A', 'B', 'C' ,'d', 'e', 'f','g','h'];
  bool textfieldfocus = false;

  Future? _future;
  var success, message;
  var tokanget,user_id;
  List<RecipeList_data_Response>? recipe_data_List ;
  Future<RecipeList_data_model> recipeList_ditels_api() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokanget = prefs.getString('login_user_token');
      tokanget = tokanget!.replaceAll('"', '');
      user_id = prefs.getString('login_user_id');
      user_id = user_id!.replaceAll('"', '');
    });
    print(tokanget.toString());
    check().then((intenet) async {
      if (intenet != null && intenet) {
        // Internet Present Case
        //  showLoaderDialog(context);

      } else {
        FlutterToast_Internet();
      }
    });
    Map toMap() {
      var map =  Map<String, dynamic>();

      map["index"] = '';
      map["limit"] = '';
      map["search"] = txt_search.text??"";

      return map;
    }
    var response = await http.post(
        Uri.parse(Endpoints.baseURL+Endpoints.recipeList),
        body: toMap(),
        headers: {
          'Authorization': 'Bearer $tokanget',
          'Accept': 'application/json'
        }
    );
    print(response.body.toString());
    success = (RecipeList_data_model.fromJson(json.decode(response.body)).status);
    print("success 123 ==${success}");
    if (success == 200) {
      // Navigator.pop(context);

      recipe_data_List = (RecipeList_data_model.fromJson(json.decode(response.body)).data);
      // Get.to(() => Pre_Question_Screen());
    } else {
      Navigator.pop(context);
      print('else==============');

      FlutterToast_message('No Data');

    }
    return RecipeList_data_model.fromJson(json.decode(response.body));
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _future = recipeList_ditels_api();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: _appbar(),
      body: Container(
        width: deviceWidth(context),
        height: deviceheight(context),

        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 48,
                width: deviceWidth(context),
                color: colorWhite,
                child: seach_field(),
              ).paddingOnly(left: 20,right: 20),
              sizedboxheight(15.0),
              recipes_itam_listview()
            ],
          ),
        ),
      ),
    );
  }

  /// AppBar
  AppBar _appbar(){
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text('Modules',
        style: TextStyle(
            fontSize: 30,
            fontFamily: 'Playfair Display',
            color: colorPrimaryColor,
            fontWeight: fontWeight500,
            overflow: TextOverflow.ellipsis
        ),),
      leading:  IconButton(onPressed: (){
        Navigator.pop(context);
      },
          icon: SvgPicture.asset('assets/backbutton.svg')),

      backgroundColor: colorWhite,
    );
  }



  Widget seach_field() {
    return  Expanded(
      child: Focus(

        onFocusChange: (a){
          print(a.toString());
          textfieldfocus = a;
        },
        child: Builder(
          builder: (BuildContext context) {
            final FocusNode focusNode = Focus.of(context);
            final bool hasFocus = focusNode.hasFocus;
            return  Container(
              child: TextFormField(
                controller: txt_search,
                textAlign: TextAlign.start,
                maxLines: 1,
                autofocus: false,
                style: TextStyle(
                    color: colorRichblack,
                    // fontFamily: 'Nunito',
                    fontFamily: 'Messina Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
                cursorColor: hasFocus?colorBluePigment:HexColor('#3B4250'),
                  decoration: InputDecoration(

                    fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
                    hintText: 'Search',
                    filled: true,
                    hintStyle: TextStyle(
                      color: hasFocus?colorBluePigment:HexColor('#3B4250'),
                      fontSize: 16,
                      fontFamily: 'Messina Sans',
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 15,right: 15,bottom: 5),
                      child: SvgPicture.asset(
                        'assets/Search.svg',
                        color: hasFocus?colorBluePigment:HexColor('#3B4250'),
                      ),
                    ),

                    suffixIcon: txt_search.text.isEmpty?Container(width: 1,) :InkWell(
                      onTap: (){
                        setState(() {
                          txt_search.clear();
                          _future = recipeList_ditels_api();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15),
                        child: SvgPicture.asset(
                          'assets/Close Button Light.svg',
                          height: 1,
                        ),
                      ),
                    ),
                    border:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color:hasFocus?colorBluePigment:colorDisabledTextField, width: 0.6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: hasFocus?colorBluePigment:colorDisabledTextField, width: 0.6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: hasFocus?colorBluePigment:colorDisabledTextField, width: 0.6),
                    ),
                  ),
                textInputAction: TextInputAction.done,
                onChanged: (val){
                  setState(() {
                    print(val.length);
                    if(val.isNotEmpty){
                      _future = recipeList_ditels_api();
                    }
                    else{
                      recipe_data_List!.clear();
                    }
                  });
                },
              ),
            );



            //   AllInputDesign(
            //   // inputHeaderName: 'Email',
            //   // key: Key("email1"),
            //   floatingLabelBehavior: FloatingLabelBehavior.never,
            //   hintText: 'Search',
            //   hintTextStyleColor: hasFocus?colorBluePigment:HexColor('#3B4250'),
            //   controller: txt_search,
            //   cursorColor: hasFocus?colorBluePigment:HexColor('#3B4250'),
            //   textStyleColors: hasFocus?colorBluePigment:HexColor('#3B4250'),
            //
            //   prefixIcon: Padding(
            //     padding: const EdgeInsets.all(15),
            //     child: SvgPicture.asset(
            //       'assets/Search.svg',
            //       color: hasFocus?colorBluePigment:HexColor('#3B4250'),
            //     ),
            //   ),
            //
            //   suffixIcon: txt_search.text.isEmpty?Container(width: 1,) :InkWell(
            //     onTap: (){
            //       setState(() {
            //         txt_search.clear();
            //         _future = recipeList_ditels_api();
            //       });
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.all(15),
            //       child: SvgPicture.asset(
            //         'assets/Close Button Light.svg',
            //         height: 1,
            //       ),
            //     ),
            //   ),
            //   fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
            //   outlineInputBorderColor: hasFocus?colorBluePigment:HexColor('#3B4250'),
            //   enabledOutlineInputBorderColor:hasFocus?colorBluePigment:HexColor('#3B4250'),
            //    focusedBorderColor: hasFocus?colorBluePigment:HexColor('#3B4250'),
            //   autofillHints: const [AutofillHints.name],
            //   textInputAction: TextInputAction.done,
            //   keyBoardType: TextInputType.text,
            //   validatorFieldValue: 'Search',
            //   onChanged: (val){
            //     setState(() {
            //       print(val.length);
            //       if(val.length>0){
            //        _future = recipeList_ditels_api();
            //       }
            //       else{
            //         recipe_data_List!.clear();
            //       }
            //     });
            //   },
            //
            // );

          },
        ),
      ),
    );
  }
  Widget recipes_itam_listview(){
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return  Container(
            height: deviceheight(context),
            color: HexColor('#F6F7FB'),
            padding: const EdgeInsets.only(left: 15,right: 15,top: 20,bottom: 150),
            child:  SingleChildScrollView(
              physics: const ScrollPhysics(),
              child:recipe_data_List!.isEmpty?Container(
                width: deviceWidth(context),
                height: deviceheight(context,0.4),
                child: const Center(child: Text('No Recipe Found'),),) :
              GridView.count(
                crossAxisCount: 2,

                controller:  ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                children: recipe_data_List!.map((value) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),

                    ),
                   // width: deviceWidth(context,0.38),
                  //  height: 145,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/Screen Shot 2022-12-16 at 9.39 2.png')
                            ),

                          ),
                          // width: deviceWidth(context,0.38),
                          // height: 145,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient:  LinearGradient(
                                  colors: [
                                    HexColor('#3B4250').withOpacity(0.6),
                                    HexColor('#3B4250').withOpacity(0.0),
                                  ],
                                  begin: FractionalOffset.bottomCenter,
                                  end: FractionalOffset.topCenter,
                                  tileMode: TileMode.repeated
                              )
                          ),
                          // width: deviceWidth(context,0.38),
                          // height: 145,
                          padding: const EdgeInsets.only(bottom: 10,left: 20),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text('True Healthy Eating',style: TextStyle(
                                fontSize: 14,
                                fontFamily: fontFamilyText,
                                color: colorWhite,
                                fontWeight: fontWeight600,
                                overflow: TextOverflow.ellipsis
                            ),maxLines: 2,),
                          ),
                        )
                      ],
                    ),
                  );

                  //   Container(
                  //   decoration: BoxDecoration(
                  //     // color: Colors.green,
                  //       borderRadius: BorderRadius.circular(5)
                  //   ),
                  //   margin:  EdgeInsets.all(1.0),
                  //   child:  Column(
                  //     children: [
                  //       InkWell(
                  //         onTap: () {
                  //           PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  //             context,
                  //             settings: const RouteSettings(name: "/Recipes_Screen"),
                  //             screen:  Recipes_Description_Screen(rec_id: value.recId),
                  //           );
                  //         },
                  //         child: Container(
                  //           height: 110,width: deviceWidth(context),
                  //           child: Stack(
                  //             children: [
                  //               Container(
                  //                 height: 110,width: deviceWidth(context),
                  //                 child: ClipRRect(
                  //                   borderRadius: BorderRadius.circular(5),
                  //                   child: Image.asset('assets/Rectangle 1794 (1).png',
                  //                     height: 110,width: deviceWidth(context),fit: BoxFit.cover,),
                  //                 ),
                  //               ),
                  //               Container(
                  //                 // height: 110,width: deviceWidth(context),
                  //                 alignment: Alignment.topRight,
                  //                 padding: EdgeInsets.all(5),
                  //                 child: SvgPicture.asset('assets/image/Heart_unlick.svg'),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       sizedboxheight(10.0),
                  //       InkWell(
                  //         onTap: () {
                  //           PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  //             context,
                  //             settings: const RouteSettings(name: "/Recipes_Screen"),
                  //             screen:  Recipes_Description_Screen(rec_id: 3),
                  //           );
                  //         },
                  //         child: Text(value.recTitle??"",style:TextStyle(
                  //             fontSize: 16,
                  //             fontFamily: fontFamilyText,
                  //             color: HexColor('#3B4250'),
                  //             fontWeight: fontWeight600,
                  //             height: 1.3,
                  //             overflow: TextOverflow.ellipsis
                  //         ) ,maxLines: 2,),
                  //       ),
                  //       sizedboxheight(5.0),
                  //       Row(
                  //         crossAxisAlignment: CrossAxisAlignment.end,
                  //         children: [
                  //           SvgPicture.asset('assets/image/plus-circle .svg'),
                  //
                  //           sizedboxwidth(5.0),
                  //           Container(
                  //             width: deviceWidth(context,0.35),
                  //             child: Text('Add to my meals',style:TextStyle(
                  //                 fontSize: 14,
                  //                 fontFamily: fontFamilyText,
                  //                 color: HexColor('#79879C'),
                  //                 fontWeight: fontWeight400,
                  //                 height: 1.5,
                  //                 overflow: TextOverflow.ellipsis
                  //             )),
                  //           ),
                  //         ],
                  //       )
                  //     ],
                  //   ),
                  // );
                }).toList(),
              ),
            ),);
        } else {
          return const Center(child:Text("Search Recipes"));
        }
      },
    );
  }
}
