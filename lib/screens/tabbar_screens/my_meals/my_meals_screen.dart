import 'dart:collection';
import 'dart:io';

import 'package:aylahealth/screens/tabbar_screens/my_meals/shopping_list_screen/ShoppingListScreen.dart';
import 'package:custom_cupertino_picker/custom_cupertino_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../common/commonwidgets/button.dart';
import '../../../common/formtextfield/mytextfield.dart';
import '../../../common/new_bottombar_screen/Bottom_NavBar_Provider.dart';
import '../../../common/styles/Fluttertoast_internet.dart';
import '../../../common/styles/const.dart';
import '../recipes screens/recipe_description/recipes_description_screen.dart';
import '../recipes screens/recipe_screen/RecipeData_Provider.dart';
import 'My_Meals_Provider.dart';
import 'SelectableContainer.dart';
import 'calendar_evryday_json.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class MyMealsScreen extends StatefulWidget {
  const MyMealsScreen({Key? key}) : super(key: key);

  @override
  State<MyMealsScreen> createState() => _MyMealsScreenState();
}

class _MyMealsScreenState extends State<MyMealsScreen>  with WidgetsBindingObserver, TickerProviderStateMixin {
  AppLifecycleState? _appLifecycleState;

  bool selectButton = false;

  TextEditingController txt_search = TextEditingController();

   DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
   DateTime yesterday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
   DateTime tomorrow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

  TabController? _controller;


  /// initState ///
  @override
  void initState() {
     print('App is in the');
    _listenForKeyboardEvents();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    daytype_check();

    mealsModel.meal_plan_id_select_fuction(mealsModel.get_meals_planlist_data![0].mtId.toString());
    _controller = TabController(vsync: this, length:mealsModel.get_meals_planlist_data!.length,initialIndex: 0);
    mealsModel.get_meals_calendardata_api(context, mealsModel.selectedDay!.year,mealsModel.selectedDay!.month,0,"1",mealsModel.selectedDay);
    mealsModel.get_meals_calendardata_multiple_months_api(context,mealsModel.selectedDay,0);
    mealsModel.singal_day_data_gate_api(mealsModel.selectedDay!,true,0);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  int? backgroundDateTime =0;
  int? foregroundDateTime =0;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appLifecycleState = state;
    });

    if (state == AppLifecycleState.resumed) {
      // App is in the foreground
      print('App is in the foreground');
      foregroundDateTime = DateTime.now().year+DateTime.now().month+DateTime.now().day;
      if(backgroundDateTime != foregroundDateTime){
        toDayDataFunction();
      }
      print(foregroundDateTime.toString());
    } else if (state == AppLifecycleState.paused) {
      // App is in the background
      print('App is in the background');
      backgroundDateTime = DateTime.now().year+DateTime.now().month+DateTime.now().day;
      print(backgroundDateTime.toString());

    }
  }

   Future<void> toDayDataFunction() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     setState(() {
       bool todayValue = prefs.getBool('Home_Screen')!;
       if(todayValue){
         prefs.setBool('Home_Screen', false);
         final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

         setState(() {
           mealsModel.singlecalendarstartdate_set(DateTime.now());
           mealsModel.singlecalendar_selectedDay(DateTime.now());
           final aDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
           today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

           if(aDate == today) {
             mealsModel.userSelectDay_set('Today');
             today_check = today;
           }

           mealsModel.singal_day_data_gate_api(DateTime.now(),true,0);

           //  _selectedDay = selectedDay;
           mealsModel.select_tab_data_list!.clear();
           mealsModel.boolDataList.clear();
           for(var item in mealsModel.mealData!){

             if(int.parse(item.mtId.toString()) == mealsModel.get_meals_planlist_data![0].mtId){
               setState(() {
                 mealsModel.boolDataList.add(false);
                 mealsModel.select_tab_data_list!.add(item);
               });

             }
           }
           _controller = TabController(vsync: this, length:mealsModel.get_meals_planlist_data!.length,initialIndex: 0);
           mealsModel.selecttab_fuction(0);
           mealsModel.meal_plan_id_select_fuction(mealsModel.get_meals_planlist_data![0].mtId.toString());
           mealsModel.get_meals_calendardata_multiple_months_api(context,DateTime.now(),0);
         });

         mealsModel.multiple_calender_selected(DateTime.now());
         mealsModel.singlecalendar_focuseday(DateTime.now());

       }
     });
   }

  /// day type check ///
  DateTime? today_check;
  void daytype_check(){
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

    final DateTime aDate = DateTime(mealsModel.selectedDay!.year, mealsModel.selectedDay!.month, mealsModel.selectedDay!.day);
    if(aDate == today) {
      mealsModel.userSelectDay_set('Today');
      today_check = today;
    } else if(aDate == yesterday) {
      today_check = yesterday;
      mealsModel.userSelectDay_set('Yesterday');
    } else if(aDate == tomorrow) {
      today_check = tomorrow;
      mealsModel.userSelectDay_set('Tomorrow');
    } else{
      today_check = mealsModel.selectedDay;
      mealsModel.userSelectDay_set(DateFormat('EEEE d MMMM').format(mealsModel.selectedDay!).toString());
    }
  }


  List<Event> _getEventsForDay(DateTime day) {
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

    final kEvents = LinkedHashMap<DateTime, List<Event>>(
        equals: isSameDay,
        hashCode: getHashCode,
    )..addAll(mealsModel.kEventSource!);

    return kEvents[day] ?? [];
  }
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }
  /// Key Board Height Function ///
  double _keyboardHeight = 0;
  void _listenForKeyboardEvents() {
    KeyboardVisibilityController().onChange.listen((bool visible) {
      if (visible) {
        setState(() {
          _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        });
      } else {
        setState(() {
          _keyboardHeight = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mealsModel = Provider.of<MyMeals_Provider>(context);
    toDayDataFunction();
    return  DefaultTabController(
      length: mealsModel.get_meals_planlist_data!.length,
      child: Scaffold(
        backgroundColor: colorWhite,
        /// appBar ///
        appBar: _appbar(mealsModel),
        body:
        /// all Months calendar ///
        mealsModel.calendar_listview?all_months_calendar():
        mealsModel.loading1
            ? Container(
          child: const Center(child: CircularProgressIndicator()),
        ): Container(
          height: deviceheight(context),
          width: deviceWidth(context),
          padding: const EdgeInsets.only(bottom: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// single month calendar deader
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        if(mealsModel.notes){
                          setState(() {

                            mealsModel.listviewCalendar_hideShow(true);
                            mealsModel.selectDate(DateTime.now());
                            mealsModel.listviwe_months_set(12);
                            mealsModel.listviwe_controller(ScrollController());
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              // Calculate the initial scroll offset to center the list
                              double itemHeight = 350.0; // Set the height of each list item
                              int initialIndex = mealsModel.selectedDay!.month; // Set the index of the item you want to center on
                              double initialOffset = (initialIndex * itemHeight) -
                                  (MediaQuery.of(context).size.height / 2) +
                                  (itemHeight / 2);
                              mealsModel.scrollController!.jumpTo(initialOffset);
                            });

                          });
                        }
                        else{
                          warning_popup();
                        }

                      },
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_ios_new,color: colorBluePigment,size: 15,),
                          sizedboxwidth(5.0),
                          Text(DateFormat('MMMM').format(mealsModel.focusedDay!).toString(),
                          style: TextStyle(
                            color: colorBluePigment,
                            fontSize: 16,
                            fontWeight: fontWeight400,
                            fontFamily: fontFamilyText,
                          ),)
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        if(mealsModel.notes){
                          if(today_check!=today){
                            setState(() {
                              mealsModel.singlecalendarstartdate_set(DateTime.now());
                              mealsModel.singlecalendar_selectedDay(DateTime.now());
                              final aDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                              today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

                              if(aDate == today) {
                                mealsModel.userSelectDay_set('Today');
                                today_check = today;
                              }
                             // mealsModel.singal_day_data_gate_api1(DateTime.now(),0);
                              mealsModel.singal_day_data_gate_api(DateTime.now(),true,0);

                              //  _selectedDay = selectedDay;
                              mealsModel.select_tab_data_list!.clear();
                              mealsModel.boolDataList.clear();
                              for(var item in mealsModel.mealData!){
                                print(item);
                                print(int.parse(item.mtId.toString()) == mealsModel.get_meals_planlist_data![0].mtId);
                                if(int.parse(item.mtId.toString()) == mealsModel.get_meals_planlist_data![0].mtId){
                                  setState(() {
                                    print('value6');
                                    print(item.mtId.toString());
                                    mealsModel.boolDataList.add(false);
                                    mealsModel.select_tab_data_list!.add(item);

                                    print(mealsModel.select_tab_data_list!.length.toString());
                                  });

                                }
                              }
                              _controller = TabController(vsync: this, length:mealsModel.get_meals_planlist_data!.length,initialIndex: 0);
                              mealsModel.selecttab_fuction(0);
                              mealsModel.meal_plan_id_select_fuction(mealsModel.get_meals_planlist_data![0].mtId.toString());
                              mealsModel.get_meals_calendardata_multiple_months_api(context,DateTime.now(),0);
                            });
                          }
                          mealsModel.multiple_calender_selected(DateTime.now());
                          mealsModel.singlecalendar_focuseday(DateTime.now());
                        }
                        else{
                          warning_popup();
                        }
                        selectButton = true;
                      },
                      child: Text('Today',style: TextStyle(
                        color: mealsModel.user_select_day=="Today"?colorShadowBlue:colorBluePigment,
                        fontSize: 16,
                        fontWeight: fontWeight400,
                        fontFamily: fontFamilyText,
                      )),
                    )
                  ],
                ).paddingOnly(left: 17,right: 17,bottom: 12),
                /// single month calendar
                mealsModel.loading1
                    ? Container():  single_months_calendar(),

                Text(mealsModel.user_select_day.toString(),style: TextStyle(
                    fontSize: 24,
                    fontFamily: fontFamilyText,
                    color: HexColor('#3B4250'),
                    fontWeight: fontWeight600,
                    overflow: TextOverflow.ellipsis
                ),).paddingOnly(left: 15,right: 15),
                /// tabBar ///
                tabbar_container().paddingOnly(left: 15,right: 15),
                /// tabBarView ////
                mealsModel.loading
                    ? const Center(child: CircularProgressIndicator()) :
                SizedBox(
                  height:Platform.isAndroid?deviceheight(context,0.62):deviceheight(context,0.55),
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for(int i =0;i<mealsModel.get_meals_planlist_data!.length;i++)...[
                        SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          child: Column(
                            children: [
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: mealsModel.select_tab_data_list!.length,
                                  itemBuilder: (BuildContext context,int index){
                                    // final itam = recipeModel.select_tab_data_list![index];
                                    final recipe_model = Provider.of<RecipeData_Provider>(context, listen: false);
                                    return  Container(
                                      width: deviceWidth(context),
                                      color: colorWhite,
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: SingleChildScrollView(
                                        physics: const NeverScrollableScrollPhysics(),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if(mealsModel.notes){
                                                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                                    context,
                                                    settings: const RouteSettings(name: "/Recipes_Screen"),
                                                    screen:  Recipes_Description_Screen(rec_id:mealsModel.select_tab_data_list![index].recId,rec_index:index,txt_search:txt_search.text.toString(),fav_filter:'0',screen:"meals"),
                                                  );
                                                }
                                                else{
                                                  warning_popup();
                                                }

                                              },
                                              child: Container(
                                                height:deviceheight(context,0.22),
                                                width: deviceWidth(context),
                                                color: colorWhite,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      height: deviceheight(context,0.22),
                                                      width: deviceWidth(context),
                                                      child:ClipRRect(
                                                        borderRadius: BorderRadius.circular(5.0),
                                                        child: Image.network(mealsModel.select_tab_data_list![index].image??"https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=",fit: BoxFit.fill,
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
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: deviceheight(context,0.22),
                                                      width: deviceWidth(context),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(right: 15.0,top: 12),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [

                                                            InkWell(
                                                              onTap: (){
                                                                setState(() {
                                                                  if(mealsModel.select_tab_data_list![index].favStatus == 0){
                                                                    mealsModel.select_tab_data_list![index].favStatus = 1;
                                                                    recipe_model.likeRecipeData1(context,mealsModel.select_tab_data_list![index].recId);
                                                                  }
                                                                  else if(mealsModel.select_tab_data_list![index].favStatus == 1){
                                                                    mealsModel.select_tab_data_list![index].favStatus = 0;
                                                                    recipe_model.unlikeRecipeData1(context,mealsModel.select_tab_data_list![index].recId,'','0');
                                                                  }
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 28,width: 28,
                                                                alignment: Alignment.topRight,
                                                                child:mealsModel.select_tab_data_list![index].favStatus==1?
                                                                Center(child: SvgPicture.asset('assets/image/Heart_lick.svg',height: 26,)):
                                                                Center(child: SvgPicture.asset('assets/image/Heart_unlick.svg',height: 26,)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            sizedboxheight(10.0),
                                            Text(mealsModel.select_tab_data_list![index].recTitle??"",
                                              style:  TextStyle(
                                                fontSize: 24,
                                                fontFamily: fontFamilyText,
                                                color: colorRichblack,
                                                fontWeight: fontWeight600,
                                              ),),
                                            Container(
                                              width: deviceWidth(context),
                                              height: 40,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  /// meals remove button
                                                  remove_meals_button(index),

                                                  sizedboxwidth(10.0),
                                                  InkWell(
                                                    onTap: (){
                                                      if(mealsModel.notes){
                                                        if(mealsModel.select_tab_data_list![index].logged == '0'){
                                                          final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);
                                                          if(recipeModel.fav_filter == '1'){
                                                            recipeModel.selectedfav_filter("0");
                                                            recipeModel.getRecipeData(context,'','0',recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
                                                          }


                                                          recipeModel.meal_plan_id_select_fuction_recipe(mealsModel.select_tab_data_list![index].mtId);
                                                          recipeModel.selectedDay_data(mealsModel.selectedDay);
                                                          recipeModel.focusedDay_data(mealsModel.selectedDay);

                                                          recipeModel.selectedDate_string(DateFormat('EEEE d MMM').format(mealsModel.selectedDay!));

                                                          add_meals_bottom_sheet(mealsModel.select_tab_data_list,index);
                                                        }
                                                        else{
                                                          FlutterToast_message('Recipe Logged');
                                                        }
                                                      }
                                                      else{
                                                        warning_popup();
                                                      }


                                                    },
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset('assets/image/chenge.svg',width: 18,height: 18,color: colorShadowBlue),
                                                        sizedboxwidth(5.0),
                                                        Text('Change',style:  TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: fontFamilyText,
                                                          color: colorShadowBlue,
                                                          fontWeight: fontWeight600,
                                                        ),),

                                                      ],
                                                    ),
                                                  ),
                                                  sizedboxwidth(10.0),

                                                  /// log logged checkbox button
                                                  LogUnloggrd_checkbox(index),

                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: deviceWidth(context),
                                             // height: 80,
                                              decoration: BoxDecoration(
                                                  color: HexColor('#F5F7FB'),
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: index == mealsModel.selectedIdx?colorBluePigment:HexColor('#F5F7FB'))
                                              ),

                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text('Notes',style: TextStyle(
                                                          fontSize: 12,
                                                          color: colorRichblack,
                                                          fontFamily: fontFamilyText,
                                                          fontWeight: fontWeight400
                                                      ),),
                                                      index == mealsModel.selectedIdx?Container(height: 10):SelectableContainer(
                                                          isSelected: index == mealsModel.selectedIdx,
                                                          onTap: () {
                                                            if(mealsModel.notes){
                                                              mealsModel.handleTap(index);
                                                              mealsModel.notes_fuction(false);
                                                              mealsModel.updateItem(index,true);
                                                              txt_search.text = mealsModel.select_tab_data_list![index].note.toString();
                                                            }
                                                           else{
                                                              warning_popup();
                                                            }

                                                          }
                                                      ),

                                                    ],
                                                  ).paddingOnly(left: 10,right: 10,top: 8),
                                                  index == mealsModel.selectedIdx?AllInputDesign(
                                                    higthtextfield: 54.0,
                                                   scrollPadding: const EdgeInsets.only(bottom: 100.0),
                                                    // inputHeaderName: 'Email',
                                                    // key: Key("email1"),
                                                    textCapitalization:TextCapitalization.sentences,
                                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                                    hintText: 'Add a recipe note',
                                                    hintTextStyleColor: colorShadowBlue,
                                                    controller: txt_search,
                                                    textStyleColors:HexColor('#3B4250'),

                                                    fillColor:HexColor('#F5F7FB'),
                                                    autofillHints: const [AutofillHints.name],
                                                    textInputAction: TextInputAction.newline,
                                                    minLines: 1,
                                                    maxLines: 2,

                                                    // allow user to enter 5 line in textfield
                                                    keyboardType: TextInputType.multiline,
                                                    validatorFieldValue: 'notes',


                                                  ).paddingOnly(bottom: 1): Container(
                                                      width: deviceWidth(context),
                                                      color: HexColor('#F5F7FB'),
                                                      alignment: Alignment.topLeft,
                                                      child:ReadMoreText(
                                                        mealsModel.select_tab_data_list![index].note==""?'\nAdd a recipe note':mealsModel.select_tab_data_list![index].note??"",
                                                        trimLines: 2,

                                                        //  colorClickableText: Colors.pink,

                                                        trimMode: TrimMode.Line,
                                                        trimCollapsedText: ' read more',
                                                        trimExpandedText: ' read less',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: colorShadowBlue,
                                                            fontFamily: fontFamilyText,
                                                            fontWeight: fontWeight400
                                                        ),
                                                        lessStyle: TextStyle(
                                                            fontSize: 14,
                                                            color: colorBluePigment,
                                                            fontFamily: fontFamilyText,
                                                            fontWeight: fontWeight400
                                                        ),
                                                        moreStyle: TextStyle(
                                                            fontSize: 14,
                                                            color: colorBluePigment,
                                                            fontFamily: fontFamilyText,
                                                            fontWeight: fontWeight400,
                                                        ),
                                                      )

                                                  ).paddingOnly(left: 10,right: 10,bottom: 8)

                                                ],
                                              ),
                                            ),
                                            sizedboxheight(15.0),
                                            index == mealsModel.selectedIdx? Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                // cancelBtn(context,recipeModel,index),
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Button(
                                                    buttonName: 'Cancel',
                                                    textColor: colorWhite,
                                                    borderRadius: BorderRadius.circular(8.00),
                                                    btnWidth: deviceWidth(context,0.45),
                                                    btnColor: colorBluePigment,
                                                    btnHeight: 40,
                                                    onPressed: () {
                                                      setState(() {
                                                        mealsModel.handleTap(mealsModel.select_tab_data_list!.length+10);
                                                        mealsModel.notes_fuction(true);
                                                        mealsModel.updateItem(index,false);

                                                      });

                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Button(
                                                    buttonName: 'Save note',
                                                    textColor: colorWhite,
                                                    borderRadius: BorderRadius.circular(8.00),
                                                    btnWidth: deviceWidth(context,0.45),
                                                    btnColor: colorBluePigment,
                                                    btnHeight: 40,
                                                    onPressed: () {
                                                      setState(() {

                                                        for(int i=0;i<mealsModel.mealData!.length;i++){
                                                          if(mealsModel.mealData![i].mtId==mealsModel.select_tab_data_list![index].mtId&&mealsModel.mealData![i].recId==mealsModel.select_tab_data_list![index].recId){
                                                            mealsModel.handleTap(mealsModel.select_tab_data_list!.length+10);
                                                            mealsModel.notes_fuction(true);
                                                            mealsModel.updateItem(index,false);
                                                            update_json_create_fuction(context,
                                                                mealsModel.selectedDay!.year.toString(),
                                                                mealsModel.selectedDay!.month.toString(),
                                                                mealsModel.selectedDay!.day.toString(),
                                                                mealsModel.select_tab_data_list![index].recId.toString(),
                                                                mealsModel.select_tab_data_list![index].mtId.toString(),
                                                                mealsModel.select_tab_data_list![index].logged.toString(),
                                                                i,
                                                                txt_search.text.toString(),
                                                                int.parse(mealsModel.select_mealplanID.toString())-1
                                                            );
                                                          }
                                                        }

                                                      });

                                                    },
                                                  ),
                                                ),
                                              ],
                                            ):Container(),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                              SizedBox(height: _keyboardHeight), // Gap for keyboard

                              mealsModel.notes?(mealsModel.select_tab_data_list!.isEmpty?add_mealsbuttonBtn(context).paddingOnly(top: deviceheight(context,0.30)):add_mealsbuttonBtn(context)):Container(),
                                 sizedboxheight(100.0)
                                  // Positioned(
                                  // bottom: mealsModel.select_tab_data_list!.isEmpty?(Platform.isAndroid?deviceheight(context,0.30):deviceheight(context,0.26)): 5,
                                  // left: 0,right: 0,
                                  // child:  mealsModel.notes?add_mealsbuttonBtn(context):Container()),
                            ],
                          ),
                        ),
                      ]


                    ],
                  ),
                ).paddingOnly(left: 15,right: 15)
              ],
            ),
          ),
        ),
      ),
    );
  }
  /// appbar ///////////////////

  AppBar _appbar(mealsModel){
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text('My Meals',
        style: TextStyle(
            fontSize: 30,
            fontFamily: 'Playfair Display',
            color: colorPrimaryColor,
            fontWeight: fontWeight500,
            overflow: TextOverflow.ellipsis
        ),),

      actions: [
        IconButton(
        onPressed: (){
          if(mealsModel.notes){
            // Navigator.push(context, MaterialPageRoute(builder: (_)=>const ShoppingListScreen()));
            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
              context,
              settings: const RouteSettings(name: "/Recipes_Screen"),
              screen:  const ShoppingListScreen(),
            );
          }
          else{
            warning_popup();
          }

        },
            icon: SvgPicture.asset('assets/image/basket-shopping.svg',color: colorCharcoal,))
      ],
      backgroundColor: colorWhite,
    );
  }


  /// add meals button ///

  Widget add_mealsbuttonBtn(context) {
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Add a meal here',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor: colorBluePigment,

        onPressed: () {
        /// tab bar tab controller
        Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(3);
       /// calendar data save api

        if(recipeModel.fav_filter == '1'){
          recipeModel.selectedfav_filter("0");
          recipeModel.getRecipeData(context,'','0',recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
        }
        mealsModel.get_meals_calendardata_api(context, mealsModel.selectedDay!.year.toString(),mealsModel.selectedDay!.month.toString(),int.parse(mealsModel.select_mealplanID.toString())-1,"0", mealsModel.selectedDay);
      //  mealsModel.get_meals_calendardata_multiple_months_api(context,mealsModel.selectedDay,int.parse(mealsModel.select_mealplanID.toString())-1);
       /// select day and focused day save
        recipeModel.selectedDay_data( mealsModel.selectedDay);
        recipeModel.focusedDay_data( mealsModel.selectedDay);
        recipeModel.meal_plan_id_select_fuction_recipe(mealsModel.select_mealplanID);
       /// select meal plan id
        mealsModel.meal_plan_id_select_fuction(mealsModel.select_mealplanID);
       /// date string type save
        recipeModel.selectedDate_string(DateFormat('EEEE d MMM').format(mealsModel.selectedDay!));
       /// screen check function
        recipeModel.select_screen_data(true);
        mealsModel.singleDayMeals_change(false);
        },
      ),
    );
  }

  /// select button

  Widget selectBtn(context,mealsModel) {
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Select',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context,0.9),
        btnColor: colorBluePigment,
        onPressed: () {
          selectButton = false;
          mealsModel.singlecalendarstartdate_set(DateTime(mealsModel.selectedDays!.year,mealsModel.selectedDays!.month,mealsModel.selectedDays!.day));
          mealsModel.singlecalendar_selectedDay(DateTime(mealsModel.selectedDays!.year,mealsModel.selectedDays!.month,mealsModel.selectedDays!.day));
          mealsModel.singlecalendar_focuseday(DateTime(mealsModel.selectedDays!.year,mealsModel.selectedDays!.month,mealsModel.selectedDays!.day));
        //  mealsModel.singal_day_data_gate_api1(DateTime.now(),0);
          mealsModel.singal_day_data_gate_api(DateTime(mealsModel.selectedDays!.year,mealsModel.selectedDays!.month,mealsModel.selectedDays!.day),true,0);

          mealsModel.get_meals_calendardata_multiple_months_api(context,mealsModel.selectedDays,0);
          //  _selectedDay = selectedDay;
          mealsModel.select_tab_data_list!.clear();
          mealsModel.boolDataList.clear();
          for(var item in mealsModel.mealData!){
            print(item);
            print(int.parse(item.mtId.toString()) == mealsModel.get_meals_planlist_data![0].mtId);
            if(int.parse(item.mtId.toString()) == mealsModel.get_meals_planlist_data![0].mtId){
              print('value6');
              print(item.mtId.toString());
              mealsModel.boolDataList.add(false);
              mealsModel.select_tab_data_list!.add(item);

              print(mealsModel.select_tab_data_list!.length.toString());
            }
          }
          _controller = TabController(vsync: this, length:mealsModel.get_meals_planlist_data!.length,initialIndex: 0);
          mealsModel.selecttab_fuction(0);
          mealsModel.meal_plan_id_select_fuction(mealsModel.get_meals_planlist_data![0].mtId.toString());
           today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
           yesterday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
           tomorrow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

          final aDate = DateTime(mealsModel.selectedDays!.year,mealsModel.selectedDays!.month,mealsModel.selectedDays!.day);
          if(aDate == today) {
            mealsModel.userSelectDay_set('Today');
            today_check = today;
          } else if(aDate == yesterday) {
            today_check = yesterday;
            mealsModel.userSelectDay_set('Yesterday');
          } else if(aDate == tomorrow) {
            today_check = tomorrow;
            mealsModel.userSelectDay_set('Tomorrow');
          }
          else{
            today_check = mealsModel.selectedDay;
            mealsModel.userSelectDay_set(DateFormat('EEEE d MMMM').format(mealsModel.selectedDay!).toString());
          }
          mealsModel.listviewCalendar_hideShow(false);

        },
      ),
    );
  }


  /// all months calendar ///


  Future yearpicker(){
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          title: Text('Select Year',style:  TextStyle(
            color: colorBluePigment,
            fontSize: 20,
            fontWeight: fontWeight400,
            fontFamily: fontFamilyText,
          )),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
              return SizedBox( // Need to use container to add size constraint.
                width: 300,
                height:300,

                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: colorBluePigment, // header background color
                      onPrimary: colorWhite, // header text color
                      onSurface: colorRichblack, // body text color
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red, // button text color
                      ),
                    ),
                  ),
                  child: YearPicker(
                    currentDate:  DateTime(DateTime.now().year,1),
                    firstDate: DateTime(2023,1),
                    lastDate: DateTime(2200,1),
                    initialDate: DateTime(DateTime.now().year,1),

                    selectedDate: mealsModel.selectedDate,
                    onChanged: (DateTime dateTime) {

                      this.setState((){
                        mealsModel.selectDate(dateTime);


                        mealsModel.listviwe_months_set(12);
                        mealsModel.listviwe_controller(ScrollController());
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          // Calculate the initial scroll offset to center the list
                          double itemHeight = 350.0; // Set the height of each list item
                          int initialIndex = 0; // Set the index of the item you want to center on
                          double initialOffset = (initialIndex * itemHeight) -
                              (MediaQuery.of(context).size.height / 2) +
                              (itemHeight / 2);
                          mealsModel.scrollController!.jumpTo(initialOffset);
                        });
                        print(dateTime);
                      });

                      Navigator.pop(context);

                    },
                  ),
                ),
              );
            }
          ),
        );
      },
    );
  }

 Widget all_months_calendar(){
   final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    return Container(
      height: deviceheight(context),
      width: deviceWidth(context),
      padding: const EdgeInsets.only(bottom: 15),
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: (){
                      setState(() {
                        mealsModel.listviewCalendar_hideShow(false);
                        selectButton = false;
                      });
                    }, child: Row(
                      children: [
                        Icon(Icons.chevron_left,color: colorBluePigment,),
                        Text('Today',style:  TextStyle(
                          color: colorBluePigment,
                          fontSize: 16,
                          fontWeight: fontWeight400,
                          fontFamily: fontFamilyText,
                        ),)
                      ],
                    )),

                    TextButton(
                        onPressed: (){
                          yearpicker();
                          },
                        child: Text(mealsModel.selectedDate.year.toString(),style:  TextStyle(
                      color: colorBluePigment,
                      fontSize: 16,
                      fontWeight: fontWeight400,
                      fontFamily: fontFamilyText,
                    )))
                  ],
                ),
                Container(
                  height:Platform.isAndroid? deviceheight(context,0.8):deviceheight(context,0.7),
                  width: deviceWidth(context),

                  child: ListView.builder(
                    controller: mealsModel.scrollController,
                    itemCount: mealsModel.total_Months, // number of months to show
                    itemBuilder: (context, index) {
                    DateTime   dateNow = mealsModel.selectedDate;
                    DateTime  firstDay =DateTime(dateNow.year, index+1, 1);
                    DateTime  lastDay =DateTime(dateNow.year, dateNow.month + index+1, 0);

                      return  mealsModel.kEventSource != null?TableCalendar(
                        eventLoader:  _getEventsForDay,
                        rowHeight:48,
                        daysOfWeekHeight: 48,

                        startingDayOfWeek: StartingDayOfWeek.monday,
                        headerStyle: HeaderStyle(

                            rightChevronVisible: false,
                            titleCentered: true,
                            leftChevronVisible: false,
                            formatButtonVisible : false,
                            titleTextStyle: TextStyle(
                              color: colorRichblack,
                              fontSize: 20,
                              fontWeight: fontWeight600,
                              fontFamily: fontFamilyText,
                            )
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          decoration: BoxDecoration(

                              border: Border( bottom: BorderSide(
                                color: HexColor('#F6F8F9'),
                                width: 1,
                              ),)
                          ),
                          dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date)[0],
                          weekdayStyle: TextStyle(color: colorRichblack ,fontSize: 18, fontWeight: fontWeight600, fontFamily: fontFamilyText, ),
                          weekendStyle:TextStyle(color: colorBluePigment ,fontSize: 18, fontWeight: fontWeight600, fontFamily: fontFamilyText, ),
                        ),
                        calendarStyle: CalendarStyle(
                          markersAnchor: -0.5,

                          markerDecoration: BoxDecoration(
                            color: colorLightGray,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          outsideDaysVisible: false,

                          cellMargin: const EdgeInsets.all(8),
                          weekendTextStyle: TextStyle(color: colorBluePigment ,fontSize: 18, fontWeight: fontWeight400, fontFamily: fontFamilyText,) ,
                          defaultTextStyle:TextStyle(color: colorRichblack ,fontSize: 18, fontWeight: fontWeight400, fontFamily: fontFamilyText,) ,
                          disabledTextStyle:TextStyle(color: HexColor('#9E9E9E') ,fontSize: 18, fontWeight: fontWeight400, fontFamily: fontFamilyText,) ,
                          selectedTextStyle: TextStyle(color: colorWhite ,fontSize: 18, fontWeight: fontWeight400, fontFamily: fontFamilyText,),
                          todayTextStyle: TextStyle(color: colorBlackRichBlack ,fontSize: 18, fontWeight: fontWeight400, fontFamily: fontFamilyText,),

                          // weekendTextStyle: TextStyle(color: colorBluePigment ,fontSize: 18, fontWeight: fontWeight400, fontFamily: fontFamilyText,),
                          // selectedTextStyle: TextStyle(color: colorWhite ,fontSize: 18, fontWeight: fontWeight400, fontFamily: fontFamilyText,),
                          selectedDecoration:BoxDecoration(color: (mealsModel.selectedDays!.year == DateTime.now().year&&mealsModel.selectedDays!.month == DateTime.now().month&&mealsModel.selectedDays!.day == DateTime.now().day)?colorBluePigment:colorRichblack, shape: BoxShape.circle),
                          todayDecoration: BoxDecoration(color:HexColor('#EDEDED'), shape: BoxShape.circle),
                          // todayTextStyle: TextStyle(color: colorBlackRichBlack ,fontSize: 18, fontWeight: fontWeight400, fontFamily: fontFamilyText,)
                        ),
                        availableGestures: AvailableGestures.none,
                        selectedDayPredicate: (day) => isSameDay(mealsModel.selectedDays, day),
                        firstDay: firstDay,
                        lastDay: lastDay,
                        focusedDay: firstDay,

                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            mealsModel.multiple_calender_selected(selectedDay);
                            selectButton = true;
                            // _selectedDays = selectedDay;
                           //  recipeModel.singlecalendar_focuseday(selectedDay);
                           //  recipeModel.singlecalendar_selectedDay(selectedDay);
                           //  today_check = recipeModel.selectedDay;
                           //   recipeModel.listviewCalendar_hideShow(false);
                          });
                        },
                      ).paddingOnly(bottom: 30):
                      TableCalendar(

                        rowHeight:48,
                        daysOfWeekHeight: 48,

                        startingDayOfWeek: StartingDayOfWeek.monday,
                        headerStyle: HeaderStyle(

                            rightChevronVisible: false,
                            titleCentered: true,
                            leftChevronVisible: false,
                            formatButtonVisible : false,
                            titleTextStyle: TextStyle(
                              color: colorRichblack,
                              fontSize: 20,
                              fontWeight: fontWeight600,
                              fontFamily: fontFamilyText,
                            )
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          decoration: BoxDecoration(

                              border: Border( bottom: BorderSide(
                                color: HexColor('#F6F8F9'),
                                width: 1,
                              ),)
                          ),
                          dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date)[0],
                          weekdayStyle: TextStyle(color: colorRichblack ,fontSize: 18, fontWeight: fontWeight600, fontFamily: fontFamilyText, ),
                          weekendStyle:TextStyle(color: colorBluePigment ,fontSize: 18, fontWeight: fontWeight600, fontFamily: fontFamilyText, ),
                        ),
                        calendarStyle: CalendarStyle(
                          markersAnchor: -0.5,

                          markerDecoration: BoxDecoration(
                            color: colorLightGray,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          outsideDaysVisible: false,

                          cellMargin: const EdgeInsets.all(8),
                          weekendTextStyle: TextStyle(color: colorBluePigment ,fontSize: 18, fontWeight: fontWeight400, fontFamily: fontFamilyText,) ,
                          defaultTextStyle:TextStyle(color: colorRichblack ,fontSize: 18, fontWeight: fontWeight400, fontFamily: fontFamilyText,) ,
                          disabledTextStyle:TextStyle(color: HexColor('#9E9E9E') ,fontSize: 18, fontWeight: fontWeight400, fontFamily: fontFamilyText,) ,
                          selectedTextStyle: TextStyle(color: colorWhite ,fontSize: 18, fontWeight: fontWeight400, fontFamily: fontFamilyText,),
                          todayTextStyle: TextStyle(color: colorBlackRichBlack ,fontSize: 18, fontWeight: fontWeight400, fontFamily: fontFamilyText,),

                          // weekendTextStyle: TextStyle(color: colorBluePigment ,fontSize: 18, fontWeight: fontWeight400, fontFamily: fontFamilyText,),
                          // selectedTextStyle: TextStyle(color: colorWhite ,fontSize: 18, fontWeight: fontWeight400, fontFamily: fontFamilyText,),
                          selectedDecoration:BoxDecoration(color: (mealsModel.selectedDays!.year == DateTime.now().year&&mealsModel.selectedDays!.month == DateTime.now().month&&mealsModel.selectedDays!.day == DateTime.now().day)?colorBluePigment:colorRichblack, shape: BoxShape.circle),
                          todayDecoration: BoxDecoration(color:HexColor('#EDEDED'), shape: BoxShape.circle),
                          // todayTextStyle: TextStyle(color: colorBlackRichBlack ,fontSize: 18, fontWeight: fontWeight400, fontFamily: fontFamilyText,)
                        ),
                        availableGestures: AvailableGestures.none,
                        selectedDayPredicate: (day) => isSameDay(mealsModel.selectedDays, day),
                        firstDay: firstDay,
                        lastDay: lastDay,
                        focusedDay: firstDay,

                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            mealsModel.multiple_calender_selected(selectedDay);
                            selectButton = true;
                            // _selectedDays = selectedDay;
                            //  recipeModel.singlecalendar_focuseday(selectedDay);
                            //  recipeModel.singlecalendar_selectedDay(selectedDay);
                            //  today_check = recipeModel.selectedDay;
                            //   recipeModel.listviewCalendar_hideShow(false);
                          });
                        },
                      ).paddingOnly(bottom: 30);
                    },
                  ),
                ),
              ],
            ),
          ),
          selectButton?Positioned(
              bottom: 50,
              right: deviceWidth(context,0.055),
              left: deviceWidth(context,0.055),
              child: selectBtn(context ,mealsModel)):Container()
        ],
      ),
    );
 }

  /// single months calendar ///

  Widget single_months_calendar(){
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

    return Container(
      color: colorWhite,
      child: mealsModel.kEventSource != null?TableCalendar(
        eventLoader: _getEventsForDay,
        // firstDay: DateTime(mealsModel.singlecalendar_startdate!.year,mealsModel.singlecalendar_startdate!.month==3?mealsModel.singlecalendar_startdate!.month-2:mealsModel.singlecalendar_startdate!.month==2?mealsModel.singlecalendar_startdate!.month-1:mealsModel.singlecalendar_startdate!.month==1?mealsModel.singlecalendar_startdate!.month:mealsModel.singlecalendar_startdate!.month-2),
        // lastDay: DateTime(mealsModel.singlecalendar_startdate!.year,mealsModel.singlecalendar_startdate!.month==10?mealsModel.singlecalendar_startdate!.month+3:mealsModel.singlecalendar_startdate!.month==11?mealsModel.singlecalendar_startdate!.month+2:mealsModel.singlecalendar_startdate!.month==12?mealsModel.singlecalendar_startdate!.month+1:mealsModel.singlecalendar_startdate!.month+3,0),
        firstDay: DateTime(mealsModel.singlecalendar_startdate!.year,mealsModel.singlecalendar_startdate!.month-2),
        lastDay: DateTime(mealsModel.singlecalendar_startdate!.year,mealsModel.singlecalendar_startdate!.month+3,0),

        focusedDay: mealsModel.focusedDay!,
        startingDayOfWeek: StartingDayOfWeek.monday,
        selectedDayPredicate: (day) => isSameDay(mealsModel.selectedDay!, day),
        calendarFormat: mealsModel.calendarFormat,

        calendarStyle: CalendarStyle(
            markersAnchor: -1,
             markerSize: 6,
            markerDecoration: BoxDecoration(
              color: colorLightGray,
              borderRadius: BorderRadius.circular(8),
            ),
            canMarkersOverflow: true,
            outsideTextStyle: TextStyle(color: colorBlackRichBlack ,fontSize: 16, fontWeight: fontWeight400, fontFamily: fontFamilyText,),
            cellMargin: const EdgeInsets.all(14),
            selectedTextStyle: TextStyle(color: colorWhite ,fontSize: 16, fontWeight: fontWeight400, fontFamily: fontFamilyText,),
            selectedDecoration:BoxDecoration(color: (mealsModel.selectedDay!.year == DateTime.now().year&&mealsModel.selectedDay!.month == DateTime.now().month&&mealsModel.selectedDay!.day == DateTime.now().day)?colorBluePigment:colorBlackRichBlack, shape: BoxShape.circle),
            todayDecoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
            todayTextStyle: TextStyle(color: colorBlackRichBlack ,fontSize: 16, fontWeight: fontWeight400, fontFamily: fontFamilyText,),

        ),

        daysOfWeekVisible: true,
        headerVisible: false,


        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date)[0],
          weekdayStyle: TextStyle(color: colorShadowBlue ,fontSize: 16, fontWeight: fontWeight400, fontFamily: fontFamilyText, ),
          weekendStyle:TextStyle(color: colorShadowBlue ,fontSize: 16, fontWeight: fontWeight400, fontFamily: fontFamilyText, ),
        ),

        onPageChanged: (focusedDay) {
          setState(() {
            mealsModel.singlecalendar_focuseday(focusedDay);
          });
        },
        onDaySelected: (selectedDay, focusedDay) {
          if(mealsModel.notes){
            setState(() {
              /// single data date select
              mealsModel.singlecalendar_selectedDay(selectedDay);
              mealsModel.singlecalendar_focuseday(focusedDay);

              /// get months calendar meals api
              mealsModel.get_meals_calendardata_api(context, focusedDay.year,focusedDay.month,0,"0",focusedDay);
              //mealsModel.get_meals_calendardata_multiple_months_api(context,focusedDay,0);
              /// single day data api
             //  mealsModel.singal_day_data_gate_api1(DateTime.now(),0);
             // mealsModel.singal_day_data_gate_api(selectedDay,true,0);

              //  _selectedDay = selectedDay;
              mealsModel.select_tab_data_list!.clear();
              mealsModel.boolDataList.clear();

              /// tab controller ///
              _controller = TabController(vsync: this, length:mealsModel.get_meals_planlist_data!.length,initialIndex: 0);
              mealsModel.selecttab_fuction(0);
              mealsModel.meal_plan_id_select_fuction(mealsModel.get_meals_planlist_data![0].mtId.toString());

              /// day check ///

              today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
              yesterday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
              tomorrow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

              final aDate = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
              if(aDate == today) {
                mealsModel.userSelectDay_set('Today');
                today_check = today;
              } else if(aDate == yesterday) {
                today_check = yesterday;
                mealsModel.userSelectDay_set('Yesterday');
              } else if(aDate == tomorrow) {
                today_check = tomorrow;
                mealsModel.userSelectDay_set('Tomorrow');
              }
              else{
                today_check = mealsModel.selectedDay;
                mealsModel.userSelectDay_set(DateFormat('EEEE d MMMM').format(mealsModel.selectedDay!).toString());
              }
            });
          }
          else{
            warning_popup();
          }
        },
      ):
      TableCalendar(
        // firstDay: DateTime(mealsModel.singlecalendar_startdate!.year,mealsModel.singlecalendar_startdate!.month==3?mealsModel.singlecalendar_startdate!.month-2:mealsModel.singlecalendar_startdate!.month==2?mealsModel.singlecalendar_startdate!.month-1:mealsModel.singlecalendar_startdate!.month==1?mealsModel.singlecalendar_startdate!.month:mealsModel.singlecalendar_startdate!.month-2),
        // lastDay: DateTime(mealsModel.singlecalendar_startdate!.year,mealsModel.singlecalendar_startdate!.month==10?mealsModel.singlecalendar_startdate!.month+3:mealsModel.singlecalendar_startdate!.month==11?mealsModel.singlecalendar_startdate!.month+2:mealsModel.singlecalendar_startdate!.month==12?mealsModel.singlecalendar_startdate!.month+1:mealsModel.singlecalendar_startdate!.month+3,0),

        firstDay: DateTime(mealsModel.singlecalendar_startdate!.year,mealsModel.singlecalendar_startdate!.month-2),
        lastDay: DateTime(mealsModel.singlecalendar_startdate!.year,mealsModel.singlecalendar_startdate!.month+3),

        focusedDay: mealsModel.focusedDay!,
        startingDayOfWeek: StartingDayOfWeek.monday,
        selectedDayPredicate: (day) => isSameDay(mealsModel.selectedDay!, day),
        calendarFormat: mealsModel.calendarFormat,

        calendarStyle: CalendarStyle(

          markersAnchor: -1,

          markerDecoration: BoxDecoration(
            color: colorLightGray,
            borderRadius: BorderRadius.circular(5),
          ),
          canMarkersOverflow: true,
          outsideTextStyle: TextStyle(color: colorBlackRichBlack ,fontSize: 16, fontWeight: fontWeight400, fontFamily: fontFamilyText,),
          cellMargin: const EdgeInsets.all(14),
          selectedTextStyle: TextStyle(color: colorWhite ,fontSize: 16, fontWeight: fontWeight400, fontFamily: fontFamilyText,),
          selectedDecoration:BoxDecoration(color: (mealsModel.selectedDay!.year == DateTime.now().year&&mealsModel.selectedDay!.month == DateTime.now().month&&mealsModel.selectedDay!.day == DateTime.now().day)?colorBluePigment:colorBlackRichBlack, shape: BoxShape.circle),
          todayDecoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
          todayTextStyle: TextStyle(color: colorBlackRichBlack ,fontSize: 16, fontWeight: fontWeight400, fontFamily: fontFamilyText,),

        ),

        daysOfWeekVisible: true,
        headerVisible: false,
        // headerStyle: HeaderStyle(
        //
        //     leftChevronMargin: EdgeInsets.only(left: 0),
        //     leftChevronIcon: Icon(Icons.chevron_left,color: colorBluePigment,),
        //     rightChevronIcon: Icon(Icons.chevron_right,color: colorBluePigment,),
        //     rightChevronVisible: false,
        //     titleTextFormatter: (date, locale) => DateFormat.MMMM(locale).format(date),
        //     formatButtonVisible : false,
        //     titleTextStyle: TextStyle(
        //       color: colorBluePigment,
        //       fontSize: 16,
        //       fontWeight: fontWeight400,
        //       fontFamily: fontFamilyText,
        //     )
        // ),

        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date)[0],
          weekdayStyle: TextStyle(color: colorShadowBlue ,fontSize: 16, fontWeight: fontWeight400, fontFamily: fontFamilyText, ),
          weekendStyle:TextStyle(color: colorShadowBlue ,fontSize: 16, fontWeight: fontWeight400, fontFamily: fontFamilyText, ),
        ),

        onPageChanged: (focusedDay) {
          setState(() {
            mealsModel.singlecalendar_focuseday(focusedDay);
          });
        },
        onDaySelected: (selectedDay, focusedDay) {
          if(mealsModel.notes){
            setState(() {
              /// single data date select
              mealsModel.singlecalendar_selectedDay(selectedDay);
              mealsModel.singlecalendar_focuseday(focusedDay);

              /// get months calendar meals api
              mealsModel.get_meals_calendardata_api(context, focusedDay.year,focusedDay.month,0,"0",focusedDay);
            //  mealsModel.get_meals_calendardata_multiple_months_api(context,focusedDay,0);
              /// single day data api
            //  mealsModel.singal_day_data_gate_api1(DateTime.now(),0);
              mealsModel.singal_day_data_gate_api(selectedDay,true,0);

              //  _selectedDay = selectedDay;
              mealsModel.select_tab_data_list!.clear();
              mealsModel.boolDataList.clear();
              // for(var item in mealsModel.mealData!){
              //   print(item);
              //   print(int.parse(item.mtId.toString()) == mealsModel.get_meals_planlist_data![0].mtId);
              //   if(int.parse(item.mtId.toString()) == mealsModel.get_meals_planlist_data![0].mtId){
              //     print('value6');
              //     print(item.mtId.toString());
              //     mealsModel.boolDataList.add(false);
              //     mealsModel.select_tab_data_list!.add(item);
              //     print(mealsModel.select_tab_data_list!.length.toString());
              //   }
              // }
              /// tab controller ///
              _controller = TabController(vsync: this, length:mealsModel.get_meals_planlist_data!.length,initialIndex: 0);
              mealsModel.selecttab_fuction(0);
              mealsModel.meal_plan_id_select_fuction(mealsModel.get_meals_planlist_data![0].mtId.toString());

              /// day check ///

              today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
              yesterday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
              tomorrow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

              final aDate = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
              if(aDate == today) {
                mealsModel.userSelectDay_set('Today');
                today_check = today;
              } else if(aDate == yesterday) {
                today_check = yesterday;
                mealsModel.userSelectDay_set('Yesterday');
              } else if(aDate == tomorrow) {
                today_check = tomorrow;
                mealsModel.userSelectDay_set('Tomorrow');
              }
              else{
                today_check = mealsModel.selectedDay;
                mealsModel.userSelectDay_set(DateFormat('EEEE d MMMM').format(mealsModel.selectedDay!).toString());
              }

            });
          }
          else{
            warning_popup();
          }

        },
      ),
    );
  }

  /// tabbar calendar ///

  Widget tabbar_container(){
    final mealsModel = Provider.of<MyMeals_Provider>(context);
    return Container(
      height: 50,
      padding: const EdgeInsets.only(top: 5,bottom: 10),
     // color: colorgrey,
      child:  TabBar(
        controller:_controller,
         splashFactory: NoSplash.splashFactory,
        indicatorColor: colorBluePigment,
        indicatorSize:TabBarIndicatorSize.label ,
        indicatorWeight: 2,
        indicatorPadding:_controller!.index==mealsModel.selecttab&&mealsModel.select_tab_data_list!.isEmpty?EdgeInsets.only(right: 10): EdgeInsets.only(left: 12,right: 10),
        automaticIndicatorColorAdjustment: true,
        isScrollable: true,
        labelColor: colorCharcoal,
        labelStyle: TextStyle(
          fontSize: 16,
          fontFamily: fontFamilyText,
          color: colorCharcoal,
          fontWeight: fontWeight400,
        ),
        unselectedLabelColor: colorShadowBlue,
        unselectedLabelStyle: TextStyle(
          fontSize: 16,
          fontFamily: fontFamilyText,
          color: colorShadowBlue,
          fontWeight: fontWeight400,
        ),
        onTap: (value){
          print('value');
          print(value);
          if(mealsModel.notes){
            setState(() {
              _controller!.index = value;
              //_controller = TabController(vsync: this, length:mealsModel.get_meals_planlist_data!.length,initialIndex: value);

              mealsModel.selecttab_fuction(value);

              mealsModel.meal_plan_id_select_fuction(mealsModel.get_meals_planlist_data![value].mtId.toString());

              print(mealsModel.get_meals_planlist_data![value].mtId.toString());

              mealsModel.select_tab_data_list!.clear();
              mealsModel.boolDataList.clear();
              for(var item in mealsModel.mealData!){
                if(int.parse(item.mtId.toString()) == mealsModel.get_meals_planlist_data![value].mtId){
                  setState(() {
                    mealsModel.boolDataList.add(false);
                    mealsModel.select_tab_data_list!.add(item);

                  });

                  print(mealsModel.select_tab_data_list!.length.toString());
                }
              }
              _controller = TabController(vsync: this, length:mealsModel.get_meals_planlist_data!.length,initialIndex: value);

              //  selecttab = value;
            });
          }
          else{
            _controller!.index = mealsModel.selecttab!;
            if(value == mealsModel.selecttab){

            }else{
              warning_popup();
            }

          }




        },

        labelPadding: const EdgeInsets.only(right: 20),
        tabs:  [
          for(int i =0;i<mealsModel.get_meals_planlist_data!.length;i++)...[
            Tab(child: Row(
              mainAxisSize: MainAxisSize.min,
              children:  [
                for(int j =0;j<mealsModel.tabbarindex!.length;j++)...[
                  (mealsModel.get_meals_planlist_data![i].mtId == mealsModel.tabbarindex![j])?
                  SvgPicture.asset('assets/image/Tick.svg',width: 20,color:_controller!.index==i? colorBluePigment:colorShadowBlue) :Container(),
                ],


               // _controller!.index==i&&mealsModel.select_tab_data_list!.isNotEmpty?SvgPicture.asset('assets/image/Tick.svg',width: 20,color: colorBluePigment):Container(),
                _controller!.index==i&&mealsModel.select_tab_data_list!.isNotEmpty? sizedboxwidth(3.0):sizedboxwidth(8.0),
                Text(mealsModel.get_meals_planlist_data![i].mtName??""),
              ],
            )),

          ]

        ],
      ),
    );
  }

  Widget LogUnloggrd_checkbox(int index){
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

    return  Container(
      height: 30,
      width: 100,
      child: InkWell(
        onTap: (){
          if(mealsModel.notes){
            setState(() {
              for(int i=0;i<mealsModel.mealData!.length;i++){
                if(mealsModel.mealData![i].mtId==mealsModel.select_tab_data_list![index].mtId&&mealsModel.mealData![i].recId==mealsModel.select_tab_data_list![index].recId){
                  if(mealsModel.select_tab_data_list![index].logged == '1'){
                    mealsModel.select_tab_data_list![index].logged = '0';

                    update_json_create_fuction(context,
                        mealsModel.selectedDay!.year.toString(),
                        mealsModel.selectedDay!.month.toString(),
                        mealsModel.selectedDay!.day.toString(),
                        mealsModel.select_tab_data_list![index].recId.toString(),
                        mealsModel.select_tab_data_list![index].mtId.toString(),
                        '0',
                        i,
                        mealsModel.select_tab_data_list![index].note.toString(),
                        int.parse(mealsModel.select_mealplanID.toString())-1);
                    // remove_meals_fuction(context,recipeModel.selectedDay!.year.toString(),recipeModel.selectedDay!.month.toString(),recipeModel.selectedDay!.day.toString(),itam.recId.toString(),itam.mtId.toString(),recipeModel.selectedDay!);
                  }else if(mealsModel.select_tab_data_list![index].logged == '0'){
                    mealsModel.select_tab_data_list![index].logged = '1';

                    update_json_create_fuction(context,
                        mealsModel.selectedDay!.year.toString(),
                        mealsModel.selectedDay!.month.toString(),
                        mealsModel.selectedDay!.day.toString(),
                        mealsModel.select_tab_data_list![index].recId.toString(),
                        mealsModel.select_tab_data_list![index].mtId.toString(),
                        '1',
                        i,
                        mealsModel.select_tab_data_list![index].note.toString(),
                        int.parse(mealsModel.select_mealplanID.toString())-1
                    );
                  }
                }
              }
            });
          }
          else{
            warning_popup();
          }

        },
        child: Container(
          height: 50,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(

                  height:18,
                  width: 18,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color:Colors.white,
                      border: Border.all(color: mealsModel.select_tab_data_list![index].logged == '1'?colorBluePigment:colorShadowBlue,width: 2)
                  ),
                  child:mealsModel.select_tab_data_list![index].logged == '1'?const Center(child: Icon(Icons.done,size: 14,)):Container(),
                ),
                sizedboxwidth(deviceWidth(context,0.02)),
                Container(
                  width: 70,
                  child: Text(mealsModel.select_tab_data_list![index].logged == '1'?"Logged":"Log",
                    style:TextStyle(
                        fontSize: 16,
                        fontFamily: fontFamilyText,
                        color: mealsModel.select_tab_data_list![index].logged == '1'?colorBluePigment:colorShadowBlue,
                        fontWeight: fontWeight400,
                        overflow: TextOverflow.ellipsis
                    ),maxLines: 2,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget remove_meals_button(int index){
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);

    return InkWell(
      onTap: (){
        if(mealsModel.notes){
          if(mealsModel.select_tab_data_list![index].logged == '0'){
            showCupertinoDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return CupertinoAlertDialog(
                    title: const Text('Remove Recipe'),
                    content: const Text('Are you sure you want to remove this recipe?'),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop("Discard");
                        },

                        child:  Text('No',style: TextStyle(color: colorBluePigment ),),
                      ),
                      // The "Yes" button
                      CupertinoDialogAction(
                        onPressed: () {
                          setState(() {

                            remove_meals_fuction(context,mealsModel.selectedDay!.year.toString(),mealsModel.selectedDay!.month.toString(),mealsModel.selectedDay!.day.toString(),mealsModel.select_tab_data_list![index].recId.toString(),mealsModel.select_tab_data_list![index].mtId.toString(),mealsModel.selectedDay!,int.parse(mealsModel.select_mealplanID.toString())-1);
                            Navigator.of(context, rootNavigator: true).pop("Discard");
                            mealsModel.get_meals_calendardata_api(context, mealsModel.selectedDay!.year.toString(),mealsModel.selectedDay!.month.toString(),int.parse(recipeModel.select_mealplanID_recipe.toString())-1,"0",mealsModel.selectedDay!);

                          });
                        },
                        isDefaultAction: true,
                        isDestructiveAction: true,
                        child:  Text('Yes',style: TextStyle(color: colorBluePigment ),),
                      ),
                      // The "No" butt

                    ],
                  );
                }
            );
          }
          else{
            FlutterToast_message('Recipe Logged');
          }
        }
        else{
          warning_popup();
        }


      },
      child: Row(
        children: [
          SvgPicture.asset('assets/image/cross.svg',width: 18,height: 18,color: colorShadowBlue),
          sizedboxwidth(3.0),
          Text('Remove',style:  TextStyle(
            fontSize: 14,
            fontFamily: fontFamilyText,
            color: colorShadowBlue,
            fontWeight: fontWeight600,
          ),),
        ],
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
                                leftChevronMargin: const EdgeInsets.only(left: 1),
                                leftChevronIcon: Icon(Icons.chevron_left,color: colorSlateGray,),
                                rightChevronIcon: Icon(Icons.chevron_right,color: colorSlateGray,),
                                rightChevronVisible: true,
                                // titleTextFormatter: (date, locale) => DateFormat.MMMM(locale).format(date),
                                formatButtonVisible : false,
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
                             //    mealsModel.get_meals_calendardata_multiple_months_api(context,selectedDay,int.parse(recipeModel.select_mealplanID_recipe.toString())-1);
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

                                        decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius: BorderRadius.circular(5),
                                            image: DecorationImage(
                                                image: NetworkImage(recipe_data_List[index].image??"https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE="),fit: BoxFit.fill
                                            )
                                        ),

                                      ),
                                      sizedboxheight(deviceheight(context,0.01),),
                                      Container(
                                        width: 260,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 230,
                                              child: Text(recipe_data_List[index].recTitle??"",style:TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: fontFamilyText,
                                                  color: colorRichblack,
                                                  fontWeight: fontWeight400,
                                                  height: 1.2,
                                                  overflow: TextOverflow.ellipsis
                                              )),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.pop(context);
                                                /// tab bar tab controller
                                                Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(3);

                                                /// screen check function
                                                recipeModel.select_screen_data(true);



                                                if(recipeModel.selectedDay != null){
                                                  if(recipeModel.select_mealplanID_recipe!=null){
                                                    if(recipe_data_List[index].recId!=null){
                                                      //     json_add_api_data_calendar_json_fuction(context,recipeModel.selectedDay.year.toString(),recipeModel.selectedDay.month.toString(),recipeModel.selectedDay.day.toString(),[{"rec_id":rec_id.toString(),"mt_id":recipeModel.select_mealplanID_recipe.toString(),"note":"","logged":"0"}],int.parse(recipeModel.select_mealplanID_recipe.toString())-1);

                                                      setState(() {
                                                        for(int i=0;i<mealsModel.mealData!.length;i++){
                                                          if(mealsModel.mealData![i].mtId==mealsModel.select_tab_data_list![index].mtId&&mealsModel.mealData![i].recId==mealsModel.select_tab_data_list![index].recId){
                                                            mealsModel.singleDaySelectIndex(i);
                                                            mealsModel.singleDayRecipeSelectIndex(index);
                                                            mealsModel.singleDayMeals_change(true);
                                                            // change_meals_fuction(context,
                                                            //     mealsModel.single_day_data!.mlpYear.toString(),
                                                            //     mealsModel.single_day_data!.mlpMonth.toString(),
                                                            //     mealsModel.single_day_data!.date.toString(),
                                                            //     mealsModel.single_day_data!.mealData![i].recId.toString(),
                                                            //     mealsModel.single_day_data!.mealData![i].mtId.toString(),
                                                            //     int.parse(mealsModel.select_mealplanID.toString())-1,
                                                            //
                                                            //     recipeModel.selectedDay.year.toString(),
                                                            //     recipeModel.selectedDay.month.toString(),
                                                            //     recipeModel.selectedDay.day.toString(),
                                                            //     [{"rec_id":mealsModel.select_tab_data_list![index].recId.toString(),"mt_id":recipeModel.select_mealplanID_recipe.toString(),"note":mealsModel.select_tab_data_list![index].note.toString(),"logged":mealsModel.select_tab_data_list![index].logged.toString()}]
                                                            // );
                                                          }
                                                        }
                                                      });

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

                                              },
                                              child: Container(
                                                  width: 30,
                                                  child: SvgPicture.asset('assets/image/edit 1.svg',width: 18,height: 18,color: colorShadowBlue,)),
                                            )
                                          ],
                                        ),
                                      ),

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
                                      add_mymeals_Btn(recipe_data_List[index].recId,index),
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

  Widget add_mymeals_Btn(rec_id,int index) {
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
          Navigator.pop(context);
          print(recipeModel.selectedDay);
          print(recipeModel.selectedDay.runtimeType);
          if(recipeModel.selectedDay != null){
            if(recipeModel.select_mealplanID_recipe!=null){
              if(rec_id!=null){
           //     json_add_api_data_calendar_json_fuction(context,recipeModel.selectedDay.year.toString(),recipeModel.selectedDay.month.toString(),recipeModel.selectedDay.day.toString(),[{"rec_id":rec_id.toString(),"mt_id":recipeModel.select_mealplanID_recipe.toString(),"note":"","logged":"0"}],int.parse(recipeModel.select_mealplanID_recipe.toString())-1);

                setState(() {
                  for(int i=0;i<mealsModel.mealData!.length;i++){
                    if(mealsModel.mealData![i].mtId==mealsModel.select_tab_data_list![index].mtId&&mealsModel.mealData![i].recId==mealsModel.select_tab_data_list![index].recId){
                      change_meals_fuction(context,
                          mealsModel.single_day_data!.mlpYear.toString(),
                          mealsModel.single_day_data!.mlpMonth.toString(),
                          mealsModel.single_day_data!.date.toString(),
                          mealsModel.single_day_data!.mealData![i].recId.toString(),
                          mealsModel.single_day_data!.mealData![i].mtId.toString(),
                          int.parse(mealsModel.select_mealplanID.toString())-1,

                          recipeModel.selectedDay.year.toString(),
                          recipeModel.selectedDay.month.toString(),
                          recipeModel.selectedDay.day.toString(),
                          [{"rec_id":mealsModel.select_tab_data_list![index].recId.toString(),"mt_id":recipeModel.select_mealplanID_recipe.toString(),"note":mealsModel.select_tab_data_list![index].note.toString(),"logged":mealsModel.select_tab_data_list![index].logged.toString()}]
                      );
                    }
                  }
                });

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


          // if(recipeModel.selectedDay != null){
          //   if(recipeModel.select_mealplanID_recipe!=null){
          //     if(rec_id!=null){
          //       json_add_api_data_calendar_json_fuction(context,mealsModel.selectedDay!.year.toString(),mealsModel.selectedDay!.month.toString(),mealsModel.selectedDay!.day.toString(),[{"rec_id":mealsModel.select_tab_data_list![index].recId.toString(),"mt_id":mealsModel.select_tab_data_list![index].mtId.toString(),"note":mealsModel.select_tab_data_list![index].note.toString(),"logged":mealsModel.select_tab_data_list![index].logged.toString()}],int.parse(mealsModel.select_tab_data_list![index].recId.toString())-1);
          //
          //
          //     }
          //     else{
          //       FlutterToast_message('Add to your calendar');
          //     }
          //   }
          //   else{
          //     FlutterToast_message('Choose an eating occasion');
          //   }
          // }else{
          //   FlutterToast_message('Please select Date');
          // }
        },
      ),
    );
  }
  Future warning_popup(){
    return   showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(

            content: const Text('Please save or cancel before navigating away from the open note.'),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop("Discard");
                  FocusManager.instance.primaryFocus?.unfocus();
                },

                child:  Text('Ok',style: TextStyle(color: colorBluePigment ),),
              ),
              // The "Yes" button

              // The "No" butt

            ],
          );
        }
    );
  }
}

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

