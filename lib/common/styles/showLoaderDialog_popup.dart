import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'const.dart';

void showLoaderDialog_popup(context,title){
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content:  Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("${title.toString()}...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  return showLoaderDialog(context);
}


showLoaderDialog1(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content:  Container(
        width: 60,height: 60,
        // padding: EdgeInsets.only(left: 50,right: 50),
        child: Center(child: CircularProgressIndicator())),
  );
  showDialog(
    barrierDismissible: false,
    context: context,

    builder: (BuildContext context) {
      return Container(
          padding: EdgeInsets.only(left: 80,right: 80),
          width: 60,height: 60,
          color: Colors.transparent,
          child: alert);
    },
  );
}