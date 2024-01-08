import 'dart:async';

import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/screens/tabbar_screens/home/homeScreenProvider.dart';
import 'package:custom_cupertino_picker/custom_cupertino_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../common/commonwidgets/button.dart';
import '../../../common/new_bottombar_screen/Bottom_NavBar_Provider.dart';
import '../../../common/styles/Fluttertoast_internet.dart';
import '../../Profile_screens/Profile_screen.dart';
import 'package:intl/intl.dart';

import '../../notification_screen/FirebaseNotifications.dart';
import '../my_meals/My_Meals_Provider.dart';
import '../my_meals/calendar_evryday_json.dart';
import '../my_meals/shopping_list_screen/ShoppingListScreen.dart';
import '../recipes screens/recipe_description/recipes_description_screen.dart';
import '../recipes screens/recipe_screen/RecipeData_Provider.dart';
import '../support_screen/video_appoinment.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  AppLifecycleState? _appLifecycleState;

  ScrollController? _scrollController;
  bool lastStatus = true;


  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController != null &&
        _scrollController!.hasClients &&
        _scrollController!.offset > (deviceheight(context,0.2) - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController = ScrollController()..addListener(_scrollListener);
    todayDate();
    loginTimeStatusFunction();

    final homeScreenProviderData =  Provider.of<HomeScreenProvider>(context, listen: false);
    homeScreenProviderData.get_meals_plantypelist_api();
    homeScreenProviderData.recipeCollectionList_api();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
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
        final homeScreenProviderData =  Provider.of<HomeScreenProvider>(context, listen: false);
        homeScreenProviderData.recipeList_ditels_api();
        homeScreenProviderData.get_meals_plantypelist_api();
        homeScreenProviderData.singal_day_data_gate_api1(DateTime.now());
      }
      print(foregroundDateTime.toString());
    } else if (state == AppLifecycleState.paused) {
      // App is in the background
      print('App is in the background');
      backgroundDateTime = DateTime.now().year+DateTime.now().month+DateTime.now().day;
      print(backgroundDateTime.toString());

    }
  }




  String? formattedTime;
  todayDate() {
    var now =  DateTime.now();
     formattedTime = DateFormat('EEEE d MMM yyyy').format(now);

  }
  var loginTimeStatus = false;
 Future<void> loginTimeStatusFunction() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(()  {
        loginTimeStatus = prefs.getBool('user_login_time')!;
    });

}
  @override
  Widget build(BuildContext context) {
    final homeScreenProviderData = Provider.of<HomeScreenProvider>(context);

    final meaBottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context);

    return Scaffold(
      body:  NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              elevation: 0,
              backgroundColor: colorBlizzardBluedark,
              pinned: true,
              expandedHeight: deviceheight(context,0.28),

              leading: _isShrink
                  ? Padding(
                    padding: const EdgeInsets.only(top: 16.5,bottom: 16.5,left: 5),
                    child: SvgPicture.asset('assets/image/a icon.svg',height: 20,width: 20,),
                  )
                  : null,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.none,
                background: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizedboxheight(deviceheight(context,0.005)),
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset('assets/image/a icon.svg'),
                            IconButton(onPressed: (){
                              Get.to(() => Profile_screen());
                            }, icon: SvgPicture.asset('assets/image/profile.svg')),

                          ],
                        ),
                      ),
                      sizedboxheight(deviceheight(context,0.1)),
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        child: Text(formattedTime.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontFamilyText,
                            color: colorPrimaryColor,
                            fontWeight: fontWeight400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                        child: Text(loginTimeStatus?"Let’s do this!":'Welcome aboard!',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: fontFamilyText,
                            color: colorPrimaryColor,
                            fontWeight: fontWeight700,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              actions: _isShrink
                  ? [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(onPressed: (){
                    Get.to(() => Profile_screen());
                  }, icon: SvgPicture.asset('assets/image/profile.svg')),
                ),

              ]
                  : null,
            ),
          ];
        },
        body: Container(
          width: deviceWidth(context),
          height: deviceheight(context),
          color: colorBlizzardBluedark,

          child:  Container(
            width: deviceWidth(context),
            height: deviceheight(context),
            decoration: BoxDecoration(
                color: colorWhite,

                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )
            ),
            padding: const EdgeInsets.only(left: 15,right: 15,bottom: 1),
            margin: const EdgeInsets.only(bottom: 55),
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child:Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizedboxheight(25.0),

                  TextButton(onPressed: (){
                    notificationPopup();}, child: Text('button')),

                  hedingtile('Start Learning',(){}),
                  sizedboxheight(15.0),
                  startlearningcard(),

                 sizedboxheight(15.0),
                  homeScreenProviderData.mealData1!.isEmpty? hedingtile('Recipes',(){

                    meaBottomNavBarProviderModel.setcontrollervalue(3);
                    final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);

                    if(recipeModel.fav_filter == '1'){
                      recipeModel.txt_search.clear();
                      recipeModel.selectedfav_filter("0");
                      recipeModel.getRecipeData(context,'','0',recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
                    }
                   else if(recipeModel.selectedCollectionIDName!='0'){
                      recipeModel.txt_search.clear();
                      recipeModel.selectedCollectionIDFunction('0');
                      recipeModel.selectedCollectionIDNameFunction('0');
                      recipeModel.getRecipeData(context,'','0',recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
                    }
                   else if(recipeModel.txt_search.text.isNotEmpty){
                     print('recipeModel.txt_search.text.isNotEmpty');
                      recipeModel.txt_search.clear();
                      recipeModel.getRecipeData(context,'','0',recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
                    }

                  }):
                  hedingtile('Today\'s Meals',() async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    setState(() {
                      prefs.setBool('Home_Screen', true,);
                    });


                    meaBottomNavBarProviderModel.setcontrollervalue(2);

                  }),
                  sizedboxheight(15.0),
                  homeScreenProviderData.loading2
                      ? const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  ):   homeScreenProviderData.mealData1!.isEmpty? recipescard():toDayMealsDataCard(),

                  sizedboxheight(15.0),
                  benarcard('Favourite Recipes','View your favourite meals and snacks',
                      'assets/banner_icon/Favourites.png', HexColor('#D0EEB2'),(){
                        final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);

                        recipeModel.selectedfav_filter("1");
                        recipeModel.selectedCollectionIDFunction('0');
                        recipeModel.selectedCollectionIDNameFunction('0');
                        recipeModel.txt_search.clear();
                        recipeModel.getRecipeData(context,'',recipeModel.fav_filter,recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
                        Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(3);

                      }),
                  sizedboxheight(15.0),

                  hedingtile('Recipe collections',(){
                    // meaBottomNavBarProviderModel.setcontrollervalue(3);
                    // final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);
                    //
                    // if(recipeModel.fav_filter == '1'){
                    //   recipeModel.txt_search.clear();
                    //   recipeModel.selectedfav_filter("0");
                    //   recipeModel.getRecipeData(context,'','0',recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
                    // }
                    // else if(recipeModel.selectedCollectionIDName!='0'){
                    //   recipeModel.txt_search.clear();
                    //   recipeModel.selectedCollectionIDFunction('0');
                    //   recipeModel.selectedCollectionIDNameFunction('0');
                    //   recipeModel.getRecipeData(context,'','0',recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
                    // }
                    // else if(recipeModel.txt_search.text.isNotEmpty){
                    //   recipeModel.txt_search.clear();
                    //   recipeModel.getRecipeData(context,'','0',recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);
                    // }
                  }),
                  sizedboxheight(15.0),
                  recipecollectionscard(),

                  sizedboxheight(15.0),
                  benarcard('Nutrition Support','Connect with a qualified nutritionist or dietitian',
                      'assets/banner_icon/NutritionSupport.png', HexColor('#FBE990'),(){
                        Provider.of<Bottom_NavBar_Provider>(context, listen: false).setcontrollervalue(4);
                      }),
                  sizedboxheight(15.0),
                  benarcard('Shopping List','Shop for your planned meals & snacks',
                      'assets/banner_icon/ShoppingList.png', HexColor('#EC90AC'),(){
                        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          context,
                          settings: const RouteSettings(name: "/Recipes_Screen"),
                          screen:  const ShoppingListScreen(),
                        );
                      }),
                  sizedboxheight(15.0),

                ],
              ),
            ),
          )
        ),
      ),
    );
  }

  Widget hedingtile(hedingtext,Function action){
    return InkWell(
      onTap: () => action(),
      child: Container(
        width: deviceWidth(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: deviceWidth(context,0.7),
              child: Text(hedingtext,
                maxLines: 1,
                style: TextStyle(
                fontSize: 18,
                fontFamily: fontFamilyText,
                color: colorRichblack,
                fontWeight: fontWeight600,
                  overflow: TextOverflow.ellipsis
              ),),
            ),

          (hedingtext=='Recipe collections')?Container() : Container(
                width: 25,
                height: 20,
                child: const Icon(Icons.arrow_forward_ios_rounded,size: 18,),
            )
          ],
        ),

      ),
    );
  }

  Widget startlearningcard(){
    return  Container(
      height: 170,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.only(right:10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),

                ),
                width: deviceWidth(context,0.65),
                height: 155,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/Screen Shot 2022-12-16 at 9.39 2.png')
                        ),

                      ),
                      width: deviceWidth(context,0.65),
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
                      width: deviceWidth(context,0.65),
                      height: 155,
                      padding: EdgeInsets.only(bottom: 10,left: 20),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Get Started',style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontFamilyText,
                            color: colorWhite,
                            fontWeight: fontWeight600,
                            overflow: TextOverflow.ellipsis
                        ),),
                      ),
                    )
                  ],
                ),
              ),
            );

          }),
    );



  }

  /// Recipe data list
  Widget recipescard(){
    final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);
    final mealsModel = Provider.of<MyMeals_Provider>(context, listen: false);
    final homeScreenProviderData = Provider.of<HomeScreenProvider>(context, listen: false);

    return Container(
      height: 200,
      child: homeScreenProviderData.loading
          ? Container(
        child: const Center(child: CircularProgressIndicator()),
      ): ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: homeScreenProviderData.recipe_data_List!.length>3?4:homeScreenProviderData.recipe_data_List!.length,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.green,
                    borderRadius: BorderRadius.circular(5)
                ),
                margin:  const EdgeInsets.all(1.0),
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
                          settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                          screen:  Recipes_Description_Screen(rec_id:homeScreenProviderData.recipe_data_List![index].recId,rec_index:index,txt_search:'',fav_filter:'0',screen:"Home"),
                        );
                      },
                      child: Container(
                        height: 110,width: deviceWidth(context),
                        child: Container(
                          height: 110,width: deviceWidth(context),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(homeScreenProviderData.recipe_data_List![index].image??"https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=",
                              height: 110,width: deviceWidth(context),fit: BoxFit.fill,
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
                      ),
                    ),
                    sizedboxheight(10.0),
                    InkWell(
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          context,
                          settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                          screen:  Recipes_Description_Screen(rec_id:homeScreenProviderData.recipe_data_List![index].recId,rec_index:index,txt_search:'',fav_filter:'0'),
                        );
                      },
                      child: Text(homeScreenProviderData.recipe_data_List![index].recTitle??"",style:TextStyle(
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
                        add_meals_bottom_sheet(homeScreenProviderData.recipe_data_List!,(index));
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
            );

          }),
    );
  }

  /// Today Meals data list
  Widget toDayMealsDataCard(){
    final homeScreenProviderData = Provider.of<HomeScreenProvider>(context, listen: false);

    return Container(
      height: 200,

      child: homeScreenProviderData.loading2
          ? Container(
        child: const Center(child: CircularProgressIndicator()),
      ): ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount:homeScreenProviderData.select_tab_data_list1!.length > 7?8: homeScreenProviderData.select_tab_data_list1!.length,
          itemBuilder: (BuildContext context, int index){
           var todayMealsData = homeScreenProviderData.select_tab_data_list1![index];
            return Padding(
              padding: const EdgeInsets.only(right: 15),
              child: InkWell(
                onTap: (){
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                    screen:  Recipes_Description_Screen(rec_id:todayMealsData.recId,rec_index:index,txt_search:'',fav_filter:'0',screen:"HomeToday"),
                  );
                },
                child: Container(
                  width: deviceWidth(context,0.42),
                  color: colorWhite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: deviceWidth(context,0.35),
                        child: Text(homeScreenProviderData.get_meals_planlist_data![int.parse(todayMealsData.mtId??"")-1].mtName??"",
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: fontFamilyText,
                              color: HexColor('#79879C'),
                              fontWeight: fontWeight600,
                              overflow: TextOverflow.ellipsis
                          ),),
                      ),
                      sizedboxheight(8.0),
                      Container(
                        height: 110,
                       width:deviceWidth(context,0.4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5), // Image border
                          child: SizedBox.fromSize(
                             // Image radius
                            child:Image.network(todayMealsData.image??"https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=",
                              width:deviceWidth(context,0.4) ,
                              height: 110,

                              fit: BoxFit.fill,
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
                              },)



                          ),
                        ),
                      )
                   ,
                      sizedboxheight(8.0),
                      Container(
                        width: deviceWidth(context,0.42),
                        child: Text(todayMealsData.recTitle??"",
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: fontFamilyText,
                              color: HexColor('#3B4250'),
                              fontWeight: fontWeight600,
                              overflow: TextOverflow.ellipsis
                          ),),
                      ),

                    ],
                  ),
                ),
              ),
            );

          }),
    );
  }

  /// Meals Data list
  Widget mymealscard(){
    return Container(
      height: 200,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Container(
                width: deviceWidth(context,0.42),
                color: colorWhite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: deviceWidth(context,0.35),
                      child: Text('Lunch',
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: fontFamilyText,
                            color: HexColor('#79879C'),
                            fontWeight: fontWeight600,
                            overflow: TextOverflow.ellipsis
                        ),),
                    ),
                    sizedboxheight(8.0),
                    Image.asset('assets/Rectangle 1794.png',width:deviceWidth(context,0.42) ,
                      height: 110,
                      fit: BoxFit.fill,
                    ),
                    sizedboxheight(8.0),
                    Container(
                      width: deviceWidth(context,0.42),
                      child: Text('Roast Lamb & Vegetables',
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontFamilyText,
                            color: HexColor('#3B4250'),
                            fontWeight: fontWeight600,
                            overflow: TextOverflow.ellipsis
                        ),),
                    ),

                  ],
                ),
              ),
            );

          }),
    );
  }

  Widget featuredcard(){
    return Container(
      height: 150,
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
                width: deviceWidth(context,0.35),
                height: 140,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/Screen Shot 2022-12-16 at 9.39 2.png')
                        ),

                      ),
                      width: deviceWidth(context,0.35),
                      height: 140,
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
                      width: deviceWidth(context,0.35),
                      height: 140,
                      padding: EdgeInsets.only(bottom: 10,left: 20),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text("Get Started",style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontFamilyText,
                            color: colorWhite,
                            fontWeight: fontWeight600,
                            overflow: TextOverflow.ellipsis
                        ),),
                      ),
                    )
                  ],
                ),
              ),
            );

          }),
    );
  }

 // List<String> collectionList = ["Picnic faves","Brunch goals"];
  Widget recipecollectionscard(){
    final homeScreenProviderData =  Provider.of<HomeScreenProvider>(context, listen: false);
    final meaBottomNavBarProviderModel = Provider.of<Bottom_NavBar_Provider>(context, listen: false);

    return Container(
      height: 150,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: homeScreenProviderData.recipeCollectionList!.length,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: InkWell(
                onTap: (){
                  meaBottomNavBarProviderModel.setcontrollervalue(3);
                  final recipeModel = Provider.of<RecipeData_Provider>(context, listen: false);
                  recipeModel.txt_search.clear();
                    recipeModel.selectedfav_filter("0");
                    recipeModel.selectedCollectionIDFunction(homeScreenProviderData.recipeCollectionList![index].collId.toString());
                    recipeModel.selectedCollectionIDNameFunction(homeScreenProviderData.recipeCollectionList![index].collName.toString());
                    recipeModel.getRecipeData(context,'','0',recipeModel.select_cat_id,recipeModel.save_eatingPattern_id,recipeModel.selected_filter);

                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),

                  ),
                  width: 140,
                  height: 140,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: 140,
                        height: 140,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(homeScreenProviderData.recipeCollectionList![index].image??"https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=",
                            height: 140,width: 140,fit: BoxFit.fill,
                            errorBuilder: (context, url, error) => Image.network("https://media.istockphoto.com/id/1222357475/vector/image-preview-icon-picture-placeholder-for-website-or-ui-ux-design-vector-illustration.jpg?s=612x612&w=0&k=20&c=KuCo-dRBYV7nz2gbk4J9w1WtTAgpTdznHu55W9FjimE=", width:deviceWidth(context,0.4) ,
                              height: 140,

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
                        width: 140,
                        height: 140,
                        padding: EdgeInsets.only(bottom: 10),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(homeScreenProviderData.recipeCollectionList![index].collName??"",style: TextStyle(
                              fontSize: 16,
                              fontFamily: fontFamilyText,
                              color: colorWhite,
                              fontWeight: fontWeight600,
                             // overflow: TextOverflow.ellipsis
                          ),textAlign: TextAlign.center,),
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

  Widget benarcard(String hedingtext,String lebletext,String image, color, Function action){
    return InkWell(
      onTap: () => action() ,
      child: Container(
        width: deviceWidth(context),
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: deviceWidth(context,0.6),
              padding: EdgeInsets.only(left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hedingtext,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: fontFamilyText,
                      color: colorPrimaryColor,
                      fontWeight: fontWeight700,
                      overflow: TextOverflow.ellipsis
                  ),),
                  sizedboxheight(5.0),
                  Text(lebletext,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: fontFamilyText,
                        color: colorPrimaryColor,
                        fontWeight: fontWeight400,
                        overflow: TextOverflow.ellipsis
                    ),)
                ],
              ),
            ),
            Container(
              width: deviceWidth(context,0.3),
              height: 100,
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Positioned(
                      left: 3,
                        top: 3,
                        child: Image.asset('assets/CircleImage.png',height: 65,)),
                    Image.asset(image,height: 70),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                                      Text(recipe_data_List[index].recTitle,style:TextStyle(
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
                                      add_mymeals_Btn(recipe_data_List[index].recId),
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


          recipeModel.select_screen_data(false);
          mealsModel.singleDayMeals_change(false);
          mealsModel.get_meals_calendardata_api(context, recipeModel.selectedDay.year.toString(),recipeModel.selectedDay.month.toString(),int.parse(recipeModel.select_mealplanID_recipe.toString())-1,"0",recipeModel.selectedDay);
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

                                mealsModel.get_meals_calendardata_api(context, selectedDay.year.toString(),selectedDay.month.toString(),int.parse(recipeModel.select_mealplanID_recipe.toString())-1,"0",selectedDay);
                             //   mealsModel.get_meals_calendardata_multiple_months_api(context,selectedDay,int.parse(recipeModel.select_mealplanID_recipe.toString())-1);

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
}
