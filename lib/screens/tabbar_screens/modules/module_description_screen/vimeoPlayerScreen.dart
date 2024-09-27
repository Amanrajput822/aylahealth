import 'package:aylahealth/common/styles/const.dart';
import 'package:flutter/material.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

class VimeoVideoPlayerScreen extends StatefulWidget {
  String? videoId;
   VimeoVideoPlayerScreen({super.key, required this.videoId});

  @override
  VimeoVideoPlayerScreenState createState() => VimeoVideoPlayerScreenState();
}

class VimeoVideoPlayerScreenState extends State<VimeoVideoPlayerScreen> {
  /// also support url like this: 'www.vimeo.com/70591644', 'vimeo.com/70591644'
  // final String _vimeoVideoUrl = 'https://vimeo.com/70591644';

 // String videoId = '845468860';
// String videoId = '106110350';
 //   String videoId = '111698718';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorWhite,
      body: AspectRatio(
        aspectRatio: 630/357,
        child: VimeoPlayer(
          videoId: widget.videoId!.trim(),
        ),
      ),
    );
  }
}