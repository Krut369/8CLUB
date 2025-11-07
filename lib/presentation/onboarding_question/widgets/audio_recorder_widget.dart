import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/recorder_helper.dart';
import '../../../core/widgets/app_button.dart';
import '../onboarding_provider.dart';

class AudioRecorderWidget extends ConsumerStatefulWidget {
  const AudioRecorderWidget({super.key});

  @override
  ConsumerState<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends ConsumerState<AudioRecorderWidget> {
  FlutterSoundRecorder? _recorder;
  double _decibel = 0;
  bool _initialized = false;
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    RecorderHelper.initRecorder().then((r) {
      _recorder = r;
      setState(() => _initialized = true);
    });
  }

  Future<void> _startRecording() async {
    if (!_initialized) return;
    await Permission.microphone.request();

    await RecorderHelper.start(_recorder!);
    ref.read(onboardingProvider.notifier).startAudioRecording();

    _recorder!.onProgress!.listen((event) {
      setState(() => _decibel = event.decibels ?? 0);
    });

    _seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    final path = await RecorderHelper.stop(_recorder!);
    if (path != null) {
      ref.read(onboardingProvider.notifier).stopAudioRecording(File(path));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder?.closeRecorder();
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

    if (state.isRecordingAudio) {
      return _buildRecordingUI();
    }

    if (state.audioFile != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.input,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.play_arrow_rounded, color: AppTheme.accent, size: 32),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Audio Recorded • ${_formatTime(_seconds)}",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
              onPressed: notifier.deleteAudio,
            ),
          ],
        ),
      );
    }

    return AppButton(
      label: "Record Audio",
      icon: Icons.mic_none_rounded,
      onPressed: _startRecording,
    );
  }

  Widget _buildRecordingUI() {
    final barWidth = (_decibel.clamp(0, 60) / 60) * 200;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.input,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.mic_rounded, color: AppTheme.accent, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Recording Audio...",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Stack(
                  children: [
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: 6,
                      width: barWidth,
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
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
            onPressed: _stopRecording,
          ),
        ],
      ),
    );
  }
}
