import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../../../../common/formtextfield/mytextfield.dart';
import '../../../../common/styles/const.dart';
import '../modules_search_bar/modulesSearchBar.dart';
import '../module_description_screen/module_description_screen.dart';
import 'modules_screen_provider.dart';

class Modules_Screen extends StatefulWidget {
  const Modules_Screen({Key? key}) : super(key: key);

  @override
  State<Modules_Screen> createState() => _Modules_ScreenState();
}

class _Modules_ScreenState extends State<Modules_Screen> {

  // bool iconcolor = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final modulesProviderData = Provider.of<ModulesScreenProvider>(context, listen: false);

  }
  @override
  Widget build(BuildContext context) {
    final modulesProviderData = Provider.of<ModulesScreenProvider>(context);

    return Scaffold(
      backgroundColor: colorWhite,
      appBar: _appbar(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 50,
                  child: search_field()).paddingOnly(left: 15,right: 15),
              sizedboxheight(15.0),


              sizedboxheight(15.0),
              headingtile('Continue Learning').paddingOnly(left: 15,right: 15),
              sizedboxheight(15.0),
              continue_learning().paddingOnly(left: 15,right: 15),
              headingtile('Recommended for You').paddingOnly(left: 15,right: 15),
              sizedboxheight(15.0),
              recommended_list().paddingOnly(left: 15,right: 15),
              headingtile('Module Library').paddingOnly(left: 15,right: 15),
              sizedboxheight(15.0),
              module_library_list(modulesProviderData),

              sizedboxheight(70.0),
            ],
          ),
        ),
      ),
    );
  }
  /// appbar ///////////////////

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


      backgroundColor: colorWhite,
    );
  }
  /// search_field ////////////////
  Widget search_field() {

    return  InkWell(
      onTap: (){
        Get.to(()=>const ModulesSearchBar());
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorDisabledTextField,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: SvgPicture.asset(
                'assets/Search.svg',
                color: colorShadowBlue,
              ),
            ),
            Text('Search',
              style: TextStyle(
              fontSize: 16,
                fontFamily: fontFamilyText,
                fontWeight: fontWeight400,
                color: colorShadowBlue
            ),)
          ],
        ),
      ),
    );
  }
  // Widget search_field1() {
  //
  //   return  Expanded(
  //     child: Focus(
  //
  //       onFocusChange: (a){
  //         print(a.toString());
  //         textfieldfocus = a;
  //         if(a){
  //           clear_icon = false;
  //         }
  //       },
  //       child: Builder(
  //         builder: (BuildContext context) {
  //           final FocusNode focusNode = Focus.of(context);
  //           final bool hasFocus = focusNode.hasFocus;
  //           return  AllInputDesign(
  //             // inputHeaderName: 'Email',
  //             // key: Key("email1"),
  //             floatingLabelBehavior: FloatingLabelBehavior.never,
  //             hintText: 'Search',
  //             hintTextStyleColor: hasFocus?colorBluePigment:HexColor('#3B4250'),
  //             controller: txt_search,
  //             cursorColor: hasFocus?colorBluePigment:HexColor('#3B4250'),
  //             textStyleColors: hasFocus?colorBluePigment:HexColor('#3B4250'),
  //
  //             prefixIcon: Padding(
  //               padding: const EdgeInsets.all(15),
  //               child: SvgPicture.asset(
  //                 'assets/Search.svg',
  //                 color: hasFocus?colorBluePigment:HexColor('#3B4250'),
  //               ),
  //             ),
  //
  //             suffixIcon: clear_icon? InkWell(
  //               onTap: (){
  //                 if(txt_search.text.isNotEmpty){
  //                   clear_icon = false;
  //                   txt_search.clear();
  //                   // recipeModel.recipeList_ditels_api(search_test:'');
  //                 }
  //               },
  //               child: Padding(
  //                 padding: const EdgeInsets.all(15),
  //                 child: SvgPicture.asset(
  //                   'assets/Close Button Light.svg',
  //                   height: 1,
  //                 ),
  //               ),
  //             ):Container(width: 1,),
  //             fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
  //             autofillHints: const [AutofillHints.name],
  //             textInputAction: TextInputAction.done,
  //             keyBoardType: TextInputType.text,
  //             validatorFieldValue: 'Search',
  //             onSubmitted: (val){
  //               setState(() {
  //                 print(val.length);
  //                 if(val.length>0){
  //                   clear_icon = true;
  //                   search_done = true;
  //                   // recipeModel.recipeList_ditels_api(search_test:txt_search.text.toString());
  //                 }
  //
  //               });
  //             },
  //             onChanged: (val){
  //               setState(() {
  //                 clear_icon = false;
  //                 print(val.length);
  //                 if(val.length==0){
  //
  //                   if(search_done){
  //                     search_done = false;
  //                     textfieldfocus = false;
  //                    // recipeModel.getRecipeData(context,'',recipeModel.fav_filter,recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
  //                   }
  //                 }
  //               });
  //             },
  //
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  /// heading function
  Widget headingtile(headingtext){
    return Container(
      width: deviceWidth(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: deviceWidth(context,0.9),
            child: Text(headingtext,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: fontFamilyText,
                  color: colorRichblack,
                  fontWeight: fontWeight600,
                  overflow: TextOverflow.ellipsis
              ),),
          ),
         // const Icon(Icons.arrow_forward_ios_rounded,size: 18,)
        ],
      ),

    );
  }

  Widget continue_learning(){
    return  Container(
      height: 170,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.only(right:20.0),
              child: InkWell(
               onTap: (){
                 PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                   context,
                   settings: const RouteSettings(name: "/Modules"),
                   screen:  const ModuleDescriptionScreen(),
                 );

               },

                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),

                  ),
                  width: deviceWidth(context,0.68),
                  height: 155,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: const DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('assets/Screen Shot 2022-12-16 at 9.39 2.png')
                          ),

                        ),
                        width: deviceWidth(context,0.68),
                        height: 155,
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
                        width: deviceWidth(context,0.68),
                        height: 155,
                        padding: const EdgeInsets.only(bottom: 10,left: 18),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text('Benefits of Healthy Eating',style: TextStyle(
                              fontSize: 16,
                              fontFamily: fontFamilyText,
                              color: colorWhite,
                              fontWeight: fontWeight600,
                              overflow: TextOverflow.ellipsis
                          ),maxLines: 2,),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );

          }),
    );



  }

  Widget recommended_list(){
    return Container(
      height: 165,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),

                ),
                width: deviceWidth(context,0.38),
                height: 145,
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
                      width: deviceWidth(context,0.38),
                      height: 145,
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
                      width: deviceWidth(context,0.38),
                      height: 145,
                      padding: EdgeInsets.only(bottom: 10,left: 20),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('True Healthy Eating',style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontFamilyText,
                            color: colorWhite,
                            fontWeight: fontWeight600,
                            overflow: TextOverflow.ellipsis
                        ),maxLines: 2,),
                      ),
                    )
                  ],
                ),
              ),
            );

          }),
    );
  }

  Widget module_library_list(modulesProviderData){

    return Container(

      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Center(
                child: ExpansionTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  backgroundColor: HexColor('#E9ECF1'),
                  collapsedBackgroundColor: HexColor('#E9ECF1'),
                  trailing:  CircleAvatar(
                    backgroundColor: modulesProviderData.iconColor?HexColor('#3B4250'):colorWhite,
                    radius: 15,
                    child: modulesProviderData.iconColor?Icon(Icons.clear,color:colorWhite,size: 20,):Icon(Icons.add,color: HexColor('#3B4250'),size: 20,),
                  ),
                  title: Text('Healthy Eating',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: fontFamilyText,
                        color: HexColor('#3B4250'),
                        fontWeight: fontWeight400,
                        overflow: TextOverflow.ellipsis
                    ),),
                  onExpansionChanged: (value){
                    setState(() {
                      modulesProviderData.IconColor(value);

                    });

                  },
                  // Contents
                  children: [
                    Container(
                      color: colorWhite,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (BuildContext context,int index){
                            return Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                              child: ExpansionTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                collapsedShape:RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ) ,
                                backgroundColor: HexColor('#E9ECF1'),
                                collapsedBackgroundColor: HexColor('#E9ECF1'),
                                iconColor:  HexColor('#3B4250'),
                                title: Text('Understanding Healthy Eating',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: fontFamilyText,
                                      color: HexColor('#3B4250'),
                                      fontWeight: fontWeight600,
                                      overflow: TextOverflow.ellipsis
                                  ),),
                                // Contents
                                children: [
                                  Container(
                                    color: colorWhite,
                                    child: Column(
                                      children: [
                                        Container(
                                         width: deviceWidth(context),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset('assets/image/play-circle 1.svg'),
                                               sizedboxwidth(10.0),
                                                Container(
                                                  width: deviceWidth(context,0.7),
                                                  child: Text('True Healthy Eating',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: fontFamilyText,
                                                        color: HexColor('#3B4250'),
                                                        fontWeight: fontWeight400,
                                                        overflow: TextOverflow.ellipsis
                                                    ),),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: deviceWidth(context),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset('assets/image/lock_icon.svg'),
                                                sizedboxwidth(10.0),
                                                Container(
                                                  width: deviceWidth(context,0.7),
                                                  child: Text('Fad Diets vs Healthy Eating',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: fontFamilyText,
                                                        color: colorShadowBlue,
                                                        fontWeight: fontWeight400,
                                                        overflow: TextOverflow.ellipsis
                                                    ),),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  )


                                ],
                              ),
                            );
                          }),
                    )

                  ],
                ),
              ),
            );

          }),
    );
  }
}
