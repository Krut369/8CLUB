import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import 'onboarding_provider.dart';
import 'widgets/audio_recorder_widget.dart';
import 'widgets/video_recorder_widget.dart';
import 'widgets/text_input_widget.dart';
import 'widgets/next_button.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Why do you want to host with us?",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Write about yourself and what motivates you to host.",
                  style: TextStyle(color: AppTheme.grey, fontSize: 14),
                ),
                const SizedBox(height: 20),
                TextInputWidget(onChanged: notifier.updateText),
                const SizedBox(height: 20),
                AudioRecorderWidget(),
                const SizedBox(height: 16),
                VideoRecorderWidget(),
                const SizedBox(height: 30),
                NextButton(state: state),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
