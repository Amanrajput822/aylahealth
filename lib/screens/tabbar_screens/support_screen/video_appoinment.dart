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
  late WebViewController _controller;
  bool isLoading = true;

  bool loader = false;
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return    Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:  colorWhite,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },icon:  Icon(Icons.arrow_back_ios_new,color: colorRichblack,size: 20),),
      ),
      body:Container(
        color: colorWhite,
        width: deviceWidth(context),
        height: (Platform.isIOS)?deviceheight(context,0.75):deviceheight(context,0.83),
        child: Column(
          children: [
            Visibility(
              visible: isLoading,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            ),
            Expanded(
              child: WebView(backgroundColor: colorWhite,
                initialUrl: 'https://ayla-health.au3.cliniko.com/bookings#service',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller = webViewController;
                },
                onPageFinished: (String url) {
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            )
          ],
        ),
      ),


    );
  }

}
