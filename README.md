---

# 🎙️ Onboarding Media Recorder (Flutter + Riverpod)

This module provides a **fully functional onboarding media recording system** for Flutter apps.
It supports **audio recording, video recording, and text input**, integrated with **Riverpod** state management and the **Camera** and **Flutter Sound** packages.

---

## 🚀 Features

✅ Record **audio** using the device microphone
✅ Record **video** using the device camera
✅ Display **live recording status**, timers, and progress bars
✅ Save files locally using `path_provider`
✅ Manage permissions using `permission_handler`
✅ Preview recorded media (play/pause for video)
✅ Integrated with **Riverpod provider** for state updates
✅ Custom UI with consistent theming via `AppTheme`

---

## 🧩 Folder Structure

```
lib/
├── core/
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── recorder_helper.dart
│   │   └── camera_helper.dart
│   ├── widgets/
│   │   └── app_button.dart
│   └── permission/
│       └── permission_helper.dart
│
├── features/
│   └── onboarding/
│       ├── onboarding_provider.dart
│       ├── widgets/
│       │   ├── audio_recorder_widget.dart
│       │   ├── video_recorder_widget.dart
│       │   └── media_preview_widget.dart
│       └── components/
│           └── next_button.dart
```

---

## ⚙️ Dependencies

Add these packages in your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  camera: ^0.11.0+1
  video_player: ^2.9.1
  flutter_sound: ^9.4.13
  path_provider: ^2.1.3
  permission_handler: ^11.3.1
```

Then run:

```bash
flutter pub get
```

---

## 🧠 How It Works

### 1. **Permission Handling**

Handled by `PermissionHelper`:

```dart
await PermissionHelper.requestAll();
```

This requests camera and microphone permissions using `permission_handler`.

---

### 2. **Audio Recording**

Uses `flutter_sound` via `RecorderHelper` and `AudioRecorderWidget`.

* Displays live decibel levels and a timer.
* Saves audio as `.aac` in the app’s document directory.

```dart
await RecorderHelper.start(recorder);
await RecorderHelper.stop(recorder);
```

---

### 3. **Video Recording**

Uses `camera` via `CameraHelper` and `VideoRecorderWidget`.

* Displays a real-time camera preview.
* Records video in `.mp4` format.
* Provides playback via `VideoPlayerController`.

```dart
await CameraHelper.recordVideo(context, ref, onComplete: (file) {
  // handle video file
});
```

---

### 4. **State Management (Riverpod)**

`onboardingProvider` manages all media states:

```dart
ref.read(onboardingProvider.notifier).addVideo(file);
ref.read(onboardingProvider.notifier).stopAudioRecording(File(path));
ref.read(onboardingProvider.notifier).deleteAudio();
ref.read(onboardingProvider.notifier).deleteVideo();
```

---

### 5. **UI Components**

#### 🎤 Audio Recorder

* Displays a dynamic bar visualizer based on decibel values.
* Shows elapsed recording time.
* Allows delete and re-record.

#### 🎥 Video Recorder

* Shows progress bar and timer.
* Allows preview and playback of recorded video.
* Provides delete option.

#### ➡️ Next Button

Navigates to the next onboarding step after ensuring at least one media input is provided.

---

## 📱 Example UI Flow

1. **User** opens onboarding question screen.
2. Chooses one of three ways to answer:

    * Text
    * Audio
    * Video
3. Presses **Next** → validation ensures at least one answer is recorded.
4. Moves to the next onboarding step or home screen.

---

## 🛡️ Permissions Setup (Android & iOS)

### Android

In `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

### iOS

In `ios/Runner/Info.plist`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>We need your microphone access to record audio responses.</string>
<key>NSCameraUsageDescription</key>
<string>We need your camera access to record video responses.</string>
```

---

## 🧾 Example Usage

```dart
Column(
  children: const [
    AudioRecorderWidget(),
    SizedBox(height: 16),
    VideoRecorderWidget(),
    SizedBox(height: 16),
    NextButton(state: state),
  ],
);
```

---

## 🧪 Testing Tips

* Test both portrait and landscape modes for video preview.
* Try with different permission denial scenarios.
* Validate saved file paths under app documents directory.

---

## 🧰 Tech Stack Summary

| Component            | Package              |
| -------------------- | -------------------- |
| **State Management** | Riverpod             |
| **Audio Recording**  | flutter_sound        |
| **Video Recording**  | camera, video_player |
| **Permissions**      | permission_handler   |
| **Storage**          | path_provider        |
| **UI Theme**         | Custom `AppTheme`    |

---

## 🏁 Conclusion

This module gives your Flutter app a **modern, privacy-aware** onboarding experience where users can submit **audio and video responses** effortlessly.
It’s modular, easy to integrate, and follows clean architecture principles.

---
# 8CLUB
