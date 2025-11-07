import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class CameraHelper {
  static Future<void> recordVideo(
      BuildContext context,
      dynamic ref, {
        required Function(File file) onComplete,
      }) async {
    CameraController? controller;
    Timer? timer;

    try {
      final cameraPermission = await Permission.camera.request();
      final micPermission = await Permission.microphone.request();
      if (!cameraPermission.isGranted || !micPermission.isGranted) return;

      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: true,
      );

      await controller.initialize();

      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';

      await controller.startVideoRecording();

      int seconds = 0;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          bool isStopping = false;
          bool isDisposed = false;

          return StatefulBuilder(
            builder: (context, setStateDialog) {
              timer ??= Timer.periodic(const Duration(seconds: 1), (_) {
                if (!isStopping) {
                  setStateDialog(() => seconds++);
                }
              });

              Widget previewWidget;
              if (controller != null &&
                  controller.value.isInitialized &&
                  !isStopping &&
                  !isDisposed) {
                previewWidget = AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: CameraPreview(controller),
                );
              } else {
                previewWidget = const SizedBox(
                  height: 600,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }

              return AlertDialog(
                backgroundColor: Colors.black,
                contentPadding: const EdgeInsets.all(8),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    previewWidget,
                    const SizedBox(height: 10),
                    Text(
                      "Recording: ${seconds.toString().padLeft(2, '0')}s",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.stop, color: Colors.white),
                      label: const Text(
                        "Stop Recording",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: isStopping
                          ? null
                          : () async {
                        isStopping = true;
                        timer?.cancel();
                        try {
                          if (controller != null &&
                              controller.value.isRecordingVideo) {
                            final xFile =
                            await controller.stopVideoRecording();
                            onComplete(File(xFile.path));
                          }
                        } catch (e) {
                          debugPrint('⚠️ Stop video failed: $e');
                        }
                        if (context.mounted) Navigator.pop(context);
                        Future.delayed(
                          const Duration(milliseconds: 350),
                              () async {
                            try {
                              if (controller != null &&
                                  controller.value.isInitialized) {
                                isDisposed = true;
                                await controller.dispose();
                              }
                            } catch (e) {
                              debugPrint('⚠️ Dispose error: $e');
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      );

      timer?.cancel();
      await Future.delayed(const Duration(milliseconds: 350));
      if (controller != null && controller.value.isInitialized) {
        await controller.dispose();
      }
    } catch (e) {
      debugPrint('🎥 CameraHelper recordVideo error: $e');
    } finally {
      try {
        timer?.cancel();
        if (controller != null && controller.value.isInitialized) {
          await controller.dispose();
        }
      } catch (_) {}
    }
  }
}
