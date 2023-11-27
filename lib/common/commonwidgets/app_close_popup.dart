// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/services.dart';

import '../styles/const.dart';

// Future<bool> onWillPop1(context) async {
//   final showPopUp = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//             shape: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             title: Text('Are you sure'),
//             content: Text('You want to leave from App'),
//             actions: [
//               ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     primary: colorEnabledButton,
//                     textStyle: TextStyle(fontWeight: FontWeight.bold),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                   onPressed: () {
//
//                     if (Platform.isAndroid) {
//                       SystemNavigator.pop();
//                     } else if (Platform.isIOS) {
//                       exit(0);
//                     }
//                   },
//                   child: Text('Yes')),
//               ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     primary: colorEnabledButton,
//                     textStyle: TextStyle(fontWeight: FontWeight.bold),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop(false);
//                   },
//                   child: Text('No')),
//             ],
//           ));
//
//   return showPopUp ?? false;
// }
//


Future<bool> onWillPop(context) async {
  final showPopUp = await   showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: Text('Are you sure',style:  TextStyle(

            fontFamily: fontFamilyText,
            color: colorBlack,
            fontWeight: fontWeight600,
          ),),
          content: Text('You want to leave from App',style:  TextStyle(

            fontFamily: fontFamilyText,
            color: colorBlack,
            fontWeight: fontWeight600,
          ),),
          actions: [
            CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop("Discard");
                },

                child: Text('No',style:  TextStyle(
                  fontSize: 16,
                  fontFamily: fontFamilyText,
                  color: colorBluePigment,
                  fontWeight: fontWeight600,
                ),)
            ),
            CupertinoDialogAction(
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },

                child: Text('Yes',style:  TextStyle(
                  fontSize: 16,
                  fontFamily: fontFamilyText,
                  color: colorBluePigment,
                  fontWeight: fontWeight600,
                ),)
            ),
            // The "Yes" button

            // The "No" butt

          ],
        );
      }
  );
  return showPopUp ?? false;
}