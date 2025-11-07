import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../onboarding_provider.dart';

class NextButton extends StatelessWidget {
  final OnboardingState state;
  const NextButton({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: "Next",
      onPressed: () async {
        if (state.answerText.isEmpty &&
            state.audioFile == null &&
            state.videoFile == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Please provide at least one answer (text, audio, or video).",
              ),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "🎉 Submission Successful!",
              style: TextStyle(fontSize: 16),
            ),
            backgroundColor: AppTheme.accent,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 1),
          ),
        );

        await Future.delayed(const Duration(seconds: 1));
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
    );
  }
}
