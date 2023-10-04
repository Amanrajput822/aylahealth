import 'package:aylahealth/common/styles/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class HomeWidget extends StatefulWidget {
  @override
  _VideoWidget createState() => _VideoWidget();
}

class _VideoWidget extends State<HomeWidget> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  bool isReady = false;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorWhite,
      child: SafeArea(
        child: Scaffold(
          body: Container(

            child: Column(
              children: [
                Container(
                  height: 200,
                  width: deviceWidth(context),
                  child: isReady == true
                      ? Chewie(controller: chewieController)
                      : const Center(child: CircularProgressIndicator()),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: (){
                          chewieController.play();
                        },
                        icon: Icon(Icons.play_circle_outline,size: 55,))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController.videoPlayerController.dispose();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.network(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4");
    await Future.wait([videoPlayerController.initialize()]);

    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: false,
        aspectRatio: 16 / 9,
        autoInitialize: true);

    setState(() {
      isReady = true;
    });

    chewieController.addListener(() {
      if (!chewieController.isFullScreen) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
    });
  }
}