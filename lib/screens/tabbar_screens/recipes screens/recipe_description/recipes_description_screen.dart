import 'dart:convert';

import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/screens/tabbar_screens/recipes%20screens/recipe_description/Recipe_Description_DataProvider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:custom_cupertino_picker/custom_cupertino_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fraction/fraction.dart';
import 'package:function_tree/function_tree.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../common/commonwidgets/button.dart';
import '../../../../common/styles/Fluttertoast_internet.dart';
import '../../../../models/recipelist/Recipe_details_data_model.dart';
import '../../home/homeScreenProvider.dart';
import '../../my_meals/My_Meals_Provider.dart';
import '../../my_meals/calendar_evryday_json.dart';
import '../recipe_screen/RecipeData_Provider.dart';
class Recipes_Description_Screen extends StatefulWidget {
  var rec_id;
  int? rec_index;
  String? txt_search;
  String? fav_filter;
  String? screen;
   Recipes_Description_Screen({Key? key, this.rec_id,this.rec_index, this.txt_search, this.fav_filter, this.screen}) : super(key: key);

  @override
  State<Recipes_Description_Screen> createState() => _Recipes_Description_ScreenState();
}

class _Recipes_Description_ScreenState extends State<Recipes_Description_Screen> with SingleTickerProviderStateMixin{
   final GlobalKey _childKey = GlobalKey();

  int tab_value = 0;

  bool isHeightCalculated = false;
  double height12 = 0.0;
  TabController? controller;

 @override
 void initState() {
   // TODO: implement initState
   super.initState();
  // _future = recipe_ditels_api();
   final recipeDescreptioModel = Provider.of<Recipe_Description_DataProvider>(context, listen: false);
   recipeDescreptioModel.getRecipeData(context,widget.rec_id);
   _childKey.currentState?.dispose();
   height12 = 0.0;
   isHeightCalculated = false;
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     if (!isHeightCalculated) {
       setState(() {
         height12 =  (_childKey.currentContext!.findRenderObject() as RenderBox).size.height+20+deviceheight(context,0.25);
         isHeightCalculated = true;
       });
     }
   });
   final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
   mealsModel.get_meals_plantypelist_api();
   //widgetheight(_childKey1);
 }

 @override
  void dispose() {
    // TODO: implement dispose
   _childKey.currentState?.dispose();
   height12 = 0.0;
   isHeightCalculated = false;
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!isHeightCalculated) {
        setState(() {
          height12 =  (_childKey.currentContext!.findRenderObject() as RenderBox).size.height+20+deviceheight(context,0.25);
          isHeightCalculated = true;
        });
      }
    });

    final recipeDescreptioModel = Provider.of<Recipe_Description_DataProvider>(context);
    final recipeModel = Provider.of<RecipeData_Provider>(context);

    return WillPopScope(
      onWillPop: () async{
        if(widget.fav_filter=='1'){
          // Navigator.pop(context);
          if(recipeModel.recipe_data_List![widget.rec_index!].favStatus == 0){
            recipeModel.unlikeRecipeData1(context,recipeModel.recipe_data_List![widget.rec_index!].recId,widget.txt_search,'1');
          }
          Navigator.pop(context);
        }
        else {
          Navigator.pop(context);
        }

        return true; // return true if the route to be popped
      },
      child: DefaultTabController(
        length: 3,
        child: Container(
          color: colorWhite,
          child: SafeArea(
            top: true,
            child:Scaffold(
              backgroundColor: colorWhite,
              body:recipeDescreptioModel.loading
                  ? Container(
                child: const Center(child: CircularProgressIndicator()),
              ) :NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                       SliverAppBar(

                        scrolledUnderElevation: 0.0,
                        automaticallyImplyLeading: false,
                        pinned: true,
                        floating: true,
                        backgroundColor: Colors.white,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          background: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(

                                height: deviceheight(context,0.25),
                                width: deviceWidth(context),
                                color: colorgrey,
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: deviceheight(context,0.25),
                                      width: deviceWidth(context),
                                      child: Image.network(recipeDescreptioModel.recipe_ditels_data!.image??
                                         "https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE="
                                        ,fit: BoxFit.fill,
                                        errorBuilder: (context, url, error) => Image.network("https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=",
                                          fit: BoxFit.fill,),
                                        loadingBuilder: (BuildContext context, Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },),
                                    ),
                                    Container(
                                      height: deviceheight(context,0.25),
                                      width: deviceWidth(context),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                                onTap: (){
                                                  if(widget.fav_filter=='1'){
                                                    // Navigator.pop(context);
                                                    if(recipeModel.recipe_data_List![widget.rec_index!].favStatus == 0){
                                                      recipeModel.unlikeRecipeData1(context,recipeModel.recipe_data_List![widget.rec_index!].recId,widget.txt_search,'1');

                                                    }Navigator.pop(context);
                                                  }
                                                  else {
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: CircleAvatar(
                                                    backgroundColor: Colors.white,
                                                    radius: 12.5,
                                                    child: SvgPicture.asset('assets/backbutton.svg',color: colorBluePigment,height: 13,))),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                    onTap: (){
                                                      print(recipeModel.meals_screen);
                                                      if(recipeModel.meals_screen){
                                                        print(recipeModel.select_mealplanID_recipe.toString());
                                                      }else{
                                                        recipeModel.selectedDate_string(null);
                                                        recipeModel.selectedDay_data(DateTime.now());
                                                        recipeModel.selectedDate_string(null);
                                                        recipeModel.meal_plan_id_select_fuction_recipe(null);
                                                      }

                                                      add_meals_bottom_sheet(recipeDescreptioModel.recipe_ditels_data);
                                                    },
                                                    child: SvgPicture.asset('assets/image/Plus.svg',height: 26,)),
                                                sizedboxwidth(10.0),
                                                InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                    print('widget.screen');
                                                    print(widget.screen);
                                                    print(widget.screen=="Notification");
                                                      if(widget.screen=="meals"){
                                                        final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
                                                        if(mealsModel.select_tab_data_list![widget.rec_index!].favStatus == 0){
                                                          mealsModel.select_tab_data_list![widget.rec_index!].favStatus = 1;
                                                          recipeDescreptioModel.recipe_ditels_data!.favStatus = 1;
                                                          mealsModel.likeRecipeData1(context,mealsModel.select_tab_data_list![widget.rec_index!].recId);
                                                        }
                                                        else if(mealsModel.select_tab_data_list![widget.rec_index!].favStatus == 1){
                                                          mealsModel.select_tab_data_list![widget.rec_index!].favStatus = 0;
                                                          recipeDescreptioModel.recipe_ditels_data!.favStatus = 0;
                                                          mealsModel.unlikeRecipeData1(context,mealsModel.select_tab_data_list![widget.rec_index!].recId,'','0');
                                                        }

                                                        // if(recipeDescreptioModel.recipe_ditels_data!.favStatus == 0){
                                                        //   recipeDescreptioModel.recipe_ditels_data!.favStatus = 1;
                                                        //   recipeModel.likeRecipeData1(context,recipeDescreptioModel.recipe_ditels_data!.recId);
                                                        // }
                                                        // else if(recipeDescreptioModel.recipe_ditels_data!.favStatus == 1){
                                                        //   recipeDescreptioModel.recipe_ditels_data!.favStatus = 0;
                                                        //   if(widget.fav_filter=='1'){
                                                        //     // recipeModel1.unRecipeData1(context,recipeModel1.recipe_data_List![widget.rec_index!].recId,widget.txt_search,'0');
                                                        //
                                                        //   }else{
                                                        //     recipeModel.unRecipeData1(context,recipeDescreptioModel.recipe_ditels_data!.recId,widget.txt_search,'0');
                                                        //
                                                        //   }
                                                        // }
                                                      }
                                                    else if(widget.screen=="Home"){
                                                        final homeScreenProviderData = Provider.of<HomeScreenProvider>(context, listen: false);
                                                        if(homeScreenProviderData.recipe_data_List![widget.rec_index!].favStatus == 0){
                                                          homeScreenProviderData.recipe_data_List![widget.rec_index!].favStatus = 1;
                                                          recipeDescreptioModel.recipe_ditels_data!.favStatus = 1;
                                                          homeScreenProviderData.likeRecipeData1(context,homeScreenProviderData.recipe_data_List![widget.rec_index!].recId);
                                                        }
                                                        else if(homeScreenProviderData.recipe_data_List![widget.rec_index!].favStatus == 1){
                                                          homeScreenProviderData.recipe_data_List![widget.rec_index!].favStatus = 0;
                                                          recipeDescreptioModel.recipe_ditels_data!.favStatus = 0;
                                                          homeScreenProviderData.unlikeRecipeData1(context,homeScreenProviderData.recipe_data_List![widget.rec_index!].recId,'','0');
                                                        }

                                                      }

                                                      else if(widget.screen=="HomeToday"){
                                                        final homeScreenProviderData = Provider.of<HomeScreenProvider>(context, listen: false);
                                                        if(homeScreenProviderData.select_tab_data_list1![widget.rec_index!].favStatus == 0){
                                                          homeScreenProviderData.select_tab_data_list1![widget.rec_index!].favStatus = 1;
                                                          recipeDescreptioModel.recipe_ditels_data!.favStatus = 1;
                                                          homeScreenProviderData.likeRecipeData1(context,homeScreenProviderData.select_tab_data_list1![widget.rec_index!].recId);
                                                        }
                                                        else if(homeScreenProviderData.select_tab_data_list1![widget.rec_index!].favStatus == 1){
                                                          homeScreenProviderData.select_tab_data_list1![widget.rec_index!].favStatus = 0;
                                                          recipeDescreptioModel.recipe_ditels_data!.favStatus = 0;
                                                          homeScreenProviderData.unlikeRecipeData1(context,homeScreenProviderData.select_tab_data_list1![widget.rec_index!].recId,'','0');
                                                        }
                                                      }

                                                      else if(widget.screen=="Notification"){
                                                        if(recipeDescreptioModel.recipe_ditels_data!.favStatus == 0){
                                                          recipeDescreptioModel.recipe_ditels_data!.favStatus = 1;
                                                          recipeDescreptioModel.recipe_like_api(context,recipeDescreptioModel.recipe_ditels_data!.recId!);
                                                        }
                                                        else if(recipeDescreptioModel.recipe_ditels_data!.favStatus == 1){
                                                          recipeDescreptioModel.recipe_ditels_data!.favStatus = 0;
                                                          recipeDescreptioModel.recipe_unlike_api(context,recipeDescreptioModel.recipe_ditels_data!.recId);
                                                        }
                                                      }
                                                      else{
                                                        if(recipeModel.recipe_data_List![widget.rec_index!].favStatus == 0){
                                                          recipeModel.recipe_data_List![widget.rec_index!].favStatus = 1;
                                                          recipeDescreptioModel.recipe_ditels_data!.favStatus = 1;
                                                          recipeModel.likeRecipeData1(context,recipeModel.recipe_data_List![widget.rec_index!].recId);
                                                        }
                                                        else if(recipeModel.recipe_data_List![widget.rec_index!].favStatus == 1){
                                                          recipeModel.recipe_data_List![widget.rec_index!].favStatus = 0;
                                                          recipeDescreptioModel.recipe_ditels_data!.favStatus = 0;
                                                          if(widget.fav_filter=='1'){
                                                            // recipeModel1.unRecipeData1(context,recipeModel1.recipe_data_List![widget.rec_index!].recId,widget.txt_search,'0');

                                                          }else{
                                                            recipeModel.unlikeRecipeData1(context,recipeModel.recipe_data_List![widget.rec_index!].recId,widget.txt_search,'0');

                                                          }
                                                        }
                                                      }

                                                    });
                                                  },
                                                  child: Container(
                                                    height: 28,width: 28,

                                                    alignment: Alignment.topRight,

                                                    child:recipeDescreptioModel.recipe_ditels_data!.favStatus == 1?
                                                    Center(child: SvgPicture.asset('assets/image/Heart_lick.svg',height: 26,)):
                                                    Center(child: SvgPicture.asset('assets/image/Heart_unlick.svg',height: 26,)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Container(
                                key: _childKey,
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(recipeDescreptioModel.recipe_ditels_data!.recTitle??"",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: fontFamilyText,
                                          color: colorRichblack,
                                          fontWeight: fontWeight600,

                                      ),),
                                    Text(recipeDescreptioModel.recipe_ditels_data!.recDescription??"",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: fontFamilyText,
                                        color: HexColor('#6A707F'),
                                        fontWeight: fontWeight400,
                                      ),),
                                    sizedboxheight(8.0),
                                    Wrap(
                                      children: [
                                        for(var item in recipeDescreptioModel.recipe_ditels_data!.recipeCategory!)...[
                                          Card(
                                            elevation: 0,
                                            color: HexColor('#F6F8F9'),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10.0,right: 10,top: 6,bottom: 6),
                                              child: Text(item.catName??"", style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: fontFamilyText,
                                                color: colorShadowBlue,
                                                fontWeight: fontWeight400,

                                              ),),
                                            ),
                                          ),
                                        ],
                                        recipeDescreptioModel.recipe_ditels_data!.eatName!=null?Card(
                                          elevation: 0,
                                          color: HexColor('#F6F8F9'),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10.0,right: 10,top: 6,bottom: 6),
                                            child: Text(recipeDescreptioModel.recipe_ditels_data!.eatName??"", style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: fontFamilyText,
                                              color: colorShadowBlue,
                                              fontWeight: fontWeight400,

                                            ),),
                                          ),
                                        ):Container(),
                                        for(var item in recipeDescreptioModel.recipe_ditels_data!.recipeTag!)...[
                                          Card(
                                            elevation: 0,
                                            color: HexColor('#F6F8F9'),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10.0,right: 10,top: 6,bottom: 6),
                                              child: Text(item.tagName??"", style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: fontFamilyText,
                                                color: colorShadowBlue,
                                                fontWeight: fontWeight400,

                                              ),),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    sizedboxheight(18.0),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              if(recipeDescreptioModel.server_count! >1){
                                                recipeDescreptioModel.updateeatingPattern(recipeDescreptioModel.server_count! - 1);
                                              }
                                              else{
                                                FlutterToast_message('Serve cannot be less than 1');
                                              }

                                            });
                                          },
                                          child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor: colorSlateGray,
                                            child: CircleAvatar(
                                              radius: 9,
                                              backgroundColor: colorWhite,
                                              child: Icon(Icons.remove,size: 16,color: colorBluePigment,),
                                            ),
                                          ),
                                        ),
                                        sizedboxwidth(12.0),
                                        Text('${recipeDescreptioModel.server_count!.toString()} serve',style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: fontFamilyText,
                                          color: colorSlateGray,
                                          fontWeight: fontWeight400,

                                        ),),
                                        sizedboxwidth(12.0),
                                        InkWell(
                                          onTap: (){
                                            setState(() {

                                              if(recipeDescreptioModel.server_count! <10){
                                                recipeDescreptioModel.updateeatingPattern(recipeDescreptioModel.server_count! + 1);
                                              }
                                              else{
                                                FlutterToast_message('serve cannot be greater 10');
                                              }
                                            });
                                          },
                                          child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor: colorSlateGray,
                                            child: CircleAvatar(
                                              radius: 9,
                                              backgroundColor: colorWhite,
                                              child: Icon(Icons.add,size: 16,color: colorBluePigment,),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ).paddingOnly(left: 5),

                                    sizedboxheight(15.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        expandedHeight: isHeightCalculated?height12+15:deviceheight(context),
                        bottom:  TabBar(
                          indicatorColor: colorBluePigment,
                          indicatorSize:TabBarIndicatorSize.label ,
                          indicatorWeight: 1.5,
                          automaticIndicatorColorAdjustment: true,
                          labelColor: colorBluePigment,
                          padding: const EdgeInsets.only(right: 15),
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: fontFamilyText,
                            color: colorBluePigment,
                            fontWeight: fontWeight400,
                          ),
                          unselectedLabelColor: colorShadowBlue,
                          unselectedLabelStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: fontFamilyText,
                            color: colorShadowBlue,
                            fontWeight: fontWeight400,
                          ),
                          onTap: (index){
                            setState(() {
                              tab_value = index;
                            });
                          },
                          labelPadding: EdgeInsets.zero,
                          tabs: const [
                            Tab(child: Text('Ingredients')),
                            Tab(child: Text('Method')),
                            Tab(child: Text('Notes & Nutrition')),
                          ],
                        ),
                      )
                    ];
                  },
                  body:  recipeDescreptioModel.loading
                      ? Container(
                    child: const Center(child: CircularProgressIndicator()),
                  ) :
                  Container(

                    width: deviceWidth(context),
                    height: deviceheight(context),
                    padding: const EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 50),
                    child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ingredients_container(recipeDescreptioModel:recipeDescreptioModel),
                        method_container(),
                        notes_nutrition_container(),
                      ],
                    ),
                  ),
                )


            ),
          ),
        ),
      ),
    );
  }


   Widget ingredients_container({required Recipe_Description_DataProvider recipeDescreptioModel}){
    final postMdl = Provider.of<Recipe_Description_DataProvider>(context);
    return Container(

      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            for(var item in postMdl.recipe_ditels_data!.recipeIngredient!)...[

              Container(
                padding: EdgeInsets.only(top: 10,bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Icon(Icons.arrow_forward_ios,size: 12,color: HexColor('#3B4250'),),
                    ),
                    sizedboxwidth(10.0),
                    SizedBox(
                      width: deviceWidth(context,0.7),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text('${(MixedFraction.fromDouble(((item.ingredientRecipeQuantity!.interpret()/int.parse(recipeDescreptioModel.recipe_ditels_data!.recServes.toString()))*recipeDescreptioModel.server_count!)).toString().replaceAll("0/1",'')).trim()} ${item.ingUnit??""} ${item.ingName??""}',
                            style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontFamilyText,
                            color: colorRichblack,
                            fontWeight: fontWeight400,
                          ),),

                          Text(item.varName!=null?('${item.varName??""} ${item.ingredientRecipeDescription??""}'):(item.ingredientRecipeDescription??""),style: TextStyle(
                            fontSize: 12,
                            fontFamily: fontFamilyText,
                            color: colorShadowBlue,
                            fontWeight: fontWeight400,
                          ),),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
  Widget method_container(){
    final postMdl = Provider.of<Recipe_Description_DataProvider>(context);
    return Container(
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           for(int i=0;i<postMdl.recipe_ditels_data!.recipeMethod!.length;i++)
            Padding(
              padding: const EdgeInsets.only(top: 10,bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(('${i+1}.').toString(),style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontFamily: fontFamilyText,
                    color: colorRichblack,
                    fontWeight: fontWeight400,
                  ),),
                  sizedboxwidth(8.0),
                  Container(
                    width: deviceWidth(context ,0.8),
                    child: Text(postMdl.recipe_ditels_data!.recipeMethod![i].rmStep??"",style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontFamily: fontFamilyText,
                      color: colorRichblack,
                      fontWeight: fontWeight400,
                    ),),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
 Widget notes_nutrition_container(){
   final postMdl = Provider.of<Recipe_Description_DataProvider>(context);
   return Container(
     padding: EdgeInsets.only(top: 10,bottom: 10),
     child: SingleChildScrollView(
       physics: NeverScrollableScrollPhysics(),
       child: Column(
         mainAxisSize: MainAxisSize.min,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text('Notes',style: TextStyle(
             fontSize: 16,
             height: 1.5,
             fontFamily: fontFamilyText,
             color: colorRichblack,
             fontWeight: fontWeight600,
           ),),
           Text(postMdl.recipe_ditels_data!.recNote??"",style: TextStyle(
             fontSize: 16,
             height: 1.4,
             fontFamily: fontFamilyText,
             color: colorRichblack,
             fontWeight: fontWeight400,
           ),),
           sizedboxheight(8.0),
           Text('Nutrition',style: TextStyle(
             fontSize: 16,
             height: 1.5,
             fontFamily: fontFamilyText,
             color: colorRichblack,
             fontWeight: fontWeight600,
           ),),
           sizedboxheight(8.0),
           Text('Per serve:',style: TextStyle(
             fontSize: 16,
             height: 1.5,
             fontFamily: fontFamilyText,
             color: colorRichblack,
             fontWeight: fontWeight400,
           ),),
           postMdl.recipe_ditels_data!.recipeNutritionExists == 1?
           Wrap(
             children: [
               for(var item in postMdl.recipe_ditels_data!.recipeNutrition!)

                 Padding(
                 padding: const EdgeInsets.only(right: 5),
                 child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Text(item.nutName != null?'${item.nutName!.replaceAll("(", ", ").split(")")[0]}: ':"",style: TextStyle(
                       fontSize: 16,
                       height: 1.5,
                       fontFamily: fontFamilyText,
                       color: colorShadowBlue,
                       fontWeight: fontWeight400,
                     ),),
                     Text(item.recNutQuantity != null?'${item.recNutQuantity}${item.nutUnit} ':" ",style: TextStyle(
                       fontSize: 16,
                       height: 1.5,
                       fontFamily: fontFamilyText,
                       color: colorRichblack,
                       fontWeight: fontWeight400,
                     ),),
                   ],
                 ),
               ),
             ],
           ):
           Container(child:  Text('To view the nutrition content for the recipe, '
               'go to the Food and Nutrition Settings > Nutrient Content '
               'Information and select ‘Show Nutrition Content’',style: TextStyle(
             fontSize: 14,
             height: 1.5,
             fontFamily: fontFamilyText,
             color: colorShadowBlue,
             fontWeight: fontWeight400,
           )),)
         ],
       ),
     ),
   );
 }
   /// add meals bottom sheet //////////////////////

   void showBottomAlertDialog(BuildContext context) {
     final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);
     final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return Align(
           alignment: Alignment.bottomCenter,
           child: StatefulBuilder(
               builder: (BuildContext context, StateSetter setState) {
                 return Container(
                   margin: EdgeInsets.all(20.0),
                   padding: EdgeInsets.all(16.0),
                   child: Material(
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10.0),
                     ),
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: [

                         Container(
                           margin: EdgeInsets.symmetric(horizontal: 20.0),
                           padding: EdgeInsets.only(bottom: 10),
                           child: TableCalendar(
                             rowHeight: 35,
                             firstDay: DateTime(2022),
                             lastDay: DateTime(2050),
                             focusedDay:recipeModel.focusedDay,
                             startingDayOfWeek: StartingDayOfWeek.monday,
                             selectedDayPredicate: (day) => isSameDay(recipeModel.selectedDay, day),
                             calendarFormat: CalendarFormat.month,
                             calendarStyle: CalendarStyle(
                               outsideDaysVisible: false,
                               weekendTextStyle: TextStyle(color: HexColor('#3B4250') ,fontSize: 14, fontWeight: fontWeight400, fontFamily: fontFamilyText,) ,
                               defaultTextStyle:TextStyle(color: HexColor('#3B4250') ,fontSize: 14, fontWeight: fontWeight400, fontFamily: fontFamilyText,) ,
                               disabledTextStyle:TextStyle(color: HexColor('#9E9E9E') ,fontSize: 14, fontWeight: fontWeight400, fontFamily: fontFamilyText,) ,
                               selectedTextStyle: TextStyle(color: colorWhite ,fontSize: 14, fontWeight: fontWeight400, fontFamily: fontFamilyText,),
                               todayTextStyle: TextStyle(color: colorBlackRichBlack ,fontSize: 14, fontWeight: fontWeight400, fontFamily: fontFamilyText,),

                               selectedDecoration: BoxDecoration(shape: BoxShape.rectangle, color: colorBluePigment, borderRadius: BorderRadius.circular(5),),
                               defaultDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5),),
                               weekendDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                               disabledDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                               todayDecoration: BoxDecoration(color: Colors.black26,borderRadius: BorderRadius.circular(5)),

                             ),


                             headerStyle: HeaderStyle(
                                 titleCentered: true,
                                 leftChevronMargin: EdgeInsets.only(left: 1),
                                 leftChevronIcon: Icon(Icons.chevron_left,color: colorSlateGray,),
                                 rightChevronIcon: Icon(Icons.chevron_right,color: colorSlateGray,),
                                 rightChevronVisible: true,
                                 // titleTextFormatter: (date, locale) => DateFormat.MMMM(locale).format(date),
                                 formatButtonVisible : false,
                                 formatButtonDecoration: BoxDecoration(

                                 ),
                                 titleTextStyle: TextStyle(
                                   color: colorRichblack,
                                   fontSize: 14,
                                   fontWeight: fontWeight600,
                                   fontFamily: fontFamilyText,
                                 )
                             ),

                             daysOfWeekStyle: DaysOfWeekStyle(
                               weekdayStyle: TextStyle(color: colorSlateGray ,fontSize: 11, fontWeight: fontWeight600, fontFamily: fontFamilyText, ),
                               weekendStyle:TextStyle(color: colorSlateGray ,fontSize: 11, fontWeight: fontWeight600, fontFamily: fontFamilyText, ),
                             ),

                             // onFormatChanged: (format) {
                             //   setState(() {
                             //     _calendarFormat = format;
                             //   });
                             // },
                             onHeaderTapped: (_) {
                               setState(() {
                                 // calendar_listview = true;
                               });
                             },
                             onPageChanged: (focusedDay) {
                               setState(() {
                                 recipeModel.focusedDay_data(focusedDay);

                               });
                             },

                             onDaySelected: (selectedDay, focusedDay) {
                               print(selectedDay.toString());
                               print(focusedDay.toString());
                               setState(() {
                                 recipeModel.selectedDay_data(selectedDay);
                                 recipeModel.selectedDate_string(DateFormat('EEEE d MMM').format(selectedDay));

                                 Navigator.pop(context);
                                 DateFormat('EEEE d MMM yyyy').format(selectedDay);
                                 print(DateFormat('EE d MMM').format(selectedDay));
                                 mealsModel.get_meals_calendardata_api(context, selectedDay.year.toString(),selectedDay.month.toString(),int.parse(recipeModel.select_mealplanID_recipe.toString())-1,"0",selectedDay);
                                // mealsModel.get_meals_calendardata_multiple_months_api(context,selectedDay,int.parse(recipeModel.select_mealplanID_recipe.toString())-1);
                                 // only_year_json_create_fuction(selectedDay.year.toString(), selectedDay.month.toString(),selectedDay.day.toString());

                                 // int s = getTotalDaysInMonth(_selectedDay!.year, _selectedDay!.month);
                                 // if(totalDays == s){
                                 //   print(totalDays == s);
                                 // }else{
                                 //   complet_month_json(selectedDay);
                                 // }

                                 //  DateFormat.MMMMEEEEd(focusedDay).format(selectedDay);
                               });
                             },
                           ),
                         ),
                       ],
                     ),
                   ),
                 );
               }
           ),
         );
       },
     );
   }



   void _showPicker(BuildContext ctx) {
     final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
     final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);

     showCupertinoModalPopup(
         barrierDismissible:true,
         context: ctx,
         builder: (_) => Container(
           width: 250,
           height: 300,
           padding: EdgeInsets.only(bottom: 50),
           decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(20)
           ),
           child: Container(

             decoration: BoxDecoration(
                 color: colorWhite,
                 borderRadius: BorderRadius.circular(20)
             ),
             child: CustomCupertinoPicker(

                 highlighterBorder: Border(
                   top: BorderSide(
                     width: 0.5, color: HexColor('#BEBEBE'),
                   ),
                   bottom: BorderSide(
                     width: 0.5,  color: HexColor('#BEBEBE'),
                   ),
                 ),
                 highlighterBorderWidth: 80,
                 magnification:1.1,
                 scrollPhysics: const FixedExtentScrollPhysics(
                   parent: BouncingScrollPhysics(),
                 ),
                 itemExtent: 31.0,
                 useMagnifier: true,
                 squeeze: 1.0,diameterRatio: 1.5,

                 onSelectedItemChanged: (int value) {
                     print(value);
                     recipeModel.meal_plan_id_select_fuction_recipe(mealsModel.get_meals_planlist_data![value].mtId.toString());
                 },
                 children: mealsModel.get_meals_planlist_data!.map((item) {
                   return Text(
                     item.mtName??"",
                     style: TextStyle(fontSize: 16.0,
                         fontFamily: fontFamilyText,
                         fontWeight: fontWeight400,
                         color: colorRichblack
                     ),
                   );
                 }).toList()
             ),
           ),
         ));
   }
   Future<void> add_meals_bottom_sheet(Recipe_details_data_recponse? recipe_data_List){
     final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);
     final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
     return showModalBottomSheet(
         context: context,
         shape: const RoundedRectangleBorder(
           borderRadius: BorderRadius.only(
             topLeft: Radius.circular(10),
             topRight: Radius.circular(10),
           ),
         ),
         isScrollControlled:true,
         backgroundColor: colorWhite,

         builder: (BuildContext context) {
           return Builder(
               builder: (BuildContext context) {
                 return StatefulBuilder(
                     builder: (BuildContext context, setState){
                       return Container(
                         // height: deviceheight(context,0.8),
                         child: Stack(
                           children: [
                             Container(
                               //  height: deviceheight(context,0.8),
                               child: Padding(
                                 padding: const EdgeInsets.only(left: 15.0,right: 15,top: 15,bottom: 70),
                                 child: SingleChildScrollView(
                                   physics: ScrollPhysics(),
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     mainAxisSize: MainAxisSize.min,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: <Widget>[
                                       Container(
                                         width: deviceWidth(context),
                                         height: 60,
                                         child: Center(
                                           child: Text('Add to My Meals',style:TextStyle(
                                               fontSize: 24,
                                               fontFamily: fontFamilyText,
                                               color: colorRichblack,
                                               fontWeight: fontWeight600,
                                               height: 1.5,
                                               overflow: TextOverflow.ellipsis
                                           )),
                                         ),
                                       ),
                                       sizedboxheight(deviceheight(context,0.01),),
                                       Container(
                                         height: 160,
                                         width: 260,

                                         // decoration: BoxDecoration(
                                         //     color: Colors.black12,
                                         //     borderRadius: BorderRadius.circular(5),
                                         //     image: DecorationImage(
                                         //         image: NetworkImage(recipe_data_List!.image??"https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE="),
                                         //         fit: BoxFit.fill
                                         //
                                         //     )
                                         // ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.network(recipe_data_List!.image??"https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=",
                                            height: 160,
                                            width: 260,
                                            fit: BoxFit.fill,
                                            errorBuilder: (context, url, error) => Image.network("https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=",
                                              height: 160,
                                              width: 260,

                                              fit: BoxFit.fill,),
                                            loadingBuilder: (BuildContext context, Widget child,
                                                ImageChunkEvent? loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                       ),
                                       sizedboxheight(deviceheight(context,0.01),),
                                       Text(recipe_data_List.recTitle??"",style:TextStyle(
                                           fontSize: 16,
                                           fontFamily: fontFamilyText,
                                           color: colorRichblack,
                                           fontWeight: fontWeight400,
                                           height: 1.2,
                                           overflow: TextOverflow.ellipsis
                                       )),

                                       sizedboxheight(deviceheight(context,0.02),),
                                       InkWell(
                                           onTap: (){
                                             // _displayDialog( context);
                                             showBottomAlertDialog( context);
                                           },
                                           child: feildcontainer(recipeModel.selectedDate == null?'When do you want to eat this?':recipeModel.selectedDate.toString(),"Add to your calendar",recipeModel.selectedDate == null?1:0)
                                       ),
                                       sizedboxheight(deviceheight(context,0.02),),
                                       InkWell(
                                           onTap: (){
                                             _showPicker(context);
                                             //  _displayDialog( context);
                                           },
                                           child: feildcontainer(recipeModel.select_mealplanID_recipe == null?'At which meal will you eat this?':mealsModel.get_meals_planlist_data![int.parse(recipeModel.select_mealplanID_recipe!) -1].mtName.toString(),"Choose an eating occasion",recipeModel.select_mealplanID_recipe == null?'1':'0')
                                       ),
                                       sizedboxheight(deviceheight(context,0.02),),
                                       add_mymeals_Btn(recipe_data_List.recId??""),
                                       sizedboxheight(deviceheight(context,0.01),),
                                     ],
                                   ),
                                 ),
                               ),
                             ),

                           ],
                         ),
                       );
                     }
                 );
               }
           );
         });
   }
   Widget feildcontainer(title,heading,showtype){
     return Container(
       decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(5),
           color: HexColor('#F6F8F9')
       ),
       padding: EdgeInsets.all(15),
       width: deviceWidth(context),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               showtype==1? Text(heading,
                 style: TextStyle(
                   fontSize: 12,
                   fontFamily: fontFamilyText,
                   color: HexColor('#3B4250'),
                   fontWeight: fontWeight400,
                 ),
               ):Container(),
               showtype=='1'? Text(heading,
                 style: TextStyle(
                   fontSize: 12,
                   fontFamily: fontFamilyText,
                   color: HexColor('#3B4250'),
                   fontWeight: fontWeight400,
                 ),
               ):Container(),
               Text(title.toString(),
                 style: TextStyle(
                   fontSize: 16,
                   fontFamily: fontFamilyText,
                   color: HexColor('#3B4250'),
                   fontWeight: fontWeight400,
                 ),
               ),
             ],
           ),
           SvgPicture.asset('assets/image/chevron-down.svg',color: colorRichblack,)
         ],
       ),
     );
   }
   /// add meals button  /////////////

   Widget add_mymeals_Btn(rec_id) {
     final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
     final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);

     return Container(
       alignment: Alignment.center,
       child: Button(
         buttonName: 'Add to my meals',
         textColor: colorWhite,

         btnfontsize: 20,
         btnfontweight: fontWeight400,
         borderRadius: BorderRadius.circular(8.00),
         btnWidth: deviceWidth(context,0.92),
         btnColor: colorEnabledButton,
         onPressed: () {

           // mealsModel.get_meals_calendardata_api(context, 2024,'7');
           //  removeDataFromFile(_selectedDay!.year.toString());
           print(recipeModel.selectedDay);
           print(recipeModel.selectedDay.runtimeType);
           if(recipeModel.selectedDate != null){
             if(recipeModel.select_mealplanID_recipe!=null){
               if(rec_id!=null){
                 Navigator.pop(context);
                 json_add_api_data_calendar_json_fuction(context,recipeModel.selectedDay.year.toString(),recipeModel.selectedDay.month.toString(),recipeModel.selectedDay.day.toString(),[{"rec_id":rec_id.toString(),"mt_id":recipeModel.select_mealplanID_recipe.toString(),"note":"","logged":"0"}],0);
               }
               else{
                 FlutterToast_message('Add to your calendar');
               }
             }
             else{
               FlutterToast_message('Choose an eating occasion');
             }
           }else{
             FlutterToast_message('Please select Date');
           }

           recipeModel.select_screen_data(false);
           mealsModel.singleDayMeals_change(false);
           //String? array = months_json_fuction();
           // (context as Element).reassemble();
           // Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(PersistentTabController(initialIndex: 3));
           //  Navigator.pop(context);
           // (context as Element).reassemble();
         },
       ),
     );
   }
}
