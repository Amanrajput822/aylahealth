import "package:aylahealth/common/new_bottombar_screen/screens.dart";
import "package:aylahealth/common/styles/const.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:hexcolor/hexcolor.dart";
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";
import "package:provider/provider.dart";

import "../../screens/tabbar_screens/home/home.dart";
import "../../screens/tabbar_screens/modules/modules_screen.dart";
import "../../screens/tabbar_screens/my_meals/My_Meals_Provider.dart";
import "../../screens/tabbar_screens/my_meals/my_meals_screen.dart";
import "../../screens/tabbar_screens/recipes screens/recipe_screen/RecipeData_Provider.dart";
import "../../screens/tabbar_screens/recipes screens/recipe_screen/recipes_screen.dart";
import "../commonwidgets/commonwidgets.dart";
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
    final BottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context, listen: false);
    BottomNavBarProviderModel.setcontrollervalue(0);
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    mealsModel.get_meals_plantypelist_api();
   // _controller = PersistentTabController(initialIndex: 0);
  }
  /// recipe screen list  ////
  void recipe_screen_tap() {
    final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

    recipeModel.select_screen_data(false);
    mealsModel.singleDayMeals_change(false);
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

  void meals_screen_tap() {
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    //  recipeModel.add_update_meals_api(context, 2020,recipeModel.selectedDay!.month,dayEvent_list);

   // recipeModel.get_meals_calendardata_api(context, recipeModel.selectedDay!.year,recipeModel.selectedDay!.month);

  }

  List<Widget> _buildScreens() => [
        const Home(),
        const Home(),
       // const Modules_Screen(),
        const My_Meals_Screen(),
        const Recipes_Screen(),
        const Home(),
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [

        PersistentBottomNavBarItem(
          onPressed: (value){
            final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

            if(mealsModel.notes){
              Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(0);
             // recipe_screen_tap();
            }
            else{
              warning_popup();
            }
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
          onPressed: (value){
            final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

            if(mealsModel.notes){
              Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(1);
             // recipe_screen_tap();
            }
            else{
              warning_popup();
            }
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
            Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(2);
          },
          onPressed: (value){
            final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

            if(mealsModel.notes){
              Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(2);

             // recipe_screen_tap();
            }
            else{
              warning_popup();
            }
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
          },
          onPressed: (value){
            final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

            if(mealsModel.notes){
              Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(3);
              recipe_screen_tap();
            }
            else{
              warning_popup();
            }
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
          onPressed: (value){
            final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);

            if(mealsModel.notes){
              Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(4);
            //  recipe_screen_tap();
            }
            else{
              warning_popup();
            }
          },
          icon: Column(
            children: [
              SvgPicture.asset(
                'assets/image/Chat.svg',
                color: HexColor('#2D3091'),
                height: 18,width: 18,
              ),
              sizedboxheight(4.0),
              Text('Chat',
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
              Text('Chat',style: TextStyle(fontSize: 12,color:HexColor('#79879C') ,fontFamily: fontFamilyText,fontWeight: fontWeight400),)
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
          confineInSafeArea: true,

          handleAndroidBackButtonPress: true,

          stateManagement: true,
          hideNavigationBarWhenKeyboardShows: true,
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          navBarHeight: 60,
          context,
          controller: BottomNavBarProviderModel.controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          resizeToAvoidBottomInset: true,
          bottomScreenMargin: 0,
          selectedTabScreenContext: ( context) {
            testContext = context;
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
          navBarStyle: NavBarStyle.simple, // Choose the nav bar style with this property
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


