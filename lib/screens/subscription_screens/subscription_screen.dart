import 'package:aylahealth/common/styles/const.dart';
import 'package:aylahealth/screens/subscription_screens/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../common/commonwidgets/button.dart';
import '../../common/new_bottombar_screen/New_Bottombar_Screen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool box1 = false;
  bool box2 = false;
  bool box3 = false;
  bool buttoncolor = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: Container(
        width: deviceWidth(context),
        height: deviceheight(context),
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizedboxheight(deviceheight(context,0.1)),
              Align(
                alignment: Alignment.center,
                child: Text('Subscription',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Playfair Display',
                    color: colorPrimaryColor,
                    fontWeight: fontWeight500,
                  ),
                ),
              ),
              sizedboxheight(deviceheight(context,0.05)),
              Text('Choose your subscription level to unlock premium features.',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: fontFamilyText,
                  color: colorRichblack,
                  fontWeight: fontWeight400,
                ),
                textAlign: TextAlign.start,
              ),
              sizedboxheight(deviceheight(context,0.02)),
              InkWell(
                  onTap: (){
                    setState(() {
                       box1 = true;
                       box2 = false;
                       box3 = false;
                       buttoncolor = true;
                    });
                  },
                  child: _card1('Annual',
                      '299.00',
                      '24.92/month, billed annually.',
                      'Best value!',
                      box1? HexColor('#A7E4F2'):  HexColor('#F6F8F9'))),
              sizedboxheight(deviceheight(context,0.01)),
              InkWell(
                  onTap: (){
                    setState(() {
                      box1 = false;
                      box2 = true;
                      box3 = false;
                      buttoncolor = true;
                    });
                  },
                  child: _card1('Quarterly',
                      '79.00',
                      '26.33/month, billed quarterly.',
                      'Most popular!' ,
                      box2? HexColor('#A7E4F2'):  HexColor('#F6F8F9'))),
              sizedboxheight(deviceheight(context,0.01)),
              InkWell(
                  onTap: (){
                    setState(() {
                      box1 = false;
                      box2 = false;
                      box3 = true;
                      buttoncolor = true;
                    });
                  },
                  child: _card1('Monthly',
                      '29.00',
                      '29.00/month, billed monthly.', '',
                      box3? HexColor('#A7E4F2'): HexColor('#F6F8F9')))    ,          sizedboxheight(deviceheight(context,0.02)),
              joinBtn(context),
              sizedboxheight(deviceheight(context,0.02)),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: (){
                    Get.offAll(() => New_Bottombar_Screen());
                  },
                  child: Text('Sign up later',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: fontFamilyText,
                      color: colorBluePigment,
                      fontWeight: fontWeight400,
                    ),
                  ),
                ),
              ),
              sizedboxheight(deviceheight(context,0.1)),

              Align(
                alignment:Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Terms of use',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: fontFamilyText,
                        color: colorShadowBlue,
                        fontWeight: fontWeight400,
                      ),
                    ),
                    Text('Privacy & cookies',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: fontFamilyText,
                        color: colorShadowBlue,
                        fontWeight: fontWeight400,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _card1( sub_type, amount, timepireod ,  value , boxcolor){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
            color:  boxcolor,
            // color:  HexColor('#F6F8F9'),
            borderRadius: BorderRadius.circular(5)
        ),
        padding: EdgeInsets.all(10),
        width: deviceWidth(context),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(sub_type.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: fontFamilyText,
                    color: colorRichblack,
                    fontWeight: fontWeight700,
                  ),
                ),
                Text('\$${amount.toString()}',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: fontFamilyText,
                    color: colorRichblack,
                    fontWeight: fontWeight600,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${timepireod.toString()}',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: fontFamilyText,
                    color: colorRichblack,
                    fontWeight: fontWeight400,
                  ),
                ),
                value ==''?Container(): Container(
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: Text(value,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: fontFamilyText,
                          color: colorRichblack,
                          fontWeight: fontWeight400,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }




  Widget joinBtn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Join now!',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnColor:buttoncolor? colorEnabledButton:colorShadowBlue,
        onPressed: () {
          if(buttoncolor){
            bottomsheetmodel();
          }
        //  Get.to(() => Pre_Question_Screen());
        },
      ),
    );
  }
  Future bottomsheetmodel(){
    return   showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      // color is applied to main screen when modal bottom screen is displayed
      //background color for modal bottom screen
      backgroundColor: HexColor('#EBEBEB'),
      //elevates modal bottom screen
      elevation: 10,
      // gives rounded corner to modal bottom screen
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        // UDE : SizedBox instead of Container for whitespaces
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/Pay.png',width: 70),
                    InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset('assets/Close Button Light.svg')),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(

                  decoration: BoxDecoration(
                      color: colorWhite,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                                Image.asset('assets/Card Icon.png',
                                  width: deviceWidth(context,0.1),),

                          sizedboxwidth(deviceWidth(context,0.04)),
                          Container(
                            width: deviceWidth(context,0.6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Apple Card',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'SP Fonts',
                                    color: colorBlack,
                                    fontWeight: fontWeight400,
                                  ),),
                                Text('•••• 1234',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'SP Fonts',
                                      color: HexColor('#3C3C43').withOpacity(0.6),
                                      fontWeight: fontWeight400,
                                      overflow: TextOverflow.ellipsis
                                  ),
                                  maxLines: 1,
                                ),
                                Text('27 Fredrick Butte Rd, Brothers ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'SP Fonts',
                                      color: HexColor('#3C3C43').withOpacity(0.6),
                                      fontWeight: fontWeight400,
                                      overflow: TextOverflow.ellipsis
                                  ),
                                  maxLines: 1,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),

                    Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/Vector.svg',
                                  width: deviceWidth(context,0.1),height: 20,),
                              ],

                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                color: colorWhite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Divider(
                      height: 0.5,
                      color: HexColor('#C6C6C8'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              Get.to(() => Success_Screen());
                            },
                            child: Container(
                              width: deviceWidth(context,0.7),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Pay PACSUN',style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'SP Fonts',
                                    color: HexColor('#3C3C43').withOpacity(0.6),
                                    fontWeight: fontWeight400,
                                  )),
                                  Text('\$85.00',style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'SP Fonts',
                                    color: colorBlack,
                                    fontWeight: fontWeight400,
                                  )),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/Vector.svg',
                                    width: deviceWidth(context,0.1),height: 20,),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0.5,
                      color: HexColor('#C6C6C8'),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          SvgPicture.asset('assets/Glyph - Confirm with Button.svg',),

                          Text('Confirm with Side Button',style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'SP Fonts',
                            color: colorBlack,
                            fontWeight: fontWeight400,
                          )),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
