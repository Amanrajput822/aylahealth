import 'package:aylahealth/screens/tabbar_screens/modules/module_description_screen/module_description_screen.dart';
import 'package:aylahealth/screens/tabbar_screens/support_screen/video_appoinment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../../../../../common/commonwidgets/button.dart';
import '../../../../../common/styles/const.dart';
import '../modules/module_description_screen/HomeWidget.dart';
import '../modules/module_description_screen/ModuleDescriptionProvider.dart';
import 'message/chat/chat_list.dart';


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
        title:  Text("Get support",
          style: TextStyle(
              fontSize: 30,
              fontFamily: 'Playfair Display',
              color: colorPrimaryColor,
              fontWeight: fontWeight500,
              overflow: TextOverflow.ellipsis
          ),),
        // leading: IconButton(onPressed: (){
        //   // Get.back();
        // },icon:  Icon(Icons.arrow_back_ios_new,color: colorRichblack,size: 20),),
      ),
      body: Container(
        width: deviceWidth(context),
        height: deviceheight(context),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              sizedboxheight(10.0),
              Text("Nutrition advice is best when it’s individualised. Check in with a dietitian on our team for one-on-one support.",
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
                child: SizedBox(
                  height: deviceheight(context,0.75),
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
                        // sizedboxheight(20.0),
                        // benarcard('Book a video appointment','For complex challenges or questions',
                        //     'assets/VideoConsultations.png', HexColor('#D4F1FA'),(){
                        //       //  Get.to(()=>VideoAppointment());
                        //       PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        //         context,
                        //         settings: const RouteSettings(name: "/Support"),
                        //         screen:  VideoAppointment(),
                        //       );
                        //     }),
                        // sizedboxheight(20.0),
                        // benarcard('Live Chat','A quick answer for nutrition questions',
                        //     'assets/LiveChat.png', HexColor('#D4F1FA'),
                        //         (){
                        //       // Get.to(()=>ChatListScreen());
                        //
                        //       PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        //         context,
                        //         settings: const RouteSettings(name: "/Support"),
                        //         screen:  ChatListScreen(),
                        //       );
                        //     }),
                        sizedboxheight(20.0),
                        benarcard('Book a Video Appointment','For quality one-on-one coaching',
                            'assets/banner_icon/VideoConsultations.png', HexColor('#D0EEB2'),(){
                              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                settings: const RouteSettings(name: "/Support"),
                                screen:  VideoAppointment(),
                              );
                            }),
                        sizedboxheight(20.0),
                        benarcard('Live Chat','Ask a nutrition question for a quick answer from our team',
                            'assets/banner_icon/LiveChat.png', HexColor('#EC90AC'),
                             (){
                                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                                context,
                                settings: const RouteSettings(name: "/Support"),
                                screen:  ChatListScreen(),
                              );
                            }),
                        sizedboxheight(20.0),
                        Container(
                          width: deviceWidth(context),

                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1.5,
                                  color: colorSlateGray,
                                ),
                              ),
                              sizedboxwidth(8.0),
                              Expanded(
                                flex: 3,
                                child: Container(

                                  child: Text('For tech support please head to the ‘Help’ section in your profile.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: fontFamilyText,
                                    fontWeight: fontWeight400,
                                    color: colorSlateGray
                                  ),)
                                ),
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

                       // complet_Btn(context)
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
  // /// next button //////////////////
  //
  // Widget complet_Btn(context) {
  //   return Container(
  //     alignment: Alignment.center,
  //     child: Button(
  //       buttonName: 'Complete module',
  //       textColor: colorWhite,
  //       borderRadius: BorderRadius.circular(8.00),
  //       btnWidth: deviceWidth(context),
  //       btnHeight: 55,
  //       btnfontsize: 20,
  //       btnfontweight: fontWeight400,
  //       btnColor: colorBluePigment,
  //       borderColor: colorBluePigment,
  //       onPressed: () {
  //         final DescriptionScreenData = Provider.of<ModulesDescriptionScreenProvider>(context, listen: false);
  //          DescriptionScreenData.buttonTypeFunction('Completed');
  //         // Get.off(()=>ModuleDescriptionScreen());
  //         Navigator.pop(context);
  //         // (context as Element).reassemble();
  //       },
  //     ),
  //   );
  // }

  Widget benarcard(hedingtext, lebletext,image, color,Function action){
    return InkWell(
      onTap: () => action() ,
      child: Container(
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
        width: deviceWidth(context,0.3),
        height: 100,
        child: Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Positioned(
                  left: 3,
                  top: 3,
                  child: Image.asset('assets/CircleImage.png',height: 65,)),
              Image.asset(image,height: 70),
            ],
          ),
        ),
      ),
          ],
        ),
      ),
    );
  }
}
