import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class MediaPlayerView extends StatefulWidget {
  const MediaPlayerView(this.url, {Key? key}) : super(key: key);
  final String url;


  @override
  State<MediaPlayerView> createState() => _MediaPlayerViewState();
}

class _MediaPlayerViewState extends State<MediaPlayerView> {
  BetterPlayerController? controller;
  final GlobalKey _betterPlayerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

  }

  void resumePlayer() {
    controller = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        fit: BoxFit.contain,
        fullScreenByDefault: false,
        allowedScreenSleep: true,
        autoDetectFullscreenDeviceOrientation: true,
        autoDetectFullscreenAspectRatio: true,
        errorBuilder: errorBuilder,
        // routePageBuilder: routePageBuilder,
        // eventListener: pipModeListener,
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.url,
        liveStream: true,
        notificationConfiguration: true
            ? const BetterPlayerNotificationConfiguration(
          showNotification: true,
          title: "HuYa",
          author: "LCK",
          imageUrl: "LCK",
          activityName: "MainActivity",
        )
            : null,
      ),
    );
    controller?.setControlsEnabled(false);
    setState(() {});
  }




  Widget errorBuilder(BuildContext context, String? errorMessage) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '无法播放直播',
            style: TextStyle(color: Colors.white),
          ),
          TextButton(
            onPressed: resumePlayer,
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LCK'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 300,
            child: BetterPlayer(
              key: _betterPlayerKey,
              controller: controller!,
            ),
          ),
          Expanded(
            child: ListView(),
          ),
        ],
      ),
    );
  }
}
