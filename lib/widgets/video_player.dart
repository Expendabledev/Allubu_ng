import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    final tag = videoUrl;

    if (!Get.isRegistered<VideoController>(tag: tag)) {
      Get.put(VideoController(videoUrl), tag: tag);
    }

    return GetX<VideoController>(
      tag: tag,
      builder: (controller) {
        if (!controller.isInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: controller.videoPlayerController.value.aspectRatio,
              child: VideoPlayer(controller.videoPlayerController),
            ),
            IconButton(
              icon: Icon(
                controller.isPlaying.value ? Icons.pause_circle : Icons.play_circle,
                size: 48,
                color: Colors.white,
              ),
              onPressed: controller.togglePlay,
            ),
          ],
        );
      },
    );
  }
}

class VideoController extends GetxController {
  late final VideoPlayerController videoPlayerController;
  final isInitialized = false.obs;
  final isPlaying = false.obs;

  final String videoUrl;

  VideoController(this.videoUrl);

  @override
  void onInit() {
    super.onInit();

    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

    videoPlayerController.initialize().then((_) {
      if (!videoPlayerController.value.isInitialized) return;

      isInitialized.value = true;
      play();
      videoPlayerController.setLooping(true);

      videoPlayerController.addListener(() {
        if (videoPlayerController.value.isInitialized) {
          isPlaying.value = videoPlayerController.value.isPlaying;
        }
      });
    }).catchError((e) {
      debugPrint('Video initialization error: $e');
    });
  }

  void togglePlay() {
    if (videoPlayerController.value.isPlaying) {
      pause();
    } else {
      play();
    }
  }

  void play() {
    try {
      videoPlayerController.play();
      isPlaying.value = true;
    } catch (e) {
      debugPrint('Play error: $e');
    }
  }

  void pause() {
    try {
      videoPlayerController.pause();
      isPlaying.value = false;
    } catch (e) {
      debugPrint('Pause error: $e');
    }
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    super.onClose();
  }
}