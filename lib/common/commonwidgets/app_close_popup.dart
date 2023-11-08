// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/services.dart';

import '../styles/const.dart';

Future<bool> onWillPop(context) async {
  final showPopUp = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text('Are you sure'),
            content: Text('You want to leave from App'),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: colorEnabledButton,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {

                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else if (Platform.isIOS) {
                      exit(0);
                    }
                  },
                  child: Text('Yes')),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: colorEnabledButton,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('No')),
            ],
          ));

  return showPopUp ?? false;
}


