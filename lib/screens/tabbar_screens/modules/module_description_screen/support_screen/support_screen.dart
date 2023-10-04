import 'package:aylahealth/screens/tabbar_screens/modules/module_description_screen/support_screen/video_appoinment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../common/commonwidgets/button.dart';
import '../../../../../common/styles/const.dart';
import '../HomeWidget.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              Text("Get support",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: fontFamilyText,
                  color: colorRichblack,
                  fontWeight: fontWeight600,
                ),).paddingOnly(left: 20.0,right: 20),

              sizedboxheight(10.0),
              Text("Check in with a dietitian for help with what you’ve just learnt.",
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
                  height: deviceheight(context,0.7),
                  width: deviceWidth(context),
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Choose your support option:",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: fontFamilyText,
                            color: colorSlateGray,
                            fontWeight: fontWeight400,
                          ),),
                        sizedboxheight(20.0),
                        InkWell(
                          onTap: (){
                            Get.to(()=>VideoAppointment());
                          },
                          child: benarcard('Book a video appointment','For complex challenges or questions',
                              'assets/booking_appointment.png', HexColor('#EBFADC')),
                        ),
                        sizedboxheight(20.0),
                        InkWell(
                          onTap: (){
                            Get.to(()=>HomeWidget());
                          },
                          child: benarcard('Live Chat','A quick answer for nutrition questions',
                              'assets/live_chat.png', HexColor('#E6F4F8')),
                        ),
                        sizedboxheight(20.0),
                        Container(
                          width: deviceWidth(context),
                          height: 40,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1.5,
                                  color: colorSlateGray,
                                ),
                              ),
                              sizedboxwidth(8.0),
                              Container(

                                child: Text('All good? Click below',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: fontFamilyText,
                                  fontWeight: fontWeight400,
                                  color: colorSlateGray
                                ),)
                              ),
                              sizedboxwidth(8.0),
                              Expanded(
                                child: Container(
                                  height: 1.5,
                                  color: colorSlateGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        sizedboxheight(20.0),

                        complet_Btn(context)
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
  /// next button //////////////////

  Widget complet_Btn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Complete module',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnHeight: 55,
        btnfontsize: 20,
        btnfontweight: fontWeight400,
        btnColor: colorBluePigment,
        borderColor: colorBluePigment,
        onPressed: () {

          // Get.to(()=>Learning_Screens());
          // Navigator.pop(context);
          // (context as Element).reassemble();
        },
      ),
    );
  }
  Widget benarcard(hedingtext, lebletext,image, color){
    return Container(
      width: deviceWidth(context),
      height: 100,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: deviceWidth(context,0.56),
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hedingtext,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: fontFamilyText,
                      color: colorPrimaryColor,
                      fontWeight: fontWeight700,
                      overflow: TextOverflow.ellipsis
                  ),),
                Text(lebletext,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: fontFamilyText,
                      color: colorPrimaryColor,
                      fontWeight: fontWeight400,
                      overflow: TextOverflow.ellipsis
                  ),)
              ],
            ),
          ),
          Container(
            width: deviceWidth(context,0.28),
            child: Image.asset(image,scale: 2.2,),
          ),
        ],
      ),
    );
  }
}
