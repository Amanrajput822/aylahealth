import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../common/commonwidgets/button.dart';
import '../../../../../common/styles/const.dart';

class VideoAppointment extends StatefulWidget {
  const VideoAppointment({Key? key}) : super(key: key);

  @override
  State<VideoAppointment> createState() => _VideoAppointmentState();
}

class _VideoAppointmentState extends State<VideoAppointment> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    // #docregion webview_controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.google.co.in/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://ayla-health.au3.cliniko.com/bookings#service'));
    // #enddocregion webview_controller
  }

  @override
  Widget build(BuildContext context) {
    return    Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor:  colorWhite,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },icon:  Icon(Icons.arrow_back_ios_new,color: colorRichblack,size: 20),),
      ),
      body:Container(
          width: deviceWidth(context),
          height: (Platform.isIOS)?deviceheight(context,0.75):deviceheight(context,0.83),
          child: WebViewWidget(controller: controller))
      // Container(
      //   width: deviceWidth(context),
      //   height: deviceheight(context),
      //   child: SingleChildScrollView(
      //     physics: const NeverScrollableScrollPhysics(),
      //
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //
      //         Text("Book a video consultation",
      //           style: TextStyle(
      //             fontSize: 24,
      //             fontFamily: fontFamilyText,
      //             color: colorRichblack,
      //             fontWeight: fontWeight600,
      //           ),).paddingOnly(left: 20.0,right: 20),
      //
      //         sizedboxheight(10.0),
      //         Text("See a dietitian for personalised advice with food & nutrition.",
      //           style: TextStyle(
      //             fontSize: 14,
      //             fontFamily: fontFamilyText,
      //             color: colorSlateGray,
      //             fontWeight: fontWeight400,
      //           ),).paddingOnly(left: 20.0,right: 20),
      //         sizedboxheight(20.0),
      //         Card(
      //           elevation: 2,
      //           shape: const RoundedRectangleBorder(
      //               borderRadius: BorderRadius.only(
      //                   topLeft: Radius.circular(15),
      //                   topRight: Radius.circular(15)
      //               )
      //
      //           ),
      //           child: Container(
      //             width: deviceWidth(context),
      //             height: deviceheight(context,0.75),
      //             padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
      //             child: SingleChildScrollView(
      //               physics: const ScrollPhysics(),
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text("Select a service",
      //                     style: TextStyle(
      //                       fontSize: 16,
      //                       fontFamily: fontFamilyText,
      //                       color: colorRichblack,
      //                       fontWeight: fontWeight400,
      //                     ),),
      //                   sizedboxheight(5.0),
      //                   Text("Prices are inclusive of tax, if tax is applicable",
      //                     style: TextStyle(
      //                       fontSize: 14,
      //                       fontFamily: fontFamilyText,
      //                       color: colorSlateGray,
      //                       fontWeight: fontWeight400,
      //                     ),),
      //                   sizedboxheight(20.0),
      //                   ListView.builder(
      //                       itemCount: 5,
      //                       shrinkWrap: true,
      //                       physics: const NeverScrollableScrollPhysics(),
      //                       itemBuilder: (BuildContext context,int index){
      //                         return Container(
      //                           padding: const EdgeInsets.only(bottom: 15),
      //                           child: ExpansionTile(
      //                             shape: RoundedRectangleBorder(
      //                               borderRadius: BorderRadius.circular(0.0),
      //                             ),
      //                             collapsedShape:RoundedRectangleBorder(
      //                               borderRadius: BorderRadius.circular(0.0),
      //                             ) ,
      //                             backgroundColor: HexColor("#4E514C"),
      //                             collapsedBackgroundColor: HexColor("#4E514C"),
      //
      //                             iconColor: colorWhite,
      //                             collapsedIconColor: colorWhite,
      //                             title:Text('Body Scan',
      //                                 style: TextStyle(
      //                                     fontSize: 16,
      //                                     fontFamily: fontFamilyText,
      //                                     color: colorWhite,
      //                                     height: 1.6,
      //                                     fontWeight: fontWeight600,
      //
      //                                 )),
      //
      //                             // Contents
      //                             children: [
      //                               Container(
      //                                 color: colorWhite,
      //                                 child:Padding(
      //                                   padding: const EdgeInsets.all(15.0),
      //                                   child: Text("Do you love eating chocolate? Do you constantly "
      //                                       "find yourself trying to stop eating it, only to lose control "
      //                                       "later? A positive action that you can take right now, "
      //                                       "is to allow yourself to eat it and enjoy it with a whole food: "
      //                                       "Add nuts and seeds and make a trial mix."
      //                                       " Dip your fruit like mandarins, banana and strawberries in melted chocolate",
      //                                     style: TextStyle(
      //                                       fontSize: 14,
      //                                       fontFamily: fontFamilyText,
      //                                       color: HexColor('#3B4250'),
      //                                       height: 1.6,
      //                                       fontWeight: fontWeight400,
      //
      //                                     ),
      //                                   ),
      //                                 ),
      //                               )
      //
      //
      //                             ],
      //                           ),
      //                         );
      //                       }),
      //
      //                 ],
      //               ),
      //             ),
      //           ).paddingAll(20),
      //         ),
      //
      //
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

}
