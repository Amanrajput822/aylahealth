import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../common/commonwidgets/button.dart';
import '../../../common/styles/const.dart';
import 'learning_screens.dart';

class Start_Learning_Screen extends StatefulWidget {
  const Start_Learning_Screen({Key? key}) : super(key: key);

  @override
  State<Start_Learning_Screen> createState() => _Start_Learning_ScreenState();
}

class _Start_Learning_ScreenState extends State<Start_Learning_Screen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorWhite,
      width: deviceWidth(context),
      height: deviceheight(context),
      child: SafeArea(
        top: true,
        child: Scaffold(

          body: Container(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(

                    height: deviceheight(context,0.25),
                    width: deviceWidth(context),
                    color: colorgrey,
                    child: Stack(
                      children: [
                        Container(
                          height: deviceheight(context,0.25),
                          width: deviceWidth(context),
                          child: Image.asset("assets/img.png",fit: BoxFit.fill,
                            // loadingBuilder: (BuildContext context, Widget child,
                            //     ImageChunkEvent? loadingProgress) {
                            //   if (loadingProgress == null) return child;
                            //   return Center(
                            //     child: CircularProgressIndicator(
                            //       value: loadingProgress.expectedTotalBytes != null
                            //           ? loadingProgress.cumulativeBytesLoaded /
                            //           loadingProgress.expectedTotalBytes!
                            //           : null,
                            //     ),
                            //   );
                            // },
                          ),
                        ),
                        Container(
                          height: deviceheight(context,0.25),
                          width: deviceWidth(context),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 15,
                                        child: SvgPicture.asset('assets/backbutton.svg',color: colorWhite,height: 15,))),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Introduction to Healthy Eating",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: fontFamilyText,
                              color: HexColor('#3B4250'),
                              fontWeight: fontWeight400,
                            ),),
                          Text("True Healthy Eating",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: fontFamilyText,
                              color: HexColor('#151A26'),
                              fontWeight: fontWeight600,
                            ),),
                          sizedboxheight(8.0),
                          Container(
                            child: Wrap(

                              children: [
                                  Card(
                                    elevation: 0,
                                    color: HexColor('#F6F8F9'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0,right: 10,top: 6,bottom: 6),
                                      child: Text("item.catName", style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: fontFamilyText,
                                        color: colorShadowBlue,
                                        fontWeight: fontWeight400,

                                      ),),
                                    ),
                                  ),

                              ],
                            ),
                          ),
                          sizedboxheight(10.0),
                          Text("In this module, you’ll start to understand the true meaning of healthy eating and why it’s so important for good health.", style: TextStyle(
                            fontSize: 16,height: 1.5,
                            fontFamily: fontFamilyText,
                            color: HexColor('#3B4250'),
                            fontWeight: fontWeight400,
                          ),),
                          sizedboxheight(10.0),
                          Container(
                            height: 50,
                            color: HexColor('#F6F8F9'),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/image/play-circle 1.svg',color: colorPrimaryColor,),
                               sizedboxwidth(10.0),
                                  Text("Learn",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: fontFamilyText,
                                      color: colorPrimaryColor,
                                      fontWeight: fontWeight600,
                                    ),),
                                ],
                              ),
                            ),
                          ),
                          sizedboxheight(10.0),
                          Container(
                            height: 50,
                          //  color: HexColor('#F6F8F9'),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/image/lock_icon.svg'),
                                  sizedboxwidth(10.0),
                                  Text("Apply",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: fontFamilyText,
                                      color: colorShadowBlue,
                                      fontWeight: fontWeight400,
                                    ),),
                                ],
                              ),
                            ),
                          ),
                          sizedboxheight(10.0),
                          Container(
                            height: 50,
                            color: HexColor('#F6F8F9'),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/image/lock_icon.svg'),
                                  sizedboxwidth(10.0),
                                  Text("Get Support",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: fontFamilyText,
                                      color: colorShadowBlue,
                                      fontWeight: fontWeight400,
                                    ),),
                                ],
                              ),
                            ),
                          ),
                          sizedboxheight(10.0),
                          start_learning_Btn(context),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  /// start learning button //////////////////

  Widget start_learning_Btn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Start Learning',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnHeight: 55,
        btnfontsize: 20,
        btnfontweight: fontWeight400,
        btnColor: colorBluePigment,
        borderColor: colorBluePigment,
        onPressed: () {
          Get.to(()=>Learning_Screens());
         // Navigator.pop(context);
          // (context as Element).reassemble();
        },
      ),
    );
  }

}
