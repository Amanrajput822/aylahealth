import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../common/commonwidgets/button.dart';
import '../../../../../common/styles/const.dart';
import 'complete_applying_screen.dart';

class ApplyingScreen extends StatefulWidget {
  const ApplyingScreen({Key? key}) : super(key: key);

  @override
  State<ApplyingScreen> createState() => _ApplyingScreenState();
}

class _ApplyingScreenState extends State<ApplyingScreen> {
  var screenNumber = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorWhite,
      width: deviceWidth(context),
      height: deviceheight(context),
      child: SafeArea(
        top: true,
        child: Scaffold(
          body:Stack(
            children: [
              /// 3 ///
             if(screenNumber == 3)Container(
                width: deviceWidth(context),
                height: deviceheight(context),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60,
                        child: IconButton(onPressed: (){
                          setState(() {
                            screenNumber =2;
                          });

                        },icon: const Icon(Icons.arrow_back_ios_new,size: 20),),
                      ),
                      SingleChildScrollView(
                        physics: const ScrollPhysics(),
                        padding: const EdgeInsets.only(left: 20.0,right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text("Try these foods",
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: fontFamilyText,
                                color: colorRichblack,
                                fontWeight: fontWeight600,
                              ),),

                            sizedboxheight(10.0),
                            Text("See how many of these foods you can add in!",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: fontFamilyText,
                                color: HexColor('#3B4250'),
                                fontWeight: fontWeight400,
                              ),),
                            sizedboxheight(20.0),
                            GridView(
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 2,
                              ),
                              scrollDirection: Axis.vertical,
                              children: [
                                Image.asset('assets/apple_image.png'),
                                Image.asset('assets/apple_image.png'),
                                Image.asset('assets/apple_image.png'),
                                Image.asset('assets/apple_image.png'),
                                Image.asset('assets/apple_image.png'),
                                Image.asset('assets/apple_image.png'),
                                Image.asset('assets/apple_image.png'),
                                Image.asset('assets/apple_image.png'),
                                Image.asset('assets/apple_image.png'),

                              ],
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /// 2 ///
              if(screenNumber == 2) Container(
                width: deviceWidth(context),
                height: deviceheight(context),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        child: IconButton(onPressed: (){
                          setState(() {
                            screenNumber =1;
                          });
                        },icon: const Icon(Icons.arrow_back_ios_new,size: 20),),
                      ),
                      SingleChildScrollView(
                        physics: const ScrollPhysics(),
                        padding: const EdgeInsets.only(left: 20.0,right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text("Try these habits",
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: fontFamilyText,
                                color: colorRichblack,
                                fontWeight: fontWeight600,
                              ),),

                            sizedboxheight(10.0),
                            ListView.builder(
                                itemCount: 5,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context,int index){
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: ExpansionTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      collapsedShape:RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ) ,
                                      backgroundColor: HexColor('#E9ECF1'),
                                      collapsedBackgroundColor: HexColor('#E9ECF1'),

                                      iconColor:  HexColor('#3B4250'),
                                      title: Row(
                                        children: [
                                          Text('${index + 1}.', style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: fontFamilyText,
                                              color: HexColor('#3B4250'),
                                              height: 1.6,
                                              fontWeight: fontWeight600,
                                              overflow: TextOverflow.ellipsis
                                          )),
                                          sizedboxwidth(10.0),
                                          Container(
                                            width: deviceWidth(context,0.6),
                                            child: Text('Add nuts, seeds or fruit to chocolate ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: fontFamilyText,
                                                  color: HexColor('#3B4250'),
                                                  height: 1.6,
                                                  fontWeight: fontWeight600,
                                                  overflow: TextOverflow.ellipsis
                                              ),maxLines: 2,),
                                          ),
                                        ],
                                      ),
                                      // Contents
                                      children: [
                                        Container(
                                          color: colorWhite,
                                          child:Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text("Do you love eating chocolate? Do you constantly "
                                                "find yourself trying to stop eating it, only to lose control "
                                                "later? A positive action that you can take right now, "
                                                "is to allow yourself to eat it and enjoy it with a whole food: "
                                                "Add nuts and seeds and make a trial mix."
                                                " Dip your fruit like mandarins, banana and strawberries in melted chocolate",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: fontFamilyText,
                                                color: HexColor('#3B4250'),
                                                height: 1.6,
                                                fontWeight: fontWeight400,

                                              ),
                                            ),
                                          ),
                                        )


                                      ],
                                    ),
                                  );
                                }),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /// 1 ///
              if(screenNumber == 1)  Container(
                width: deviceWidth(context),
                height: deviceheight(context),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
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
                      SingleChildScrollView(
                        physics: const ScrollPhysics(),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text("Take action",
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: fontFamilyText,
                                color: colorRichblack,
                                fontWeight: fontWeight600,
                              ),),

                            sizedboxheight(10.0),
                            Text("Eating a healthy diet is one of several major "
                                "lifestyle factors that influence our health."
                                " Eating well ensures we meet our body’s energy and "
                                "nutrient needs to grow, develop and repair. "
                                "Healthy eating also reduces the risk of heart disease, "
                                "diabetes, and cancer or slows the progression of these diseases.",
                              style: TextStyle(
                                fontSize: 16,height: 1.8,
                                fontFamily: fontFamilyText,
                                color: HexColor('#3B4250'),
                                fontWeight: fontWeight400,
                              ),),


                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: deviceWidth(context,0.04),
                  right: deviceWidth(context,0.04),
                  child: Next_Btn(context))
            ],
          )

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

          setState(() {
            print(screenNumber);
            if(screenNumber == 1){
              screenNumber = 2;
            }else if(screenNumber==2){
              screenNumber =3;
            }
            else if(screenNumber==3){
              Get.to(()=>const CompleteApplyingScreen());

            }
          });

          // Get.to(()=>Learning_Screens());
          // Navigator.pop(context);
          // (context as Element).reassemble();
        },
      ),
    );
  }
}
