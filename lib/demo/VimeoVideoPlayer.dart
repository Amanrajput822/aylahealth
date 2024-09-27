import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VimeoVideoPlayer extends StatefulWidget {


  const VimeoVideoPlayer();

  @override
  _VimeoVideoPlayerState createState() => _VimeoVideoPlayerState();
}

class _VimeoVideoPlayerState extends State<VimeoVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    // URL for the iframe src
    final String videoUrl = 'https://player.vimeo.com/video/${111698718}?loop=0&autoplay=0';

    return WebView(
      initialUrl: Uri.dataFromString(
        '''
   <iframe src="https://player.vimeo.com/video/106110350?autoplay=1&loop=1&autopause=0" width="100%" height="500" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>
        ''',
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString(),
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}