import 'dart:convert';

import 'package:aylahealth/common/formtextfield/mytextfield.dart';
import 'package:aylahealth/screens/tabbar_screens/recipes%20screens/recipe_description/recipes_description_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/api_common_fuction.dart';
import '../../../common/check_screen.dart';
import '../../../common/styles/Fluttertoast_internet.dart';
import '../../../common/styles/const.dart';
import '../../../models/recipelist/RecipeList_data_model.dart';

import 'package:http/http.dart' as http;

class Recipes_Search_Screen extends StatefulWidget {
  const Recipes_Search_Screen({Key? key}) : super(key: key);

  @override
  State<Recipes_Search_Screen> createState() => _Recipes_Search_ScreenState();
}

class _Recipes_Search_ScreenState extends State<Recipes_Search_Screen> {
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
      // map["sortby"] = '';
      // map["orderby"] = '';
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
      appBar: AppBar(
        elevation: 0,

        centerTitle: true,
        title: Text('Recipes',
          style: TextStyle(
              fontSize: 30,
              fontFamily: 'Playfair Display',
              color: colorPrimaryColor,
              fontWeight: fontWeight500,
              overflow: TextOverflow.ellipsis
          ),),

        backgroundColor: colorWhite,
      ),
      body: Container(
        width: deviceWidth(context),
        height: deviceheight(context),

        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                  height: 70,
                width: deviceWidth(context),
                padding:  EdgeInsets.only(left: 5,right: 15),
                color: colorWhite,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textfieldfocus?Container():  IconButton(onPressed: (){
                        Navigator.pop(context);
                      },
                          icon: SvgPicture.asset('assets/backbutton.svg')),
                      seach_field(),
                      textfieldfocus? TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: Text("cancel",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: fontFamilyText,
                          color: colorBluePigment,
                          fontWeight: fontWeight400,
                          overflow: TextOverflow.ellipsis
                      ),
                      )):Container()
                    ],
                  ),
              ),
              recipes_itam_listview()
            ],
          ),
        ),
      ),
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
            return  AllInputDesign(
              // inputHeaderName: 'Email',
              // key: Key("email1"),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintText: 'Search',
              hintTextStyleColor: hasFocus?colorBluePigment:HexColor('#3B4250'),
              controller: txt_search,
              cursorColor: hasFocus?colorBluePigment:HexColor('#3B4250'),
              textStyleColors: hasFocus?colorBluePigment:HexColor('#3B4250'),

              prefixIcon: Padding(
                padding: const EdgeInsets.all(15),
                child: SvgPicture.asset(
                  'assets/Search.svg',
                  color: hasFocus?colorBluePigment:HexColor('#3B4250'),
                ),
              ),

              suffixIcon: textfieldfocus?Container(width: 1,) :InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: SvgPicture.asset(
                    'assets/Close Button Light.svg',
                    height: 1,
                  ),
                ),
              ),
              fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
              autofillHints: const [AutofillHints.name],
              textInputAction: TextInputAction.done,
              keyBoardType: TextInputType.text,
              validatorFieldValue: 'Search',
              onChanged: (val){
                setState(() {
                  print(val.length);
                  if(val.length>0){
                    _future = recipeList_ditels_api();
                  }
                  else{
                    recipe_data_List!.clear();
                  }
                });
              },

            );

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
            padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 150),
            child:  SingleChildScrollView(
              physics: ScrollPhysics(),
              child:recipe_data_List!.length == 0?Container(
                width: deviceWidth(context),
                 height: deviceheight(context,0.4),
                 child: const Center(child: Text('No Recipe Found'),),) :
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: (2 / 2.8),
                controller:  ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: recipe_data_List!.map((value) {
                  return  Container(
                    decoration: BoxDecoration(
                      // color: Colors.green,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    margin:  EdgeInsets.all(1.0),
                    child:  Column(
                      children: [
                        InkWell(
                          onTap: () {
                            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                              context,
                              settings: const RouteSettings(name: "/Recipes_Screen"),
                              screen:  Recipes_Description_Screen(rec_id: value.recId),
                            );
                          },
                          child: Container(
                            height: 110,width: deviceWidth(context),
                            child: Stack(
                              children: [
                                Container(
                                  height: 110,width: deviceWidth(context),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.asset('assets/Rectangle 1794 (1).png',
                                      height: 110,width: deviceWidth(context),fit: BoxFit.cover,),
                                  ),
                                ),
                                Container(
                                  // height: 110,width: deviceWidth(context),
                                  alignment: Alignment.topRight,
                                  padding: EdgeInsets.all(5),
                                  child: SvgPicture.asset('assets/image/Heart_unlick.svg'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        sizedboxheight(10.0),
                        InkWell(
                          onTap: () {
                            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                              context,
                              settings: const RouteSettings(name: "/Recipes_Screen"),
                              screen:  Recipes_Description_Screen(rec_id: 3),
                            );
                          },
                          child: Text(value.recTitle??"",style:TextStyle(
                              fontSize: 16,
                              fontFamily: fontFamilyText,
                              color: HexColor('#3B4250'),
                              fontWeight: fontWeight600,
                              height: 1.3,
                              overflow: TextOverflow.ellipsis
                          ) ,maxLines: 2,),
                        ),
                        sizedboxheight(5.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SvgPicture.asset('assets/image/plus-circle .svg'),

                            sizedboxwidth(5.0),
                            Container(
                              width: deviceWidth(context,0.35),
                              child: Text('Add to my meals',style:TextStyle(
                                  fontSize: 14,
                                  fontFamily: fontFamilyText,
                                  color: HexColor('#79879C'),
                                  fontWeight: fontWeight400,
                                  height: 1.5,
                                  overflow: TextOverflow.ellipsis
                              )),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
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
