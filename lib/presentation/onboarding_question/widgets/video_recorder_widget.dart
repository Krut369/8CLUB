import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/camera_helper.dart';
import '../../../core/widgets/app_button.dart';
import '../onboarding_provider.dart';

class VideoRecorderWidget extends ConsumerStatefulWidget {
  const VideoRecorderWidget({super.key});

  @override
  ConsumerState<VideoRecorderWidget> createState() => _VideoRecorderWidgetState();
}

class _VideoRecorderWidgetState extends ConsumerState<VideoRecorderWidget> {
  VideoPlayerController? _videoController;
  bool _isRecording = false;
  int _seconds = 0;
  Timer? _timer;

  Future<void> _startVideoRecording() async {
    setState(() {
      _isRecording = true;
      _seconds = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });

    await CameraHelper.recordVideo(
      context,
      ref,
      onComplete: (file) async {
        _timer?.cancel();
        setState(() => _isRecording = false);
        ref.read(onboardingProvider.notifier).addVideo(file);

        _videoController = VideoPlayerController.file(file)
          ..initialize().then((_) {
            _videoController!.setLooping(true);
            setState(() {});
          });
      },
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    if (_isRecording) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.input,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.videocam_rounded, color: AppTheme.accent, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recording Video...",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    minHeight: 5,
                    value: (_seconds % 10) / 10,
                    backgroundColor: Colors.white12,
                    color: AppTheme.accent,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _formatTime(_seconds),
              style: const TextStyle(color: AppTheme.grey, fontSize: 13),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.stop_circle_rounded, color: Colors.redAccent, size: 30),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }

    if (state.videoFile != null) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.input,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 120,
                height: 90,
                color: Colors.black,
                child: _videoController != null && _videoController!.value.isInitialized
                    ? Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_videoController!.value.isPlaying) {
                            _videoController!.pause();
                          } else {
                            _videoController!.play();
                          }
                        });
                      },
                      child: Icon(
                        _videoController!.value.isPlaying
                            ? Icons.pause_circle_outline_rounded
                            : Icons.play_circle_outline_rounded,
                        color: Colors.white.withOpacity(0.9),
                        size: 40,
                      ),
                    ),
                  ],
                )
                    : const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.accent,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Video Recorded",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatTime(_seconds),
                    style: const TextStyle(color: AppTheme.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
              onPressed: notifier.deleteVideo,
            ),
          ],
        ),
      );
    }

    return AppButton(
      label: "Record Video",
      icon: Icons.videocam_rounded,
      onPressed: _startVideoRecording,
    );
  }
}
