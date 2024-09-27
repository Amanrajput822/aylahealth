import "dart:developer";

import "package:aylahealth/common/new_bottombar_screen/screens.dart";
import "package:aylahealth/common/styles/const.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:hexcolor/hexcolor.dart";
import "package:intl/intl.dart";
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";
import "package:provider/provider.dart";

import "../../models/recipelist/filtter_list_models/Recipe_Filtter_model.dart";
import "../../screens/notification_screen/FirebaseNotifications.dart";
import "../../screens/notification_screen/newNotificationFile.dart";
import "../../screens/subscription_screens/subscriptionProvider.dart";
import "../../screens/tabbar_screens/home/home.dart";
import "../../screens/tabbar_screens/home/homeScreenProvider.dart";
import "../../screens/tabbar_screens/modules/module_description_screen/ModuleDescriptionProvider.dart";
import '../../screens/tabbar_screens/modules/modules_screen/modules_screen.dart';
import "../../screens/tabbar_screens/modules/modules_screen/modules_screen_provider.dart";
import "../../screens/tabbar_screens/my_meals/My_Meals_Provider.dart";
import "../../screens/tabbar_screens/my_meals/my_meals_screen.dart";
import "../../screens/tabbar_screens/recipes screens/recipe_screen/RecipeData_Provider.dart";
import "../../screens/tabbar_screens/recipes screens/recipe_screen/recipes_screen.dart";
import "../../screens/tabbar_screens/support_screen/message/chat/chat_list.dart";
import "../../screens/tabbar_screens/support_screen/support_screen.dart";
import "../SharedPrefHelper.dart";
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
 // static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  @override
  void initState() {
    final modulesProviderData = Provider.of<ModulesScreenProvider>(context, listen: false);
    modulesProviderData.freeModuleList_api();
    super.initState();
     NotificationHandler.firebaseInit();
     NotificationHandler.initialize();
   // requestNotificationPermission();

    final BottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context, listen: false);
    BottomNavBarProviderModel.setcontrollervalue(0,context);
    BottomNavBarProviderModel.chatMessagesFunction(false);

    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    mealsModel.get_meals_plantypelist_api();
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    subscriptionProvider.checkSubscriptionAPI(context,'LoginScreen');
    listenToNewMessages();
  }

  // static Future<void> requestNotificationPermission() async {
  //   NotificationSettings notificationSettings =
  //   await _messaging.requestPermission();
  //   log(notificationSettings.authorizationStatus.name,
  //       name: "Notification Permission");
  //   print('Notification Permission');
  //   print(notificationSettings.authorizationStatus.name);
  // }
  void listenToNewMessages() {
    final BottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context, listen: false);
    FirebaseFirestore.instance.collection("users")
        .doc(SharedPrefHelper.userId.toString())
        .collection("messages")
        .orderBy('created', descending: false)
        .snapshots()
        .listen((event) {

      var a = event.docs.last.data();
      var b = a['senderId'];
      if(event.docs.length == event.docChanges.length){
        BottomNavBarProviderModel.unreadMessagesFunction(0);
      }
      else{
        if(b.toString() == SharedPrefHelper.userId.toString()){
          BottomNavBarProviderModel.unreadMessagesFunction(0);
        }else{
          BottomNavBarProviderModel.unreadMessagesFunction(1);
        }
      }

    });
  }
  void setStatus(String status) async {
    try {
      // Get the document reference
      var docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(SharedPrefHelper.userId.toString());

      // Check if the document exists
      var docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Update the document if it exists
        await docRef.update({
          "status": status,
        });
      } else {
        // Handle case where document doesn't exist (e.g., create the document)
        await docRef.set({
          "status": status,
        });
      }
    } catch (e) {
      print("Error updating status: $e");
      // You can show a Cupertino dialog here if needed
    }
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


  List<Widget> _buildScreens() => [
        const Home(),
        const Modules_Screen(),
        const MyMealsScreen(),
        const Recipes_Screen(),
        const SupportScreen(),
      ];

  List<PersistentBottomNavBarItem> _navBarsItems(BottomNavBarProviderModel) => [

        PersistentBottomNavBarItem(

          onSelectedTabPressWhenNoScreensPushed: (){
            print('PersistentBottomNavBarItem');

            Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(0,context);
            final homeScreenProviderData =  Provider.of<HomeScreenProvider>(context, listen: false);
           homeScreenProviderData.recipeList_ditels_api();
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
            Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(1,context);
            print('PersistentBottomNavBarItem');
            final modulesProviderData = Provider.of<ModulesScreenProvider>(context, listen: false);
            modulesProviderData.get_moduleLibrary_api();

           // modulesProviderData.continueLearningModuleList_api();
            modulesProviderData.freeModuleList_api();
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

            Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(2,context);
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
           Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(3,context);

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

            Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(4,context);

          },

          icon: Column(
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                    'assets/image/Chat.svg',
                    color: HexColor('#2D3091'),
                    height: 18,width: 18,
                  ),
                  Positioned(
                    right: 1,
                    child: Container( decoration: BottomNavBarProviderModel.unreadMessages > 0
                        ? BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    )
                        : null,
                      width: 5,height: 5,),
                  ),
                ],
              ),
              sizedboxheight(4.0),
              Text('Support',
                style: TextStyle(fontSize: 12,color:HexColor('#2D3091'),fontFamily: fontFamilyText,fontWeight: fontWeight400 ),)
            ],
          ),
          inactiveIcon:  Column(
            children: [
              Stack(
                children: [

                  SvgPicture.asset(
                    'assets/image/Chat.svg',
                    color:HexColor('#79879C'),
                    height: 18,width: 18,
                  ),
                  Positioned(
                    right: 1,
                    child: Container( decoration: BottomNavBarProviderModel.unreadMessages > 0
                        ? BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    )
                        : null,
                      width: 5,height: 5,),
                  ),
                ],
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
    final BottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context, listen: false);
    final DescriptionScreenData = Provider.of<ModulesDescriptionScreenProvider>(context, listen: false);
    bool screen_back = false;
    setStatus("Offline");
    BottomNavBarProviderModel.chatMessagesFunction(false);
    if(BottomNavBarProviderModel.applyScreen){
      print('aaa${DescriptionScreenData.pageApplyIndex != 0}');
      if(DescriptionScreenData.pageApplyIndex != 0){
        setState(() {
         // DescriptionScreenData.pageApplyIndexFunction(DescriptionScreenData.pageApplyIndex-1);
          DescriptionScreenData.pageController.animateToPage(
            DescriptionScreenData.pageApplyIndex - 1,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          screen_back = false;
        });
      }else{

        BottomNavBarProviderModel.barHideScreenFunction(true);
        BottomNavBarProviderModel.applyScreenFunction(false);
        screen_back = true;

      }
      final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);
      List<FilterTag> filter = [];
      recipeModel.recipeList_ditels_api(search_test:"",favorite:"0",cat_id: '0',eat_id: '0',tagIds_list:filter);

    }
    else{
      screen_back = true;
    }
    return screen_back;
  }

  Future<bool> _willPopCallback() async {
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    final BottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context, listen: false);
    final DescriptionScreenData = Provider.of<ModulesDescriptionScreenProvider>(context, listen: false);
    bool screen_back = true;
    if(mealsModel.notes){
      backdb();
      setStatus("Offline");
      BottomNavBarProviderModel.chatMessagesFunction(false);
     // BottomNavBarProviderModel.barHideScreenFunction(true);
      if(BottomNavBarProviderModel.applyScreen){
        print('aaa${DescriptionScreenData.pageApplyIndex != 0}');
        if(DescriptionScreenData.pageApplyIndex != 0){
          setState(() {
           // DescriptionScreenData.pageApplyIndexFunction(DescriptionScreenData.pageApplyIndex-1);
            DescriptionScreenData.pageController.animateToPage(
              DescriptionScreenData.pageApplyIndex - 1,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        }else{

          BottomNavBarProviderModel.barHideScreenFunction(true);
          BottomNavBarProviderModel.applyScreenFunction(false);
          Navigator.pop(context);

        }
        final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);
        List<FilterTag> filter = [];
        recipeModel.recipeList_ditels_api(search_test:"",favorite:"0",cat_id: '0',eat_id: '0',tagIds_list:filter);

      }
      screen_back = true;
    }
    else{
      warning_popup();
      setStatus("Offline");
      BottomNavBarProviderModel.chatMessagesFunction(false);
    //  BottomNavBarProviderModel.barHideScreenFunction(true);
      if(BottomNavBarProviderModel.applyScreen){
        print('aaa${DescriptionScreenData.pageApplyIndex != 0}');
        if(DescriptionScreenData.pageApplyIndex != 0){
          // setState(() {
          //   DescriptionScreenData.pageApplyIndexFunction(DescriptionScreenData.pageApplyIndex-1);
          // });
          DescriptionScreenData.pageController.animateToPage(
            DescriptionScreenData.pageApplyIndex - 1,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }else{

          BottomNavBarProviderModel.barHideScreenFunction(true);
          BottomNavBarProviderModel.applyScreenFunction(false);
          Navigator.pop(context);

        }
        final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);
        List<FilterTag> filter = [];
        recipeModel.recipeList_ditels_api(search_test:"",favorite:"0",cat_id: '0',eat_id: '0',tagIds_list:filter);

      }
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
          navBarHeight: BottomNavBarProviderModel.barHideScreen ? 60 :0,
          hideNavigationBar: !BottomNavBarProviderModel.barHideScreen,

          onItemSelected: (value){
          print('onItemSelected');
          setStatus("Offline");
          BottomNavBarProviderModel.chatMessagesFunction(false);
            final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

            if(mealsModel.notes){
              Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(value,context);
              //  recipe_screen_tap();
             if(value==3){
              Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(3,context);
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
              Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(2,context);
            }
            FocusManager.instance.primaryFocus?.unfocus();
          },
          confineInSafeArea: true,
          handleAndroidBackButtonPress: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardShows: true,
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,


          screens: _buildScreens(),
          items: _navBarsItems(BottomNavBarProviderModel),
          resizeToAvoidBottomInset: true,
          bottomScreenMargin: 0,
          selectedTabScreenContext: ( context) {
            testContext = context;
            print('selectedTabScreenContext');
            setStatus("Offline");
            BottomNavBarProviderModel.chatMessagesFunction(false);
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


