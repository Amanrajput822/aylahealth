import "package:aylahealth/common/new_bottombar_screen/screens.dart";
import "package:aylahealth/common/styles/const.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:hexcolor/hexcolor.dart";
import "package:intl/intl.dart";
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";
import "package:provider/provider.dart";

import "../../screens/notification_screen/FirebaseNotifications.dart";
import "../../screens/notification_screen/ReceivedNotification.dart";
import "../../screens/tabbar_screens/home/home.dart";
import '../../screens/tabbar_screens/modules/modules_screen/modules_screen.dart';
import "../../screens/tabbar_screens/my_meals/My_Meals_Provider.dart";
import "../../screens/tabbar_screens/my_meals/my_meals_screen.dart";
import "../../screens/tabbar_screens/recipes screens/recipe_screen/RecipeData_Provider.dart";
import "../../screens/tabbar_screens/recipes screens/recipe_screen/recipes_screen.dart";
import "../../screens/tabbar_screens/support_screen/support_screen.dart";
import "../commonwidgets/app_close_popup.dart";
import "Bottom_NavBar_Provider.dart";

BuildContext? testContext;


// ----------------------------------------- Provided Style ----------------------------------------- //

class New_Bottombar_Screen extends StatefulWidget {
  const New_Bottombar_Screen({ Key? key})
      : super(key: key);


  @override
  _New_Bottombar_ScreenState createState() => _New_Bottombar_ScreenState();
}

class _New_Bottombar_ScreenState extends State<New_Bottombar_Screen> {
 // PersistentTabController? _controller;

  @override
  void initState() {
    super.initState();

    LocalNotification().configureDidReceiveLocalNotificationSubject(context);
    LocalNotification().configureSelectNotificationSubject();
    FirebaseNotifications().firebaseInitialization();
    // LocalNotification().initialize();

    final BottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context, listen: false);
    BottomNavBarProviderModel.setcontrollervalue(0);
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    mealsModel.get_meals_plantypelist_api();

  }
  /// recipe screen list  ////
  void recipe_screen_tap() {
    final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

    recipeModel.select_screen_data(false);
    mealsModel.singleDayMeals_change(false);
    recipeModel.txt_search.clear();

    recipeModel.updateeatingPattern_is(null);
    recipeModel.updateselectedeatingPattern_index(null);
     /// filter params
    recipeModel.selectedfiltercount('0');
    recipeModel.selected_filter.clear();
    recipeModel.save_filter.clear();
    recipeModel.save_select_eatingPattern_id("0");
    recipeModel.save_select_eatingPattern_index(null);
     ///*
    recipeModel.getRecipeData1(context,'',recipeModel.fav_filter,recipeModel.select_cat_id,'0',recipeModel.selected_filter);
    const Duration duration = Duration(milliseconds: 400);
    const Curve curve = Curves.ease;

    if (recipeModel.controller!.hasClients) {
      var scrollPosition = recipeModel.controller!.position;

      scrollPosition.animateTo(
        0,
        duration: duration,
        curve: curve,
      );
    }}


  /// day type check ///


  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime yesterday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
  DateTime tomorrow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

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


  void meals_screen_tap() {
   // // final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
   //  //  recipeModel.add_update_meals_api(context, 2020,recipeModel.selectedDay!.month,dayEvent_list);
   //
   // // recipeModel.get_meals_calendardata_api(context, recipeModel.selectedDay!.year,recipeModel.selectedDay!.month);
   //  final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
   //  daytype_check();
   //
   //  // recipeModel.selecttab_fuction(0);
   //
   //  mealsModel.meal_plan_id_select_fuction(mealsModel.get_meals_planlist_data![0].mtId.toString());
   //
   //  mealsModel.get_meals_calendardata_api(context, mealsModel.selectedDay!.year,mealsModel.selectedDay!.month,0,"1",mealsModel.selectedDay);
   //  mealsModel.get_meals_calendardata_multiple_months_api(context,mealsModel.selectedDay,0);
   //  mealsModel.singal_day_data_gate_api1(DateTime.now(),0);
   //  mealsModel.singal_day_data_gate_api(mealsModel.selectedDay!,true,0);
   //
   //
   //  setState(() {});
  }

  List<Widget> _buildScreens() => [
        const Home(),
        // const Home(),
        const Modules_Screen(),
        const MyMealsScreen(),
        const Recipes_Screen(),
        const SupportScreen(),
        //const Home(),
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [

        PersistentBottomNavBarItem(

          onSelectedTabPressWhenNoScreensPushed: (){
            print('PersistentBottomNavBarItem');
            Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(0);
          },

            icon: Column(
              children: [
                SvgPicture.asset(
                  'assets/image/home.svg',
                  color: HexColor('#2D3091'),
                  height: 18,width: 18,
                ),
                sizedboxheight(4.0),
                Text('Home',style: TextStyle(fontSize: 12,color:HexColor('#2D3091'),fontFamily: fontFamilyText ,fontWeight: fontWeight400 ),)
              ],
            ),
            inactiveIcon:  Column(
              children: [
                SvgPicture.asset(
                  'assets/image/home.svg',
                  color:HexColor('#79879C'),
                  height: 18,width: 18,
                ),
                sizedboxheight(4.0),
                Text('Home',
                  style: TextStyle(fontSize: 12,color:HexColor('#79879C'),fontFamily: fontFamilyText,fontWeight: fontWeight400 ),)
              ],
            ),

            activeColorPrimary: HexColor('#2D3091'),
            inactiveColorPrimary: HexColor('#79879C'),
            ),
        PersistentBottomNavBarItem(
          onSelectedTabPressWhenNoScreensPushed: (){
            Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(1);
            print('PersistentBottomNavBarItem');
          },

          icon: Column(
            children: [
              SvgPicture.asset(
                'assets/image/Category.svg',
                color: HexColor('#2D3091'),
                height: 18,width: 18,
              ),
              sizedboxheight(4.0),
              Text('Modules',style: TextStyle(fontSize: 12,color:HexColor('#2D3091'),fontFamily: fontFamilyText ,fontWeight: fontWeight400),)

            ],
          ),
          inactiveIcon:  Column(
            children: [
              SvgPicture.asset(
                'assets/image/Category.svg',
                color:HexColor('#79879C'),
                height: 18,width: 18,
              ),
              sizedboxheight(4.0),
              Text('Modules',style: TextStyle(fontSize: 12,color:HexColor('#79879C'),fontFamily: fontFamilyText ,fontWeight: fontWeight400),)

            ],
          ),
          activeColorPrimary: HexColor('#2D3091'),
          inactiveColorPrimary: HexColor('#79879C'),

        ),
        PersistentBottomNavBarItem(
          onSelectedTabPressWhenNoScreensPushed: (){
            print('PersistentBottomNavBarItem');
            Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(2);
          },

          icon: Column(
            children: [
              SvgPicture.asset(
                'assets/image/Calendar.svg',
                color: HexColor('#2D3091'),
                height: 18,width: 18,
              ),
              sizedboxheight(4.0),
              Text('My Meals',style: TextStyle(fontSize: 12,color:HexColor('#2D3091'),fontFamily: fontFamilyText ,fontWeight: fontWeight400),)
            ],
          ),
          inactiveIcon:  Column(
            children: [
              SvgPicture.asset(
                'assets/image/Calendar.svg',
                color:HexColor('#79879C'),
                height: 18,width: 18,
              ),
              sizedboxheight(4.0),
              Text('My Meals',style: TextStyle(fontSize: 12,color:HexColor('#79879C'),fontFamily: fontFamilyText ,fontWeight: fontWeight400),)
            ],
          ),
          activeColorPrimary: HexColor('#2D3091'),
          inactiveColorPrimary: HexColor('#79879C'),

        ),
        PersistentBottomNavBarItem(
          onSelectedTabPressWhenNoScreensPushed: (){
           recipe_screen_tap();
           Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(3);

           print('PersistentBottomNavBarItem');
          },

          icon: Column(
            children: [
              SvgPicture.asset(
                'assets/image/recipes.svg',
                color: HexColor('#2D3091'),
                height: 18,width: 18,
              ),
              sizedboxheight(4.0),
              Text('Recipes',style: TextStyle(fontSize: 12,color:HexColor('#2D3091') ,fontFamily: fontFamilyText,fontWeight: fontWeight400),)
            ],
          ),
          inactiveIcon:  Column(
            children: [
              SvgPicture.asset(
                'assets/image/recipes.svg',
                color:HexColor('#79879C'),
                height: 18,width: 18,
              ),
              sizedboxheight(4.0),
              Text('Recipes',style: TextStyle(fontSize: 12,color:HexColor('#79879C'),fontFamily: fontFamilyText ,fontWeight: fontWeight400),)
            ],
          ),
          activeColorPrimary: HexColor('#2D3091'),
          inactiveColorPrimary: HexColor('#79879C'),

        ),
        PersistentBottomNavBarItem(
          onSelectedTabPressWhenNoScreensPushed: (){
            print('PersistentBottomNavBarItem');
            Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(4);

          },

          icon: Column(
            children: [
              SvgPicture.asset(
                'assets/image/Chat.svg',
                color: HexColor('#2D3091'),
                height: 18,width: 18,
              ),
              sizedboxheight(4.0),
              Text('Support',
                style: TextStyle(fontSize: 12,color:HexColor('#2D3091'),fontFamily: fontFamilyText,fontWeight: fontWeight400 ),)
            ],
          ),
          inactiveIcon:  Column(
            children: [
              SvgPicture.asset(
                'assets/image/Chat.svg',
                color:HexColor('#79879C'),
                height: 18,width: 18,
              ),
              sizedboxheight(4.0),
              Text('Support',style: TextStyle(fontSize: 12,color:HexColor('#79879C') ,fontFamily: fontFamilyText,fontWeight: fontWeight400),)
            ],
          ),

          activeColorPrimary: HexColor('#2D3091'),
          inactiveColorPrimary: HexColor('#79879C'),
        ),
      ];

  Future<bool> backdb() async {
    return true;
  }

  Future<bool> _willPopCallback() async {
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    bool screen_back = true;
    if(mealsModel.notes){
      backdb();
      screen_back = true;
    }
    else{
      warning_popup();
      screen_back = false;
    }
    // await showDialog or Show add banners or whatever
    // then
    return screen_back; // return true if the route to be popped
  }
  @override
  Widget build(final BuildContext context) {
    final BottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context);

    return WillPopScope(
     onWillPop: () {
       return BottomNavBarProviderModel.controller!.index == 2?_willPopCallback():(BottomNavBarProviderModel.controller!.index == 0
           ? onWillPop(context)
           : backdb());
     },
     child: Scaffold(
        body: PersistentTabView(
          context,
          controller: BottomNavBarProviderModel.controller,
          popAllScreensOnTapAnyTabs: true,

          onItemSelected: (value){
          print('onItemSelected');
            final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

            if(mealsModel.notes){
              Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(value);
              //  recipe_screen_tap();
             if(value==3){
              Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(3);
              final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);
              if(recipeModel.fav_filter == '1'){
                recipeModel.selectedfav_filter("0");
                recipeModel.txt_search.clear();
                recipeModel.getRecipeData(context,'','0',recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
              }
              else if(recipeModel.selectedCollectionIDName!='0'){
                recipeModel.selectedCollectionIDFunction('0');
                recipeModel.selectedCollectionIDNameFunction('0');
                recipeModel.getRecipeData(context,recipeModel.txt_search.text,'0',recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
              }
            }
            }
            else{
              warning_popup();
              Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(2);
            }
            FocusManager.instance.primaryFocus?.unfocus();
          },
          confineInSafeArea: true,
          handleAndroidBackButtonPress: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardShows: true,
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          navBarHeight: 60,

          screens: _buildScreens(),
          items: _navBarsItems(),
          resizeToAvoidBottomInset: true,
          bottomScreenMargin: 0,
          selectedTabScreenContext: ( context) {
            testContext = context;
            print('selectedTabScreenContext');
          },

          backgroundColor: colorWhite,
          decoration:  NavBarDecoration(colorBehindNavBar: colorBluePigment,boxShadow: [
            const BoxShadow(
              blurStyle: BlurStyle.normal,
              color: Colors.black26,
              offset: Offset(
               3.0,
                3.0,
              ),
              blurRadius: 10.0,
              spreadRadius: 0.0,
            ), //BoxShadow
             //BoxShadow
          ]),
          itemAnimationProperties: const ItemAnimationProperties(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: true,
          ),
          navBarStyle: NavBarStyle.simple,
          // Choose the nav bar style with this property
        ),
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


