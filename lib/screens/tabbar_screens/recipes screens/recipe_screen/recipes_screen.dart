
import 'dart:io';

import 'package:aylahealth/common/MultiSelectChip.dart';
import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/models/recipelist/filtter_list_models/RecipeCategoryList_Model.dart';
import 'package:aylahealth/models/recipelist/filtter_list_models/Recipe_Filtter_model.dart';
import 'package:aylahealth/screens/tabbar_screens/recipes%20screens/recipe_description/recipes_description_screen.dart';
import 'package:aylahealth/screens/tabbar_screens/recipes%20screens/recipe_screen/RecipeData_Provider.dart';
import 'package:custom_cupertino_picker/custom_cupertino_picker.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import 'package:table_calendar/table_calendar.dart';


import '../../../../common/commonwidgets/button.dart';
import '../../../../common/formtextfield/mytextfield.dart';
import '../../../../common/new_bottombar_screen/Bottom_NavBar_Provider.dart';
import '../../../../common/styles/Fluttertoast_internet.dart';
import '../../my_meals/calendar_evryday_json.dart';
import '../../../../models/month_json_model.dart';
import '../../my_meals/My_Meals_Provider.dart';
import 'MyBottomSheetWidget.dart';

class Recipes_Screen extends StatefulWidget {
  const Recipes_Screen({Key? key}) : super(key: key);

  @override
  State<Recipes_Screen> createState() => _Recipes_ScreenState();
}

class _Recipes_ScreenState extends State<Recipes_Screen> {
  TextEditingController txt_search = TextEditingController();
  bool textfieldfocus = false;

  bool clear_icon = false;
  bool search_done = false;

  int? _selectedIndex_RecipeCategory;
  int? _selectedRecipeCategory = 0;

  // String? selectedDate;

  List<Widget> choiceChips_RecipeCategory({required List<RecipeCategoryList_Response> recipecategory_list, required RecipeData_Provider recipeModel}) {
    List<Widget> chips = [];
    for (int i = 0; i < recipecategory_list.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(recipecategory_list[i].catName??""),
          labelStyle: TextStyle(
              color: _selectedIndex_RecipeCategory == i?colorWhite:colorBluePigment,
              fontSize: 14,
              fontFamily: fontFamilyText,
              fontWeight: fontWeight400
          ),
          backgroundColor: colorWhite,
          selected: (_selectedIndex_RecipeCategory == i),

          selectedColor: colorBluePigment,
          shape: StadiumBorder(side: BorderSide(color: colorBluePigment)),
          onSelected: (bool value) {
            setState(() {
              if(i==_selectedIndex_RecipeCategory){
                _selectedIndex_RecipeCategory = null;
                _selectedRecipeCategory = null;

                recipeModel.selectedcategory_id('0');

                recipeModel.getRecipeData(context,txt_search.text.toString(),recipeModel.fav_filter,recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
              }
              else{
                _selectedIndex_RecipeCategory = i;
                _selectedRecipeCategory = recipecategory_list[i].catId;

                recipeModel.selectedcategory_id(_selectedRecipeCategory.toString());
                recipeModel.getRecipeData(context,txt_search.text.toString(),recipeModel.fav_filter,recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
              }
              print(_selectedIndex_RecipeCategory);
              print(_selectedRecipeCategory);
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);
    recipeModel.getRecipeData1(context,txt_search.text.toString(),recipeModel.fav_filter,recipeModel.select_cat_id,'0',recipeModel.selected_filter);
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    mealsModel.get_meals_plantypelist_api();
  }

  @override
  Widget build(BuildContext context) {
    final recipeModel = Provider.of<RecipeData_Provider>(context);
    return Scaffold(

      backgroundColor: colorWhite,
      appBar: _appbar(recipeModel:recipeModel),
      body: recipeModel.loading
          ? const Center(child: CircularProgressIndicator()) : Container(

        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
             // TextButton(onPressed: (){calendar_json_fuction(_selectedDay!.month,_selectedDay!.day,[{"rec_id":"4","cat_id":"2","note":"","logged":"1"}]);},
             //   child: Text("button")),

              Container(
                height: 50,
                width: deviceWidth(context),
                padding:  EdgeInsets.only(left: 15,right: 15),
                color: colorWhite,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    if (recipeModel.selectedCollectionIDName == '0') seach_field() else Container(
                      width: deviceWidth(context,0.92),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(recipeModel.selectedCollectionIDName??"",
                          style: TextStyle(fontSize: 24,
                              color: colorRichblack,
                              fontFamily: fontFamilyText,fontWeight: fontWeight700),),
                      ),
                    ),
                    textfieldfocus? TextButton(onPressed: (){

                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {

                        currentFocus.unfocus();
                        clear_icon = false;
                        if(search_done){
                          recipeModel.getRecipeData(context,'',recipeModel.fav_filter,recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
                          txt_search.clear();
                        }
                        txt_search.clear();

                      }
                      // Navigator.pop(context);
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
              // searchbar_container(),

              recipeModel.selectedCollectionIDName == '0'? Container(
                color: colorWhite,
                padding:  EdgeInsets.only(left: 15,right: 15),
                height: 55,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: choiceChips_RecipeCategory(recipecategory_list:recipeModel.recipecategory_list_data!,recipeModel:recipeModel),
                ),
              ):Container(),
              sizedboxheight(5.0),
              recipes_itam_listview(),
              // sizedboxheight(50.0),
            ],
          ),
        ),
      )
    );
  }
   /// appbar ///////////////////

  AppBar _appbar({required RecipeData_Provider recipeModel}){
    return AppBar(
      elevation: 0,
      leading: recipeModel.fav_filter=='0'?IconButton(
        onPressed: (){
         // fav_filter = "1";
          recipeModel.selectedfav_filter("1");
          recipeModel.selectedCollectionIDFunction('0');
          recipeModel.selectedCollectionIDNameFunction('0');
          recipeModel.getRecipeData(context,txt_search.text.toString(),recipeModel.fav_filter,recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
        },
        icon: SvgPicture.asset('assets/image/heart.svg',width: 18,height: 18,
          color: HexColor('#131A29'),),
      ):IconButton(
        onPressed: (){
         // fav_filter = "0";
          recipeModel.selectedfav_filter("0");
          recipeModel.getRecipeData(context,txt_search.text.toString(),'0',recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
        },
        icon: SvgPicture.asset('assets/image/dark_heart.svg',width: 18,height: 18,
          ),
      ),
      centerTitle: true,
      title: Text('Recipes',
        style: TextStyle(
            fontSize: 30,
            fontFamily: 'Playfair Display',
            color: colorPrimaryColor,
            fontWeight: fontWeight500,
            overflow: TextOverflow.ellipsis
        ),),

      actions: [
        recipeModel.selectedCollectionIDName == '0'? Padding(
          padding: const EdgeInsets.only(right: 2.0,top: 5),
          child: InkWell(
            onTap: (){
              print('selected_filter.length');
              print(recipeModel.selected_filter.length);
              print(recipeModel.filter_list_data!.filterTag!.length);
              print('selected_filter.length');
              recipeModel.updateeatingPattern_is(int.parse(recipeModel.save_eatingPattern_id));
              recipeModel.updateselectedeatingPattern_index(recipeModel.save_eatingPattern_index);
              List<FilterTag> filter = [];
              recipeModel.selectedfilter(filter);
              for(var item in recipeModel.save_filter){
                recipeModel.selected_filter.add(item);
              }
              filter_bottom_sheet(recipeModel:recipeModel);
            },
            child: Container(
              width: 72,

              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset('assets/image/filtter.svg',width: 18,height: 18,
                        color: HexColor('#131A29'),),

                    ],
                  ),
                  recipeModel.filter_count != '0'? Positioned(
                    top: 0,
                    right: 5,
                    child: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, color: colorBluePigment),
                      alignment: Alignment.center,
                      child: Padding(
                        padding:  EdgeInsets.all(6.0),
                        child: Text(recipeModel.filter_count.toString(),style: TextStyle(fontSize: 10),),
                      ),
                    ),
                  ):Container()
                ],
              ),
            ),
          ),
        ):Container(child: TextButton(onPressed: (){
          recipeModel.selectedfav_filter("0");
          recipeModel.selectedCollectionIDFunction('0');
          recipeModel.selectedCollectionIDNameFunction('0');
          recipeModel.getRecipeData(context,txt_search.text.toString(),recipeModel.fav_filter,recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
        },
            child: Text('All Recipes',
                style: TextStyle(color: colorRichblack,fontSize: 14))),)

      ],
      backgroundColor: colorWhite,
    );
  }

  /// seach_field ////////////////

  Widget seach_field() {
    final recipeModel = Provider.of<RecipeData_Provider>(context);
    return  Expanded(
      child: Focus(

        onFocusChange: (a){
          print(a.toString());
          textfieldfocus = a;
          if(a){
            clear_icon = false;
          }
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

              suffixIcon: clear_icon? InkWell(
                onTap: (){
                  if(txt_search.text.isNotEmpty){
                    clear_icon = false;
                    txt_search.clear();
                    recipeModel.getRecipeData(context,'',recipeModel.fav_filter,recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
                   // recipeModel.recipeList_ditels_api(search_test:'');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: SvgPicture.asset(
                    'assets/Close Button Light.svg',
                    height: 1,
                  ),
                ),
              ):Container(width: 1,),
              fillColor:hasFocus ? colorEnabledTextField : colorDisabledTextField,
              autofillHints: const [AutofillHints.name],
              textInputAction: TextInputAction.done,
              keyBoardType: TextInputType.text,
              validatorFieldValue: 'Search',
              onSubmitted: (val){
                setState(() {
                  print(val.length);
                  if(val.length>0){
                    clear_icon = true;
                    search_done = true;
                 // recipeModel.recipeList_ditels_api(search_test:txt_search.text.toString());
                    recipeModel.getRecipeData(context,txt_search.text.toString(),recipeModel.fav_filter,recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
                  }

                });
              },
              onChanged: (val){
                setState(() {
                  clear_icon = false;
                  print(val.length);
                  if(val.length==0){

                    if(search_done){
                      search_done = false;
                      textfieldfocus = false;
                      recipeModel.getRecipeData(context,'',recipeModel.fav_filter,recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
                    }
                  }
                });
              },

            );
          },
        ),
      ),
    );
  }

   /// recipes_itam_listview ///////////

 Widget recipes_itam_listview(){
   final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);

  final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
  return Container(
      height: deviceheight(context),
      width: deviceWidth(context),
      color: HexColor('#F6F7FB'),
      padding: EdgeInsets.all(15),
      child:  recipeModel.recipe_data_List!.isEmpty?SizedBox(
        width: deviceWidth(context),
        height: deviceheight(context,0.4),

        child: Align(
            alignment: Alignment.topCenter,
            child: recipeModel.fav_filter=='1'?
             Text('You have not added any recipes to your favourites list yet. '
                'Simply tap the ‘heart’ on a recipe to add it to this list!',
              style: TextStyle(fontFamily: fontFamilyText ,fontSize: 16),
              textAlign: TextAlign.center,
            ): Text('No Recipe Found', style: TextStyle(fontFamily: fontFamilyText ,fontSize: 16),
          textAlign: TextAlign.center,)).paddingOnly(left: 20,right: 20),) :

      recipeModel.isFirstLoadRunning
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Column(
            children: [
              Container(
                height:Platform.isAndroid ?deviceheight(context,0.7):deviceheight(context,0.62),
                width: deviceWidth(context),
                color: HexColor('#F6F7FB'),

                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: recipeModel.controller,
                  scrollDirection: Axis.vertical,
                  itemCount: (recipeModel.recipe_data_List!.length % 2 == 0 ? recipeModel.recipe_data_List!.length ~/ 2 : recipeModel.recipe_data_List!.length ~/ 2 + 1),
                  // itemCount: recipe_data_List!.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              // color: Colors.green,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            margin:  EdgeInsets.all(1.0),
                            width: deviceWidth(context,0.44),
                            child:  Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                      context,
                                      settings: const RouteSettings(name: "/Recipes_Screen"),
                                      screen:  Recipes_Description_Screen(rec_id:recipeModel.recipe_data_List![index * 2].recId,rec_index:index * 2,txt_search:txt_search.text.toString(),fav_filter:recipeModel.fav_filter),
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
                                            child: Image.network(recipeModel.recipe_data_List![index * 2].image??"https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=",
                                              height: 110,width: deviceWidth(context),fit: BoxFit.cover,
                                              errorBuilder: (context, url, error) => Image.network("https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=", width:deviceWidth(context,0.4) ,
                                                height: 110,
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
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: InkWell(
                                            onTap: (){
                                              setState(() {
                                                if(recipeModel.recipe_data_List![index * 2].favStatus == 0){
                                                  recipeModel.recipe_data_List![index * 2].favStatus = 1;
                                                  recipeModel.likeRecipeData1(context,recipeModel.recipe_data_List![index * 2].recId);
                                                }
                                                else if(recipeModel.recipe_data_List![index * 2].favStatus == 1){
                                                  recipeModel.recipe_data_List![index * 2].favStatus = 0;
                                                  recipeModel.unlikeRecipeData1(context,recipeModel.recipe_data_List![index * 2].recId,txt_search.text.toString(),recipeModel.fav_filter);
                                                  if(recipeModel.fav_filter =='1'){
                                                    recipeModel.getRecipeData(context,txt_search.text.toString(),recipeModel.fav_filter,recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
                                                  }
                                                }
                                              });
                                            },
                                            child: Container(
                                              height: 40,width: 40,
                                              alignment: Alignment.topRight,
                                              child:recipeModel.recipe_data_List![index * 2].favStatus == 1?Center(child: SvgPicture.asset('assets/image/Heart_lick.svg')): Center(child: SvgPicture.asset('assets/image/Heart_unlick.svg')),
                                            ),
                                          ),
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
                                      screen:  Recipes_Description_Screen(rec_id:recipeModel.recipe_data_List![index * 2].recId,rec_index:index * 2,txt_search:txt_search.text.toString(),fav_filter:recipeModel.fav_filter),
                                    );
                                  },
                                  child: Text(recipeModel.recipe_data_List![index * 2].recTitle??"",style:TextStyle(
                                    fontSize: 16,
                                    fontFamily: fontFamilyText,
                                    color: HexColor('#3B4250'),
                                    fontWeight: fontWeight600,
                                    height: 1.3,
                                    overflow: TextOverflow.ellipsis,
                                  ) ,maxLines: 2,),
                                ),
                                sizedboxheight(5.0),
                                InkWell(
                                  onTap: (){
                                    if(recipeModel.meals_screen){
                                      print(recipeModel.select_mealplanID_recipe.toString());

                                    }else{
                                      mealsModel.singleDayMeals_change(false);
                                      recipeModel.selectedDay_data(DateTime.now());
                                      recipeModel.selectedDate_string(null);
                                      recipeModel.meal_plan_id_select_fuction_recipe(null);
                                    }
                                    add_meals_bottom_sheet(recipeModel.recipe_data_List!,(index * 2));
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        if (index * 2 +1 < recipeModel.recipe_data_List!.length)

                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                // color: Colors.green,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              margin:  EdgeInsets.all(1.0),
                              width: deviceWidth(context,0.44),
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                        context,
                                        settings: const RouteSettings(name: "/Recipes_Screen"),
                                        screen:  Recipes_Description_Screen(rec_id:recipeModel.recipe_data_List![index * 2 + 1].recId,rec_index:index * 2+1,txt_search:txt_search.text.toString(),fav_filter:recipeModel.fav_filter),
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
                                              child: Image.network(recipeModel.recipe_data_List![index * 2 + 1].image??"https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=",
                                                height: 110,width: deviceWidth(context),fit: BoxFit.cover,
                                                errorBuilder: (context, url, error) => Image.network("https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=", width:deviceWidth(context,0.4) ,
                                                  height: 110,
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
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                              onTap: (){
                                                // setState(() {
                                                //   print('recipe_ditels_data!.favStatus.toString()');
                                                //   print(recipeModel.recipe_data_List![index * 2+1].favStatus.toString());
                                                //   print('recipe_ditels_data!.favStatus.toString()');
                                                //   if(recipeModel.recipe_data_List![index * 2+1].favStatus == 0){
                                                //     recipeModel.recipe_data_List![index * 2+1].favStatus = 1;
                                                //     recipeModel.recipe_like_api(recipeModel.recipe_data_List![index * 2+1].recId);
                                                //   }
                                                //   else if(recipeModel.recipe_data_List![index * 2+1].favStatus == 1){
                                                //     recipeModel.recipe_data_List![index * 2+1].favStatus = 0;
                                                //     recipeModel.recipe_unlike_api(recipeModel.recipe_data_List![index * 2+1].recId);
                                                //   }
                                                //
                                                // });
                                                setState(() {
                                                  if(recipeModel.recipe_data_List![index * 2+1].favStatus == 0){
                                                    recipeModel.recipe_data_List![index * 2+1].favStatus = 1;
                                                    recipeModel.likeRecipeData1(context,recipeModel.recipe_data_List![index * 2+1].recId);
                                                  }
                                                  else if(recipeModel.recipe_data_List![index * 2+1].favStatus == 1){
                                                    recipeModel.recipe_data_List![index * 2+1].favStatus = 0;
                                                    recipeModel.unlikeRecipeData1(context,recipeModel.recipe_data_List![index * 2+1].recId,txt_search.text.toString(),recipeModel.fav_filter);
                                                    if(recipeModel.fav_filter =='1'){
                                                      recipeModel.getRecipeData(context,txt_search.text.toString(),recipeModel.fav_filter,recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
                                                    }
                                                  }
                                                });
                                              },
                                              child: Container(
                                                height: 40,width: 40,

                                                alignment: Alignment.topRight,

                                                child:recipeModel.recipe_data_List![index * 2+1].favStatus == 1?Center(child: SvgPicture.asset('assets/image/Heart_lick.svg')): Center(child: SvgPicture.asset('assets/image/Heart_unlick.svg')),
                                              ),
                                            ),
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
                                        screen:  Recipes_Description_Screen(rec_id:recipeModel.recipe_data_List![index * 2 + 1].recId,rec_index:index * 2+1,txt_search:txt_search.text.toString(),fav_filter:recipeModel.fav_filter),
                                      );
                                    },
                                    child: Text(recipeModel.recipe_data_List![index * 2 + 1].recTitle??"",style:TextStyle(
                                        fontSize: 16,
                                        fontFamily: fontFamilyText,
                                        color: HexColor('#3B4250'),
                                        fontWeight: fontWeight600,
                                        height: 1.3,
                                        overflow: TextOverflow.ellipsis
                                    ) ,maxLines: 2,),
                                  ),
                                  sizedboxheight(5.0),
                                  InkWell(
                                    onTap: (){
                                      if(recipeModel.meals_screen){
                                        print(recipeModel.select_mealplanID_recipe.toString());
                                      }else{
                                        mealsModel.singleDayMeals_change(false);
                                        recipeModel.selectedDay_data(DateTime.now());
                                        recipeModel.selectedDate_string(null);
                                        recipeModel.meal_plan_id_select_fuction_recipe(null);
                                      }
                                      add_meals_bottom_sheet(recipeModel.recipe_data_List!,(index * 2+1));
                                    },
                                    child: Row(
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
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                      ],
                    );
                  },
                ),
              ),
              if (recipeModel.isLoadMoreRunning == true)
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 40),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              // When nothing else to load
              if (recipeModel.hasNextPage == false)
                Container(
                  padding: const EdgeInsets.only(top: 30, bottom: 40),
                  color: Colors.amber,
                  child: const Center(
                    child: Text('End of list'),
                  ),
                ),
            ],
          ),);
}

  /// filter bottom sheet //////////////////////

 Future<void> filter_bottom_sheet({required RecipeData_Provider recipeModel}){
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
              return Container(
                height: deviceheight(context,0.8),
                child: Stack(
                  children: [
                    Container(
                      height: deviceheight(context,0.8),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0,right: 15,top: 15,bottom: 120),
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                width: deviceWidth(context),
                                height: 60,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: deviceWidth(context),
                                      height: 60,
                                      child: Center(
                                        child: Text('Filter',style:TextStyle(
                                            fontSize: 24,
                                            fontFamily: fontFamilyText,
                                            color: colorRichblack,
                                            fontWeight: fontWeight600,
                                            height: 1.5,
                                            overflow: TextOverflow.ellipsis
                                        )),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(onPressed: (){
                                       Navigator.pop(context);
                                      },
                                          icon: Icon(Icons.close,color: colorRichblack,)),
                                    ),
                                  ],
                                ),
                              ),
                              sizedboxheight(deviceheight(context,0.02),),

                              Text('Eating pattern',style:TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontFamilyText,
                                  color: colorBlack,
                                  fontWeight: fontWeight600,

                                  overflow: TextOverflow.ellipsis
                              )),
                              sizedboxheight(3.0),
                              // Text(recipeModel.selectedeatingPattern == null?'Can only select one option at a time.':
                              // recipeModel.filter_list_data!.eatingPattern![int.parse(recipeModel.selectedeatingPattern.toString())-1].eatName??"",style:TextStyle(
                              //     fontSize: 12,
                              //     fontFamily: fontFamilyText,
                              //     color: colorgrey,
                              //     fontWeight: fontWeight400,
                              //     height: 1.2,
                              //     overflow: TextOverflow.ellipsis
                              // )),
                              Text('Can only select one option at a time.',style:TextStyle(
                                  fontSize: 12,
                                  fontFamily: fontFamilyText,
                                  color: colorgrey,
                                  fontWeight: fontWeight400,
                                  height: 1.2,
                                  overflow: TextOverflow.ellipsis
                              )),
                              sizedboxheight(10.0),
                              Container(
                                color: colorWhite,
                                child: MyBottomSheetWidget(),
                              ),

                              sizedboxheight(deviceheight(context,0.025),),
                              Text('More filters',style:TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontFamilyText,
                                  color: colorBlack,
                                  fontWeight: fontWeight600,
                                  height: 1.5,
                                  overflow: TextOverflow.ellipsis
                              )),
                              sizedboxheight(3.0),
                              Text('Multiple selection possible.',style:TextStyle(
                                  fontSize: 12,
                                  fontFamily: fontFamilyText,
                                  color: colorgrey,
                                  fontWeight: fontWeight400,
                                  height: 1.2,
                                  overflow: TextOverflow.ellipsis
                              )),
                              sizedboxheight(10.0),
                              Container(
                                color: colorWhite,
                                child: MultiSelectChip(

                                    items: recipeModel.filter_list_data!.filterTag!.map((item) => item).toList(),
                                    selectedItems: recipeModel.selected_filter,
                                    saveItems:recipeModel.save_filter,
                                    usetime: false,
                                    onSelectionChanged: (selectedItems) {

                                      recipeModel.selectedfilter(selectedItems);
                                        (context as Element).reassemble();

                                    },
                                    listtype: true,
                                    titlefont:14.0
                                ),
                              ),

                              sizedboxheight(deviceheight(context,0.025),),

                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      child: Container(
                        height: 60,
                        width: deviceWidth(context),
                        child:
                       // recipeModel.selected_filter.length==0&&recipeModel.selectedeatingPattern==null?Container():
                        Container(
                          height: 60,
                          width: deviceWidth(context),
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              clear_Btn(context,recipeModel:recipeModel),
                              apply_Btn(context,recipeModel:recipeModel),
                            ],
                          ),
                        ),

                      ),
                    )
                  ],
                ),
              );
            }
          );
        });
}

  /// clear_Btn //////////////////

  Widget clear_Btn(context, {required RecipeData_Provider recipeModel}) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Clear filters',
        textColor: colorBluePigment,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context,0.45),
        btnHeight: 45,
        btnfontsize: 20,
        btnfontweight: fontWeight400,
        btnColor: colorWhite,
        borderColor: colorBluePigment,
        onPressed: () {
         // (context as Element).reassemble();
          recipeModel.updateeatingPattern_is(null);
          recipeModel.updateselectedeatingPattern_index(null);

          recipeModel.selectedfiltercount('0');
          recipeModel.selected_filter.clear();
          recipeModel.save_filter.clear();
          recipeModel.save_select_eatingPattern_id("0");
          recipeModel.save_select_eatingPattern_index(null);

          recipeModel.getRecipeData(context,txt_search.text.toString(),recipeModel.fav_filter,recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
           // Get.to(() => Pre_Question_Screen());
          Navigator.pop(context);
          (context as Element).reassemble();
        },
      ),
    );
  }

   /// apply_Btn /////////////

  Widget apply_Btn(context, {required RecipeData_Provider recipeModel}) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Apply',
        textColor: colorWhite,
        btnHeight: 45,
        btnfontsize: 20,
        btnfontweight: fontWeight400,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context,0.45),
        btnColor: colorEnabledButton,
        onPressed: () {
        (context as Element).reassemble();
        recipeModel.save_filter.clear();
        for(var item in recipeModel.selected_filter){
          recipeModel.save_filter.add(item);
        }

        recipeModel.save_select_eatingPattern_id(recipeModel.selectedeatingPattern_id != null?recipeModel.selectedeatingPattern_id.toString():"0");
        recipeModel.save_select_eatingPattern_index(recipeModel.selectedIndex_eatingPattern_index != null?recipeModel.selectedIndex_eatingPattern_index:null);

        recipeModel.getRecipeData(context,txt_search.text.toString(),recipeModel.fav_filter,recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);

        recipeModel.selectedfiltercount('0');
        if(recipeModel.save_eatingPattern_id != "0"){
          var a = int.parse(recipeModel.filter_count.toString())+1;
          recipeModel.selectedfiltercount(a.toString());
        }else{
          recipeModel.selectedfiltercount('0');
        }

         if(recipeModel.selected_filter.isNotEmpty){
          var a = int.parse(recipeModel.filter_count.toString())+1;
          recipeModel.selectedfiltercount(a.toString());
        }
        Navigator.pop(context);
       // (context as Element).reassemble();
        },
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
                      // calendar_listview? Container(
                      //   child: Column(
                      //     children: [
                      //        Text('Select Month',style: TextStyle(
                      //           color: colorBluePigment,
                      //           fontSize: 18,
                      //           fontFamily: fontFamilyText,
                      //           fontWeight: fontWeight400
                      //       ),),
                      //       sizedboxheight(10.0),
                      //       Wrap(
                      //         spacing: 5.0,
                      //         runSpacing: 0.0,
                      //        // children: _buildChoiceList(),
                      //         children: _monthNames
                      //             .asMap()
                      //             .entries
                      //             .map((entry) => ChoiceChip(
                      //           label: Text(_monthNames[entry.key]),
                      //           labelStyle: TextStyle(
                      //               color: selectedChoiceIndex == entry.key?colorWhite:colorBluePigment,
                      //               fontSize: 14,
                      //               fontFamily: fontFamilyText,
                      //               fontWeight: fontWeight400
                      //           ),
                      //           selected: selectedChoiceIndex == entry.key,
                      //           selectedColor: colorBluePigment,
                      //           shape: StadiumBorder(side: BorderSide(color: colorBluePigment)),
                      //           backgroundColor: colorWhite,
                      //           onSelected: (bool isSelected) {
                      //             setState(() {
                      //               selectedChoiceIndex = isSelected ? entry.key : -1;
                      //               calendar_listview = false;
                      //               (context as Element).reassemble();
                      //             });
                      //           },
                      //         ))
                      //             .toList(),
                      //       ),
                      //     ],
                      //   ),
                      // ).paddingAll(10.0):
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

  Future<void> add_meals_bottom_sheet(recipe_data_List,index){
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
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0,right: 15,top: 15,bottom: 70),
                          child: SingleChildScrollView(
                            physics: const ScrollPhysics(),
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

                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image: NetworkImage(recipe_data_List[index].image??"https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE="),fit: BoxFit.fill
                                    )
                                  ),

                                ),
                                sizedboxheight(deviceheight(context,0.01),),
                                Text(recipe_data_List[index].recTitle??"",style:TextStyle(
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
                                add_mymeals_Btn(recipe_data_List[index].recId??""),
                                sizedboxheight(deviceheight(context,0.01),),
                              ],
                            ),
                          ),
                        ),

                      ],
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


         if(mealsModel.single_day_meals_change!){
           Navigator.pop(context);
           change_meals_fuction(context,
               mealsModel.single_day_data!.mlpYear.toString(),
               mealsModel.single_day_data!.mlpMonth.toString(),
               mealsModel.single_day_data!.date.toString(),
               mealsModel.single_day_data!.mealData![mealsModel.single_day_index!].recId.toString(),
               mealsModel.single_day_data!.mealData![mealsModel.single_day_index!].mtId.toString(),
               int.parse(mealsModel.select_mealplanID.toString())-1,

               recipeModel.selectedDay.year.toString(),
               recipeModel.selectedDay.month.toString(),
               recipeModel.selectedDay.day.toString(),
               [{"rec_id":rec_id.toString(),"mt_id":recipeModel.select_mealplanID_recipe.toString(),"note":mealsModel.select_tab_data_list![mealsModel.single_day_recipe_index!].note.toString(),"logged":mealsModel.select_tab_data_list![mealsModel.single_day_recipe_index!].logged.toString()}]
           );
         }
         else{
           if(recipeModel.selectedDay != null){
             if(recipeModel.select_mealplanID_recipe!=null){
               if(rec_id!=null){
                 Navigator.pop(context);
                 json_add_api_data_calendar_json_fuction(context,recipeModel.selectedDay.year.toString(),recipeModel.selectedDay.month.toString(),recipeModel.selectedDay.day.toString(),[{"rec_id":rec_id.toString(),"mt_id":recipeModel.select_mealplanID_recipe.toString(),"note":"","logged":"0"}],int.parse(recipeModel.select_mealplanID_recipe.toString())-1);
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
         }
         if(recipeModel.meals_screen){
           Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(2);
         }

         recipeModel.select_screen_data(false);
         mealsModel.singleDayMeals_change(false);
         mealsModel.get_meals_calendardata_api(context, recipeModel.selectedDay.year.toString(),recipeModel.selectedDay.month.toString(),int.parse(recipeModel.select_mealplanID_recipe.toString())-1,"0",recipeModel.selectedDay);
        },
      ),
    );
  }
}
