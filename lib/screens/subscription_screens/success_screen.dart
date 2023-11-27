import 'package:aylahealth/common/styles/const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../common/new_bottombar_screen/New_Bottombar_Screen.dart';

class Success_Screen extends StatelessWidget {
  const Success_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: deviceWidth(context),
        height: deviceheight(context),
        child: Stack(
          children: [
            Container(
              width: deviceWidth(context),
              height: deviceheight(context),
              child: Image.asset('assets/image 1.png',fit: BoxFit.fill,),
            ),
            Container(
              width: deviceWidth(context),
              height: deviceheight(context),
              child:Center(child:
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                color: HexColor('#F2F2F2').withOpacity(0.8),
                child: Container(
                  width: deviceWidth(context,0.7),
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.only(top: 10,bottom: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [

                      Text('You’re all set',style: TextStyle(
                        fontSize: 17,
                        fontFamily: fontFamilyText,
                        color: colorBlack,
                        fontWeight: fontWeight600,
                      )),
                      Text('Your purchase was successful.',style: TextStyle(
                        fontSize: 13,
                        fontFamily: fontFamilyText,
                        color: colorBlack,
                        fontWeight: fontWeight400,
                      )),

                      Divider(
                        color: colorgrey,
                        thickness: 1,
                      ),

                      InkWell(
                        onTap: (){
                          Get.offAll(() => New_Bottombar_Screen());
                        },
                        child: Text('Proceed',style: TextStyle(
                          fontSize: 17,
                          fontFamily: fontFamilyText,
                          color: HexColor('#007AFF'),
                          fontWeight: fontWeight600,
                        )),
                      ),

                    ],
                  ),
                ),
              )),
            )
          ],
        ),
      ),
    );
  }
}
