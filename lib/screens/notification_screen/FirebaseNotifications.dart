import 'dart:async';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/new_bottombar_screen/New_Bottombar_Screen.dart';
import '../../common/styles/Fluttertoast_internet.dart';
import '../../common/styles/const.dart';
import '../../myapp.dart';

import '../tabbar_screens/modules/module_description_screen/module_description_screen.dart';
import '../tabbar_screens/modules/modules_screen/modules_screen_provider.dart';
import '../tabbar_screens/recipes screens/recipe_description/recipes_description_screen.dart';
import '../tabbar_screens/support_screen/message/chat/chat_list.dart';


Future<void> notificationClick( payload) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
 var learningStatusGet = prefs.getString('learningStatus_key');
  learningStatusGet = learningStatusGet!.replaceAll('"', '');

  showDialog(
      context: navigationKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),

        icon: Align(
            alignment: Alignment.centerRight,
            child: InkWell(
                onTap: (){Navigator.of(context).pop(false);},
                child: Icon(Icons.close))),
        iconColor: colorShadowBlue,
        title: Text('New content',style: TextStyle(
            fontSize: 22,color: colorRichblack,
            fontWeight: fontWeight700,fontFamily: fontFamilyText
        ),textAlign: TextAlign.center,),
        content: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Click ',style: TextStyle(
                  fontSize: 18,color: colorRichblack,
                  fontWeight: fontWeight400,fontFamily: fontFamilyText
              )),
              TextSpan(text: 'View ',style: TextStyle(
                  fontSize: 18,color: colorRichblack,
                  fontWeight: fontWeight700,fontFamily: fontFamilyText
              )),
              TextSpan(
                text: 'to check out our latest content!',
                style: TextStyle(
                    fontSize: 18,color: colorRichblack,
                    fontWeight: fontWeight400,fontFamily: fontFamilyText
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),

        // iconPadding: EdgeInsets.only(top: 10,left: 200),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actionsPadding: EdgeInsets.only(bottom: 20),
        actions: [

          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorEnabledButton,
                textStyle: TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
                child: Text('Ok'),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorEnabledButton,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop(false);

                print('on click open app ${payload['data']}');
                print('on click open app ${payload['data']['action']}');

                switch (payload['data']['action']) {
                  case '1':
                   {
                     PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                       testContext!,
                       settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                       screen:  Recipes_Description_Screen(rec_id:payload['data']['id'],rec_index:0,txt_search:'',fav_filter:'0',screen:"Notification",screenName:"notification"),
                     );
                    }
                    break;

                  case '2':
                    {
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        testContext!,
                        settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                        screen:  ChatListScreen(),
                      );
                    }
                    break;
                  case '3':
                    {

                      if(learningStatusGet == 'Start Learning'){
                        FlutterToast_message('Before starting a module, please complete the Get Started module.');
                      }
                      else if(learningStatusGet == 'Continue Learning'){
                        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          testContext!,
                          settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                          screen:  ModuleDescriptionScreen(
                              moduleId:payload['data']['id'].toString(),
                              screenType:"module",
                              screenName:"Home"
                          ),
                        );
                      }else{
                        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          testContext!,
                          settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                          screen:  ModuleDescriptionScreen(
                              moduleId:payload['id'].toString(),
                              screenType:"module",
                              screenName:"Home"

                          ),
                        );
                      }

                    }
                    break;

                  default:{
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      testContext!,
                      settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                      screen:  Recipes_Description_Screen(rec_id:payload['data']['id'],rec_index:0,txt_search:'',fav_filter:'0',screen:"Notification",screenName:"notification"),
                    );
                  }

                    break;
                }
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),

                child: Text('View'),
              )),
        ],
      ));


}


Future<void> notificationClickLocal( payload) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var learningStatusGet = prefs.getString('learningStatus_key');
  learningStatusGet = learningStatusGet!.replaceAll('"', '');
  showDialog(
      context: navigationKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),

        icon: Align(
            alignment: Alignment.centerRight,
            child: InkWell(
                onTap: (){Navigator.of(context).pop(false);},
                child: Icon(Icons.close))),
        iconColor: colorShadowBlue,
        title: Text('New content',style: TextStyle(
            fontSize: 22,color: colorRichblack,
            fontWeight: fontWeight700,fontFamily: fontFamilyText
        ),textAlign: TextAlign.center,),
        content: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Click ',style: TextStyle(
                  fontSize: 18,color: colorRichblack,
                  fontWeight: fontWeight400,fontFamily: fontFamilyText
              )),
              TextSpan(text: 'View ',style: TextStyle(
                  fontSize: 18,color: colorRichblack,
                  fontWeight: fontWeight700,fontFamily: fontFamilyText
              )),
              TextSpan(
                text: 'to check out our latest content!',
                style: TextStyle(
                    fontSize: 18,color: colorRichblack,
                    fontWeight: fontWeight400,fontFamily: fontFamilyText
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),

        // iconPadding: EdgeInsets.only(top: 10,left: 200),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actionsPadding: EdgeInsets.only(bottom: 20),
        actions: [

          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorEnabledButton,
                textStyle: TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
                child: Text('Ok'),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorEnabledButton,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop(false);
                print(payload['action']);
                switch (payload['action']) {
                  case '1':
                    {
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        testContext!,
                        settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                        screen:  Recipes_Description_Screen(rec_id:payload['id'],rec_index:0,txt_search:'',fav_filter:'0',screen:"Notification",screenName:"notification"),
                      );
                    }
                    break;

                  case '2':
                    {
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        testContext!,
                        settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                        screen:  ChatListScreen(),
                      );
                    }
                    break;

                  case '3':
                    {



                      if(learningStatusGet == 'Start Learning'){
                        FlutterToast_message('Before starting a module, please complete the Get Started module.');
                      }
                      else if(learningStatusGet == 'Continue Learning'){
                        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          testContext!,
                          settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                          screen:  ModuleDescriptionScreen(
                              moduleId:payload['id'].toString(),
                              screenType:"module",
                              screenName:"Home"

                          ),
                        );
                      }else{
                        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                          testContext!,
                          settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                          screen:  ModuleDescriptionScreen(
                              moduleId:payload['id'].toString(),
                              screenType:"module",
                              screenName:"Home"

                          ),
                        );
                      }

                    }
                    break;
                  default:{
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      testContext!,
                      settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                      screen:  Recipes_Description_Screen(rec_id:payload['id'],rec_index:0,txt_search:'',fav_filter:'0',screen:"Notification",screenName:"notification"),
                    );
                  }
                  break;
                }

              },
              child: const Padding(
                padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),

                child: Text('View'),
              )),
        ],
      ));

  // String? _refrenceId;

}


// Future notificationPopup() async {
//   return showDialog(
//       context: navigationKey.currentContext!,
//       builder: (BuildContext context) => AlertDialog(
//         shape: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.0)
//         ),
//
//         icon: Align(
//             alignment: Alignment.centerRight,
//             child: InkWell(
//                 onTap: (){Navigator.of(context).pop(false);},
//                 child: Icon(Icons.close))),
//         iconColor: colorShadowBlue,
//         title: Text('New content',style: TextStyle(
//             fontSize: 22,color: colorRichblack,
//             fontWeight: fontWeight700,fontFamily: fontFamilyText
//         ),textAlign: TextAlign.center,),
//         content: Text.rich(
//           TextSpan(
//             children: [
//               TextSpan(text: 'Click ',style: TextStyle(
//                   fontSize: 18,color: colorRichblack,
//                   fontWeight: fontWeight400,fontFamily: fontFamilyText
//               )),
//               TextSpan(text: 'View ',style: TextStyle(
//                   fontSize: 18,color: colorRichblack,
//                   fontWeight: fontWeight700,fontFamily: fontFamilyText
//               )),
//               TextSpan(
//                 text: 'to check out our latest content!',
//                 style: TextStyle(
//                     fontSize: 18,color: colorRichblack,
//                     fontWeight: fontWeight400,fontFamily: fontFamilyText
//                 ),
//               ),
//             ],
//           ),
//           textAlign: TextAlign.center,
//         ),
//
//        // iconPadding: EdgeInsets.only(top: 10,left: 200),
//         actionsAlignment: MainAxisAlignment.spaceEvenly,
//         actionsPadding: EdgeInsets.only(bottom: 20),
//         actions: [
//
//           ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 primary: colorEnabledButton,
//                 textStyle: TextStyle(fontWeight: FontWeight.bold),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: const Padding(
//                 padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
//                 child: Text('Ok'),
//               )),
//           ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 primary: colorEnabledButton,
//                 textStyle: const TextStyle(fontWeight: FontWeight.bold),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//                 PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
//                   testContext!,
//                   settings: const RouteSettings(name: "/Home"),
//                   screen:  Recipes_Description_Screen(rec_id:1,rec_index:0,txt_search:'',fav_filter:'0',screen:"Notification",screenName:"notification"),
//                 );
//               },
//               child: const Padding(
//                 padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
//
//                 child: Text('View'),
//               )),
//         ],
//       ));
//  }

