import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecorderHelper {
  static Future<FlutterSoundRecorder> initRecorder() async {
    final mic = await Permission.microphone.request();
    if (!mic.isGranted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    final recorder = FlutterSoundRecorder();
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 100));
    return recorder;
  }

  static Future<String> _getFilePath(String prefix, String ext) async {
    final dir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory('${dir.path}/onboarding_media');
    if (!await mediaDir.exists()) await mediaDir.create(recursive: true);
    return '${mediaDir.path}/${prefix}_${DateTime.now().millisecondsSinceEpoch}.$ext';
  }

  static Future<String> start(FlutterSoundRecorder recorder) async {
    final path = await _getFilePath('audio', 'aac');
    await recorder.startRecorder(
      toFile: path,
      codec: Codec.aacADTS,
    );
    return path;
  }

  static Future<String?> stop(FlutterSoundRecorder recorder) async {
    try {
      return await recorder.stopRecorder();
    } catch (e) {
      return null;
    }
  }

  static Future<void> dispose(FlutterSoundRecorder recorder) async {
    try {
      await recorder.closeRecorder();
    } catch (_) {}
  }
}
