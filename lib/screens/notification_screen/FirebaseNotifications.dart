import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../common/styles/const.dart';
import '../../main.dart';
import '../../myapp.dart';

import 'ReceivedNotification.dart';

class FirebaseNotifications extends ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String newUUID() => Uuid().v4();

  Future<void> firebaseInitialization() async {

    _firebaseMessaging.getToken().then((token) {
      setToken(token);
    });


    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('instance');
        if (message.data['action_type'] == 'callReceiver') {
          var _currentUuid = const Uuid().v4();
          var jason = jsonDecode(message.data['callerDetails']);

        } else {
          notificationClick(message);
        }
      }
    });

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
     // print('OnMessage ${message.data}');
      print('OnMessage11 ${message}');

      notificationDialogManage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp');

      if (message.data['action_type'] == 'callReceiver') {
        var _currentUuid = const Uuid().v4();
        var jason = jsonDecode(message.data['callerDetails']);

      } else {
        notificationClick(message);
      }
    });
  }


  Future setToken(token) async {
    if (token == null) {
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('firebase_token', token.toString());
    }
  }

  Future<void> notificationDialogManage(RemoteMessage message) async {
    print('message get or not yet');
    var title = message.notification!.title;
    var body = message.notification!.body;

    // String type = "${message.data["type"]},${message.data["reference_id"]}";
    if (Platform.isAndroid) {
      print('notification get isAndroid');
      LocalNotification().showNotification(message);
     // LocalNotification().showNotification(title!, message, body!, 0);
    }
    if (Platform.isIOS) {
      print('notification get isIOS');
      LocalNotification().showNotification(message);

      // if (message.data['action_type'] == 'callReceiver') {
      //   var _currentUuid = Uuid().v4();
      //   var jason = jsonDecode(message.data['callerDetails']);
      //
      // } else if (message.data['action_type'] == 'Reveal') {
      //
      // } else {
      //   showDialog(
      //     context: navigatorKey.currentContext!,
      //     builder: (BuildContext context) => CupertinoAlertDialog(
      //       title: Text(title!),
      //       content: Text(body!),
      //       actions: <Widget>[
      //         CupertinoDialogAction(
      //           isDefaultAction: true,
      //           onPressed: () {
      //             notificationClickIos(message);
      //           },
      //           child: const Text('Ok'),
      //         )
      //       ],
      //     ),
      //   );
      // }
    }

  }

}

Future<void> notificationClickIos(var payload) async {
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

            SharedPreferences pref = await SharedPreferences.getInstance();
            print('app close and minimize');
            print(pref.getString('screen'));
            switch (payload.data['action_type']) {
              case "message":
                if (pref.getString('screen') != null &&
                    pref.getString('screen') != 'chat') {
                }
                break;

              case "normal":

                break;

              default:

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

Future<void> notificationClick(var payload) async {
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

                SharedPreferences pref = await SharedPreferences.getInstance();
                print('app close and minimize');
                print(pref.getString('screen'));
                switch (payload.data['action_type']) {
                  case "message":
                    if (pref.getString('screen') != null &&
                        pref.getString('screen') != 'chat') {
                    }
                    break;

                  case "normal":

                    break;

                  default:

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


Future<void> notificationClickLocal(var payload) async {
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

                SharedPreferences pref = await SharedPreferences.getInstance();
                print('open app');
                switch (payload['action_type']) {
                  case "message":
                    if (pref.getString('screen') != null &&
                        pref.getString('screen') != 'chat') {
                    }
                    break;

                  case "normal":

                    break;
                  default:

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

Future notificationPopup() async {
  return showDialog(
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
              onPressed: () {
                Navigator.of(context).pop(false);

              },
              child: const Padding(
                padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),

                child: Text('View'),
              )),
        ],
      ));
}