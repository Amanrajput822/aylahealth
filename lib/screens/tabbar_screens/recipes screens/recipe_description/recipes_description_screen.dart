import 'dart:convert';

import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/screens/tabbar_screens/recipes%20screens/recipe_description/Recipe_Description_DataProvider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fraction/fraction.dart';
import 'package:function_tree/function_tree.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/styles/Fluttertoast_internet.dart';
import '../recipe_screen/RecipeData_Provider.dart';
class Recipes_Description_Screen extends StatefulWidget {
  var rec_id;
  int? rec_index;
  String? txt_search;
  String? fav_filter;
   Recipes_Description_Screen({Key? key, this.rec_id,this.rec_index, this.txt_search, this.fav_filter}) : super(key: key);

  @override
  State<Recipes_Description_Screen> createState() => _Recipes_Description_ScreenState();
}

class _Recipes_Description_ScreenState extends State<Recipes_Description_Screen> with SingleTickerProviderStateMixin{
   GlobalKey _childKey = GlobalKey();
   GlobalKey _childKey1 = GlobalKey();
  bool isHeightCalculated = false;
  double height12 = 0.0;
  TabController? controller;
  Future? _future;
 @override
 void initState() {
   // TODO: implement initState
   super.initState();
  // _future = recipe_ditels_api();
   final recipeModel = Provider.of<Recipe_Description_DataProvider>(context, listen: false);
   recipeModel.getRecipeData(context,widget.rec_id);
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
int tab_value = 0;
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

    final recipeModel = Provider.of<Recipe_Description_DataProvider>(context);
    final recipeModel1 = Provider.of<RecipeData_Provider>(context);

    return WillPopScope(
      onWillPop: () async{
        if(widget.fav_filter=='1'){
          // Navigator.pop(context);
          if(recipeModel1.recipe_data_List![widget.rec_index!].favStatus == 0){
            recipeModel1.unRecipeData1(context,recipeModel1.recipe_data_List![widget.rec_index!].recId,widget.txt_search,'1');
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
            child:recipeModel.loading
                ? Container(
              child: Center(child: CircularProgressIndicator()),
            ) : Scaffold(
              backgroundColor: colorWhite,
              body:recipeModel.loading
                  ? Container(
                child: Center(child: CircularProgressIndicator()),
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
                                    Container(
                                      height: deviceheight(context,0.25),
                                      width: deviceWidth(context),
                                      child: Image.network(recipeModel.recipe_ditels_data!.image??"",fit: BoxFit.fill,
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
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                                onTap: (){
                                                  if(widget.fav_filter=='1'){
                                                    // Navigator.pop(context);
                                                    if(recipeModel1.recipe_data_List![widget.rec_index!].favStatus == 0){
                                                      recipeModel1.unRecipeData1(context,recipeModel1.recipe_data_List![widget.rec_index!].recId,widget.txt_search,'1');

                                                    }Navigator.pop(context);
                                                  }
                                                  else {
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: CircleAvatar(
                                                    backgroundColor: Colors.transparent,
                                                    radius: 15,
                                                    child: SvgPicture.asset('assets/backbutton.svg',color: colorWhite,height: 15,))),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SvgPicture.asset('assets/image/Plus.svg',height: 26,),
                                                sizedboxwidth(10.0),
                                                InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      // if(recipeModel.recipe_ditels_data!.favStatus == 0){
                                                      //   recipeModel.recipe_ditels_data!.favStatus = 1;
                                                      //   recipeModel.likeRecipeData(context,recipeModel.recipe_ditels_data!.recId);
                                                      // }
                                                      // else if(recipeModel.recipe_ditels_data!.favStatus == 1){
                                                      //   recipeModel.recipe_ditels_data!.favStatus = 0;
                                                      //   recipeModel.unRecipeData(context,recipeModel.recipe_ditels_data!.recId);
                                                      //
                                                      // }

                                                      if(recipeModel1.recipe_data_List![widget.rec_index!].favStatus == 0){
                                                        recipeModel1.recipe_data_List![widget.rec_index!].favStatus = 1;
                                                        recipeModel1.likeRecipeData1(context,recipeModel1.recipe_data_List![widget.rec_index!].recId);
                                                      }
                                                      else if(recipeModel1.recipe_data_List![widget.rec_index!].favStatus == 1){
                                                        recipeModel1.recipe_data_List![widget.rec_index!].favStatus = 0;
                                                        if(widget.fav_filter=='1'){
                                                          // recipeModel1.unRecipeData1(context,recipeModel1.recipe_data_List![widget.rec_index!].recId,widget.txt_search,'0');

                                                        }else{
                                                          recipeModel1.unRecipeData1(context,recipeModel1.recipe_data_List![widget.rec_index!].recId,widget.txt_search,'0');

                                                        }
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 28,width: 28,

                                                    alignment: Alignment.topRight,

                                                    child:recipeModel1.recipe_data_List![widget.rec_index!].favStatus == 1?
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
                                    Text(recipeModel.recipe_ditels_data!.recTitle??"",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: fontFamilyText,
                                          color: colorRichblack,
                                          fontWeight: fontWeight600,
                                          overflow: TextOverflow.ellipsis
                                      ),),
                                    Text(recipeModel.recipe_ditels_data!.recDescription??"",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: fontFamilyText,
                                        color: HexColor('#6A707F'),
                                        fontWeight: fontWeight400,
                                      ),),
                                    sizedboxheight(8.0),
                                    Container(
                                      child: Wrap(

                                        children: [
                                          for(var item in recipeModel.recipe_ditels_data!.recipeCategory!)...[
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
                                          recipeModel.recipe_ditels_data!.eatName!=null?Card(
                                            elevation: 0,
                                            color: HexColor('#F6F8F9'),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10.0,right: 10,top: 6,bottom: 6),
                                              child: Text(recipeModel.recipe_ditels_data!.eatName??"", style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: fontFamilyText,
                                                color: colorShadowBlue,
                                                fontWeight: fontWeight400,

                                              ),),
                                            ),
                                          ):Container(),
                                          for(var item in recipeModel.recipe_ditels_data!.recipeTag!)...[
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
                                    ),
                                    sizedboxheight(18.0),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              if(recipeModel.server_count! >1){
                                                recipeModel.updateeatingPattern(recipeModel.server_count! - 1);
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
                                        Text('${recipeModel.server_count!.toString()} serve',style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: fontFamilyText,
                                          color: colorSlateGray,
                                          fontWeight: fontWeight400,

                                        ),),
                                        sizedboxwidth(12.0),
                                        InkWell(
                                          onTap: (){
                                            setState(() {

                                              if(recipeModel.server_count! <10){
                                                recipeModel.updateeatingPattern(recipeModel.server_count! + 1);
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
                  body:  recipeModel.loading
                      ? Container(
                    child: Center(child: CircularProgressIndicator()),
                  ) :
                  Container(

                    width: deviceWidth(context),
                    height: deviceheight(context),
                    padding: EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 50),
                    child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                      children: [
                        ingredients_container(recipeModel:recipeModel),
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

  Widget ingredients_container({required Recipe_Description_DataProvider recipeModel}){
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

                          Text('${(MixedFraction.fromDouble(((item.ingredientRecipeQuantity!.interpret()/int.parse(recipeModel.recipe_ditels_data!.recServes.toString()))*recipeModel.server_count!)).toString().replaceAll("0/1",'')).trim()} ${item.ingUnit??""} ${item.ingName??""}',
                            style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontFamilyText,
                            color: colorRichblack,
                            fontWeight: fontWeight400,
                          ),),

                          Text(item.varName!=null?('${item.varName??""} ${item.ingredientRecipeDescription??""}'):('${item.ingredientRecipeDescription??""}'),style: TextStyle(
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
           postMdl.recipe_ditels_data!.recipeNutrition!.isNotEmpty?  Wrap(
             children: [
               for(var item in postMdl.recipe_ditels_data!.recipeNutrition!)

                 Padding(
                 padding: const EdgeInsets.only(right: 5),
                 child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Text(MixedFraction.fromDouble(1.5).toString()),
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
           ):Container(child:  Text('To view the nutrition content for the recipe, '
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
}
