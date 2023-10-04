import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../common/commonwidgets/button.dart';
import '../../../../../common/styles/const.dart';

class VideoAppointment extends StatefulWidget {
  const VideoAppointment({Key? key}) : super(key: key);

  @override
  State<VideoAppointment> createState() => _VideoAppointmentState();
}

class _VideoAppointmentState extends State<VideoAppointment> {


  @override
  Widget build(BuildContext context) {
    return    Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor:  colorWhite,
        leading: IconButton(onPressed: (){
          Get.back();
        },icon:  Icon(Icons.arrow_back_ios_new,color: colorRichblack,size: 20),),
      ),
      body: Container(
        width: deviceWidth(context),
        height: deviceheight(context),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text("Book a video consultation",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: fontFamilyText,
                  color: colorRichblack,
                  fontWeight: fontWeight600,
                ),).paddingOnly(left: 20.0,right: 20),

              sizedboxheight(10.0),
              Text("See a dietitian for personalised advice with food & nutrition.",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: fontFamilyText,
                  color: colorSlateGray,
                  fontWeight: fontWeight400,
                ),).paddingOnly(left: 20.0,right: 20),
              sizedboxheight(20.0),
              Card(
                elevation: 2,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)
                    )

                ),
                child: Container(
                  width: deviceWidth(context),
                  height: deviceheight(context,0.7),
                  padding: const EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Select a service",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontFamilyText,
                            color: colorRichblack,
                            fontWeight: fontWeight400,
                          ),),
                        sizedboxheight(5.0),
                        Text("Prices are inclusive of tax, if tax is applicable",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: fontFamilyText,
                            color: colorSlateGray,
                            fontWeight: fontWeight400,
                          ),),
                        sizedboxheight(20.0),


                      ],
                    ),
                  ),
                ).paddingAll(20),
              ),


            ],
          ),
        ),
      ),
    );
  }

}
