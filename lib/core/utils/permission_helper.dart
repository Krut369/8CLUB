import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestMicPermission() async {
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestAll() async {
    final mic = await requestMicPermission();
    final cam = await requestCameraPermission();
    return mic && cam;
  }
}
