// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';

Color colorWhite = HexColor("#FFFFFF");
Color colorBlack = HexColor("#000000");
Color colorBlackRichBlack = HexColor("#151A26");

Color colorLightYellow = HexColor("#FFFFE1");
Color colorLightGray = HexColor("#D0D4DB");

Color colorButtonText = HexColor("#1C2B4D");
Color colorDisabledButton = HexColor("#79879C");
Color colorEnabledButton = HexColor("#2D3091");

Color colorPrimaryColor = HexColor("#1C2B4D");
Color colorBlizzardBluedark = HexColor("#A7E4F2");
 Color colorBlizzardBlue = HexColor("#CAEFF7");
Color colorBluePigment = HexColor("#2D3091");
Color colorErrorTextField = HexColor("#FCF3F2");
Color colorShadowBlue = HexColor("#79879C");
Color colorErrorColor = HexColor("#FB5758");

Color colorPassMachField = HexColor("#F0F9F6");
Color colorDisabledTextField = HexColor("#F6F7FB");
Color colorEnabledTextField = HexColor("#F8F9FF");

Color colorTextFieldHintText = HexColor("#79879C");
Color colorTextFieldHadingText = HexColor("#3B4250");
Color colorTextFieldConformPassHadingText = HexColor("#32936F");
Color colorTextFieldMainText = HexColor("#151A26");

Color colorRichblack = HexColor("#151A26");
Color colorSlateGray = HexColor("#6A707F");

Color colorFlutterToast = HexColor("#3B4250");
Color colorCharcoal = HexColor("#3B4250");

Color colorgrey = Colors.grey;


const double fontsizeheading20 = 20.0;
const double fontsizeheading22 = 22.0;
const double fontsize22 = 22.0;
const double fontsize18 = 18.0;
const double fontsize16 = 16.0;
const double fontsize15 = 15.0;
const double fontsize14 = 14.0;
const double fontsize16fontsize16 = 14.0;
const double fontsize11 = 11.0;

const double padding20 = 20.0;
const double padding15 = 15.0;
const double padding10 = 10.0;
const double padding8 = 8.0;
const double padding5 = 5.0;

FontWeight fontWeight600 = FontWeight.w600;
FontWeight fontWeight700 = FontWeight.w700;
FontWeight fontWeight900 = FontWeight.bold;
FontWeight fontWeight400 = FontWeight.w400;
FontWeight fontWeight500 = FontWeight.w500;
FontWeight fontWeightnormal = FontWeight.normal;


String fontFamilyText = 'Messina Sans';


TextStyle? textnormail(context){
  return TextStyle(
    fontSize: 18,color: Colors.white,

  );
}
TextStyle? textwidget(context){
  return TextStyle(
    fontSize: 18,color: HexColor("#1C1C1C"),

  );
}
TextStyle? textbold(context){
  return TextStyle(
      fontSize: 11,color: Colors.black87,
      fontWeight: FontWeight.bold,

  );
}
TextStyle? textheding(context){
  return TextStyle(
    fontSize: 14,color: Colors.black87,
    fontWeight: FontWeight.bold,

  );
}
TextStyle? textstyleHeading1(context) {
  return Theme.of(context).textTheme.headline1;
}

TextStyle? textstyleHeading2(context) {
  return Theme.of(context).textTheme.headline2;
}

TextStyle? textstyleHeading3(context) {
  return Theme.of(context).textTheme.headline3;
}

TextStyle? textstyleHeading6(context) {
  return Theme.of(context).textTheme.headline6;
}

TextStyle? textstylesubtitle2(context) {
  return Theme.of(context).textTheme.subtitle2;
}

TextStyle? textstylesubtitle1(context) {
  return Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.normal);
}

double deviceWidth(context, [double size = 1.0]) {
  return MediaQuery.of(context).size.width * size;
}

double deviceheight(context, [double size = 1.0]) {
  return MediaQuery.of(context).size.height * size;
}

BoxBorder borderCustom() {
  return Border.all(color: colorgrey.withOpacity(0.2));
}

BoxBorder borderCustomlight() {
  return Border.all(color: colorgrey.withOpacity(0.05));
}

Widget sizedboxheight([height = 20.0]) {
  return SizedBox(
    height: height,
  );
}

Widget sizedboxwidth([width = 20.0]) {
  return SizedBox(
    width: width,
  );
}

Widget dividerVertical() {
  return Container(
    width: 1,
    height: double.maxFinite,
    color: Colors.black12,
  );
}

Widget dividerHorizontal(context, width, height) {
  return Center(
    child: Container(
      // width: double.maxFinite,
      width: deviceWidth(context, width),
      decoration: BoxDecoration(
          color: colorgrey, borderRadius: borderRadiuscircular(20.0)),
      height: height,
    ),
  );
}

Widget dividerHorizontalblack(context) {
  return Center(
    child: Container(
      height: 1,
      color: Colors.black26,
    ),
  );
}

Decoration decorationtoprounded() {
  return BoxDecoration(
    color: colorWhite,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(30.0),
      topRight: Radius.circular(30.0),
    ),
  );
}

BorderRadius borderRadiuscircular(radius) {
  return BorderRadius.circular(radius);
}

boxShadowcontainer() {
  return [
    BoxShadow(
      color: Colors.grey.withOpacity(0.07),
      spreadRadius: 3,
      blurRadius: 4,
      offset: Offset(0, 3),
    ),
  ];
}

mediaText(context) {
  return MediaQuery.of(context).copyWith(textScaleFactor: 0.9);
}
