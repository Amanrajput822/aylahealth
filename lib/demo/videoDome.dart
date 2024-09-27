import 'package:aylahealth/common/styles/const.dart';
import 'package:flutter/material.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DemoVideo extends StatefulWidget {
  const DemoVideo({super.key});

  @override
  DemoVideoState createState() => DemoVideoState();
}

class DemoVideoState extends State<DemoVideo> {
  /// also support url like this: 'www.vimeo.com/70591644', 'vimeo.com/70591644'
  // final String _vimeoVideoUrl = 'https://vimeo.com/70591644';
 // final String vimeoUrl = "https://vimeo.com/111698718";
   final String vimeoUrl = "https://vimeo.com/868671353?share=copy";
  // final String vimeoUrl = "https://vimeo.com/845468860?share=copy";

  String videoId = '111698718';
   String getCleanVimeoUrl(String url) {
     final uri = Uri.parse(url);
     final regex = RegExp(r"vimeo\.com/(\d+)");
     final match = regex.firstMatch(uri.path);
     return match != null ? 'https://vimeo.com/${match.group(1)}' : url;
   }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: WebView(
        initialUrl: getCleanVimeoUrl(vimeoUrl),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}