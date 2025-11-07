import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingState {
  final String answerText;
  final File? audioFile;
  final File? videoFile;
  final bool isRecordingAudio;

  const OnboardingState({
    this.answerText = '',
    this.audioFile,
    this.videoFile,
    this.isRecordingAudio = false,
  });

  OnboardingState copyWith({
    String? answerText,
    File? audioFile,
    File? videoFile,
    bool? isRecordingAudio,
  }) {
    return OnboardingState(
      answerText: answerText ?? this.answerText,
      audioFile: audioFile ?? this.audioFile,
      videoFile: videoFile ?? this.videoFile,
      isRecordingAudio: isRecordingAudio ?? this.isRecordingAudio,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  void updateText(String text) => state = state.copyWith(answerText: text);
  void startAudioRecording() => state = state.copyWith(isRecordingAudio: true);
  void stopAudioRecording(File file) =>
      state = state.copyWith(isRecordingAudio: false, audioFile: file);
  void deleteAudio() => state = state.copyWith(audioFile: null);
  void addVideo(File file) => state = state.copyWith(videoFile: file);
  void deleteVideo() => state = state.copyWith(videoFile: null);
}

final onboardingProvider =
StateNotifierProvider<OnboardingNotifier, OnboardingState>(
        (ref) => OnboardingNotifier());
