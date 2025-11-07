import 'package:club_app_task/presentation/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'presentation/experience_selection/experience_selection_screen.dart';
import 'presentation/onboarding_question/onboarding_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routes: {
        '/': (_) => const ExperienceSelectionScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
