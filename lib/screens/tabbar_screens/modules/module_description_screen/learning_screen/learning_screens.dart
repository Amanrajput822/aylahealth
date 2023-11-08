import 'package:aylahealth/common/styles/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../../common/commonwidgets/button.dart';
import '../ModuleDescriptionProvider.dart';

class Learning_Screens extends StatefulWidget {
  const Learning_Screens({Key? key}) : super(key: key);

  @override
  State<Learning_Screens> createState() => _Learning_ScreensState();
}

class _Learning_ScreensState extends State<Learning_Screens> {

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

                          Text("Liberalise Your Diet",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: fontFamilyText,
                              color: colorRichblack,
                              fontWeight: fontWeight600,
                            ),),

                          sizedboxheight(10.0),
                          Text("Free to eat a wide range of foods, free to build a healthy eating pattern that suits you and free to enjoy the foods you love. If you don’t feel like this now, stick with this pathway and you won’t believe how good you’ll feel by the time you’re done.",
                            style: TextStyle(
                            fontSize: 16,height: 1.5,
                            fontFamily: fontFamilyText,
                            color: HexColor('#3B4250'),
                            fontWeight: fontWeight400,
                          ),),

                          sizedboxheight(20.0),
                          Next_Btn(context),

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
  /// next button //////////////////

  Widget Next_Btn(context) {
    return Container(
      alignment: Alignment.center,
      child: Button(
        buttonName: 'Next',
        textColor: colorWhite,
        borderRadius: BorderRadius.circular(8.00),
        btnWidth: deviceWidth(context),
        btnHeight: 55,
        btnfontsize: 20,
        btnfontweight: fontWeight400,
        btnColor: colorBluePigment,
        borderColor: colorBluePigment,
        onPressed: () {

          final DescriptionScreenData = Provider.of<ModulesDescriptionScreenProvider>(context, listen: false);
          DescriptionScreenData.buttonTypeFunction('Start Applying');
         // Get.to(()=>Learning_Screens());
         //  Get.off(()=>ModuleDescriptionScreen());
          Navigator.pop(context);
          // (context as Element).reassemble();
        },
      ),
    );
  }
}
