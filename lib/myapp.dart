import 'package:aylahealth/screens/food_natrition_settings/Food_Nutrition_Settings_provider.dart';
import 'package:aylahealth/screens/help_screen/faq_screen_provider.dart';
import 'package:aylahealth/screens/onbording_screen/pre_question_loding_screen.dart';
import 'package:aylahealth/screens/onbording_screen/screen1.dart';
import 'package:aylahealth/screens/onbording_screen/screen7.dart';
import 'package:aylahealth/screens/profile_settings/personal_setting/personal_setting_provider.dart';
import 'package:aylahealth/screens/subscription_screens/subscription_screen.dart';
import 'package:aylahealth/screens/tabbar_screens/home/home.dart';
import 'package:aylahealth/screens/tabbar_screens/my_meals/My_Meals_Provider.dart';
import 'package:aylahealth/screens/tabbar_screens/my_meals/shopping_list_screen/ShoppingListScreen.dart';
import 'package:aylahealth/screens/tabbar_screens/my_meals/shopping_list_screen/shoping_list_provider.dart';
import 'package:aylahealth/screens/tabbar_screens/recipes%20screens/recipe_description/Recipe_Description_DataProvider.dart';
import 'package:aylahealth/screens/tabbar_screens/recipes%20screens/recipe_screen/RecipeData_Provider.dart';
import 'package:aylahealth/screens/tabbar_screens/recipes%20screens/recipe_screen/recipes_screen.dart';
import 'package:aylahealth/splesh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

import 'FlutterNativeSplash.dart';
import 'common/new_bottombar_screen/Bottom_NavBar_Provider.dart';
import 'common/new_bottombar_screen/New_Bottombar_Screen.dart';
import 'demo/appleLogin_demo.dart';
import 'demo/deno.dart';
import 'home_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Recipe_Description_DataProvider()),
        ChangeNotifierProvider(create: (context) => RecipeData_Provider()),
        ChangeNotifierProvider(create: (context) => Bottom_NavBar_Provider()),
        ChangeNotifierProvider(create: (context) => MyMeals_Provider()),
        ChangeNotifierProvider(create: (context) => userprofile_Provider()),
        ChangeNotifierProvider(create: (context) => Food_Nutrition_Settings_provider()),
        ChangeNotifierProvider(create: (context) => ShoppingListProvider()),
        ChangeNotifierProvider(create: (context) => FAQsScreenProvider()),
        // ChangeNotifierProvider(create: (context) => Show_Updete_Settings_provider()),
      ],
      // create: (context) => RecipeDataProvider(),
      child: GetMaterialApp(
        title: 'Ayla Health',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(

          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
          ),
        ),
        builder: (context, child) {
          final mediaQueryData = MediaQuery.of(context);
          final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.0);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
            child: child!,
          );
        },
        initialRoute: '/',
        routes: {

          '/': (context) => Splesh(),
          'HomeScreen': (context) => HomeScreen(),
          'd': (context) => Pre_Question_Screen(),
          'Screen1': (context) => Screen1(),
          'SubscriptionScreen': (context) => SubscriptionScreen(),
          'Screen7': (context) => Screen7(),
          'demo': (context) => SliverWithTabBar(),
          'New_Bottombar_Screen': (context) => New_Bottombar_Screen(),
          'Home': (context) => Home(),
          'Recipes_Screen': (context) => Recipes_Screen(),
          'apple_login_demo': (context) => apple_login_demo(),
          'ShoppingListScreen': (context) => ShoppingListScreen(),
          // 'CalendarApp': (context) => CalendarApp(),


        },
        // home: Splesh(),
      ),
    );
  }
}