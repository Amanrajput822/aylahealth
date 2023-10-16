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
  bool isPlayerPlayPause = true;
  bool isPlayerVolume = true;
  bool isPlayerFullScreen = true;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorWhite,
        iconTheme: IconThemeData(
          color: colorBlackRichBlack
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 230,
            width: deviceWidth(context),
            child: Stack(
              children: [
                SizedBox(
                  height: 230,
                  width: deviceWidth(context),
                  child: isReady == true
                      ? Chewie(controller: chewieController)
                      : const Center(child: CircularProgressIndicator()),
                ),
                // SizedBox(
                //   height: 200,
                //   width: deviceWidth(context),
                //   child: Align(
                //     alignment: Alignment.bottomCenter,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         isPlayerPlayPause?IconButton(
                //             onPressed: (){
                //               setState(() {
                //                 isPlayerPlayPause = false;
                //               });
                //               chewieController.play();
                //             },
                //             icon: Icon(Icons.play_arrow,size: 25,)):
                //         IconButton(
                //             onPressed: (){
                //               setState(() {
                //                 isPlayerPlayPause = true;
                //               });
                //               chewieController.pause();
                //             },
                //             icon: Icon(Icons.pause,size: 25,)),
                //         Row(
                //           children: [
                //             isPlayerVolume?IconButton(
                //                 onPressed: (){
                //                   setState(() {
                //                     isPlayerVolume = false;
                //                   });
                //                   chewieController.setVolume(0);
                //                 },
                //                 icon: Icon(Icons.volume_up,size: 25,)):
                //             IconButton(
                //                 onPressed: (){
                //                   setState(() {
                //                     isPlayerVolume = true;
                //                   });
                //                   chewieController.setVolume(1);
                //                 },
                //                 icon: Icon(Icons.volume_off,size: 25,)),
                //             isPlayerFullScreen? IconButton(
                //                 onPressed: (){
                //                   setState(() {
                //                     isPlayerFullScreen = true;
                //                   });
                //                   chewieController.enterFullScreen();
                //                 },
                //                 icon: Icon(Icons.fullscreen,size: 25,)):
                //             IconButton(
                //                 onPressed: (){
                //                   setState(() {
                //                     isPlayerFullScreen = true;
                //                   });
                //                   chewieController.exitFullScreen();
                //                 },
                //                 icon: Icon(Icons.fullscreen_exit,size: 25,)),
                //           ],
                //         ),
                //
                //       ],
                //     ),
                //   ),
                // )
              ],
            ),
          ),

        ],
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
    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse("https://cdn.pixabay.com/vimeo/246463976/atoms-13232.mp4?width=640&hash=4c8703a3f34b289318ae2077bcae4008b1d886da"));
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