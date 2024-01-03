import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../common/styles/const.dart';
import '../../main.dart';
import '../../myapp.dart';

import '../tabbar_screens/recipes screens/recipe_description/recipes_description_screen.dart';
import 'ReceivedNotification.dart';
//
// class FirebaseNotifications extends ChangeNotifier {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//
//   String newUUID() => Uuid().v4();
//
//   Future<void> firebaseInitialization() async {
//
//     _firebaseMessaging.getToken().then((token) {
//       setToken(token);
//     });
//
//
//     FirebaseMessaging.instance.getInitialMessage().then((message) async {
//       if (message != null) {
//         print('instance');
//         if (message.data['action'] == 'callReceiver') {
//           var _currentUuid = const Uuid().v4();
//           var jason = jsonDecode(message.data['callerDetails']);
//
//         } else {
//           notificationClick(message);
//         }
//       }
//
//     });
//
//     FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
//       print('OnMessage ${message.data}');
//
//       notificationDialogManage(message);
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async{
//       print('onMessageOpenedApp ${message.data}');
//
//       if (message.data['action'] == 'callReceiver') {
//         var _currentUuid = const Uuid().v4();
//         var jason = jsonDecode(message.data['callerDetails']);
//
//       } else {
//         notificationClick(message);
//       }
//
//     });
//   }
//
//
//   Future setToken(token) async {
//     if (token == null) {
//     } else {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString('firebase_token', token.toString());
//     }
//   }
//
//   Future<void> notificationDialogManage(RemoteMessage message) async {
//     print('message get or not yet');
//
//     var title = message.data['title'];
//     var body = message.data['body'];
//
//     // String type = "${message.data["type"]},${message.data["reference_id"]}";
//     if (Platform.isAndroid) {
//       print('notification get isAndroid');
//       print("message${message}");
//       print("title${title}");
//       print("body${body}");
//       LocalNotification().showNotificationIOS(message);
//       // LocalNotification().showNotification(message);
//     // LocalNotification().showNotificationAndroid(title!, message, body!, 0);
//     }
//     if (Platform.isIOS) {
//       print('notification get isIOS');
//        LocalNotification().showNotificationIOS(message);
//     }
//
//   }
//
// }



Future<void> notificationClick( payload) async {
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
                primary: colorEnabledButton,
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
                primary: colorEnabledButton,
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
                       context,
                       settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                       screen:  Recipes_Description_Screen(rec_id:payload['data']['id'],rec_index:0,txt_search:'',fav_filter:'0',screen:"Home"),
                     );
                    }
                    break;

                  case '2':
                    {
                      // PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      //   context,
                      //   settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                      //   screen:  Recipes_Description_Screen(rec_id:1,rec_index:0,txt_search:'',fav_filter:'0',screen:"Home"),
                      // );
                    }
                    break;


                  default:{
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                      screen:  Recipes_Description_Screen(rec_id:payload['data']['id'],rec_index:0,txt_search:'',fav_filter:'0',screen:"Home"),
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
                primary: colorEnabledButton,
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
                primary: colorEnabledButton,
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
                        context,
                        settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                        screen:  Recipes_Description_Screen(rec_id:payload['id'],rec_index:0,txt_search:'',fav_filter:'0',screen:"Home"),
                      );
                    }
                    break;

                  case '2':
                    {
                      // PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      //   context,
                      //   settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                      //   screen:  Recipes_Description_Screen(rec_id:1,rec_index:0,txt_search:'',fav_filter:'0',screen:"Home"),
                      // );
                    }
                    break;
                  default:{
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      settings: const RouteSettings(name: "/Recipes_Description_Screen"),
                      screen:  Recipes_Description_Screen(rec_id:payload['id'],rec_index:0,txt_search:'',fav_filter:'0',screen:"Home"),
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

// Future<void> notificationClickIos(var payload) async {
//    showDialog(
//   context: navigationKey.currentContext!,
//   builder: (BuildContext context) => AlertDialog(
//     shape: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10.0)
//     ),
//
//     icon: Align(
//         alignment: Alignment.centerRight,
//         child: InkWell(
//             onTap: (){Navigator.of(context).pop(false);},
//             child: Icon(Icons.close))),
//     iconColor: colorShadowBlue,
//     title: Text('New content',style: TextStyle(
//         fontSize: 22,color: colorRichblack,
//         fontWeight: fontWeight700,fontFamily: fontFamilyText
//     ),textAlign: TextAlign.center,),
//     content: Text.rich(
//       TextSpan(
//         children: [
//           TextSpan(text: 'Click ',style: TextStyle(
//               fontSize: 18,color: colorRichblack,
//               fontWeight: fontWeight400,fontFamily: fontFamilyText
//           )),
//           TextSpan(text: 'View ',style: TextStyle(
//               fontSize: 18,color: colorRichblack,
//               fontWeight: fontWeight700,fontFamily: fontFamilyText
//           )),
//           TextSpan(
//             text: 'to check out our latest content!',
//             style: TextStyle(
//                 fontSize: 18,color: colorRichblack,
//                 fontWeight: fontWeight400,fontFamily: fontFamilyText
//             ),
//           ),
//         ],
//       ),
//       textAlign: TextAlign.center,
//     ),
//
//     // iconPadding: EdgeInsets.only(top: 10,left: 200),
//     actionsAlignment: MainAxisAlignment.spaceEvenly,
//     actionsPadding: EdgeInsets.only(bottom: 20),
//     actions: [
//
//       ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             primary: colorEnabledButton,
//             textStyle: TextStyle(fontWeight: FontWeight.bold),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//           ),
//           onPressed: () {
//             Navigator.of(context).pop(false);
//           },
//           child: const Padding(
//             padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
//             child: Text('Ok'),
//           )),
//       ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             primary: colorEnabledButton,
//             textStyle: const TextStyle(fontWeight: FontWeight.bold),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//           ),
//           onPressed: () async {
//             Navigator.of(context).pop(false);
//
//             switch (payload['action']) {
//               case '1':
//                 {
//                   PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
//                     context,
//                     settings: const RouteSettings(name: "/Recipes_Description_Screen"),
//                     screen:  Recipes_Description_Screen(rec_id:payload['id'],rec_index:0,txt_search:'',fav_filter:'0',screen:"Home"),
//                   );
//                 }
//                 break;
//
//               case '2':
//                 {
//                   // PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
//                   //   context,
//                   //   settings: const RouteSettings(name: "/Recipes_Description_Screen"),
//                   //   screen:  Recipes_Description_Screen(rec_id:payload['id'],rec_index:0,txt_search:'',fav_filter:'0',screen:"Home"),
//                   // );
//                 }
//                 break;
//
//
//               default:{
//                 PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
//                   context,
//                   settings: const RouteSettings(name: "/Recipes_Description_Screen"),
//                   screen:  Recipes_Description_Screen(rec_id:payload['id'],rec_index:0,txt_search:'',fav_filter:'0',screen:"Home"),
//                 );
//               }
//
//               break;
//             }
//           },
//           child: const Padding(
//             padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
//
//             child: Text('View'),
//           )),
//     ],
//   ));
// }

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
//                   context,
//                   settings: const RouteSettings(name: "/Recipes_Description_Screen"),
//                   screen:  Recipes_Description_Screen(rec_id:1,rec_index:0,txt_search:'',fav_filter:'0',screen:"Home"),
//                 );
//               },
//               child: const Padding(
//                 padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
//
//                 child: Text('View'),
//               )),
//         ],
//       ));
// }