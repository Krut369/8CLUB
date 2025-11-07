import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import 'experience_provider.dart';

class ExperienceSelectionScreen extends ConsumerWidget {
  const ExperienceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(experienceProvider);
    final notifier = ref.read(experienceProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  "What kind of experiences do you want to host?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                const SizedBox(height: 20),
            
                // Scrollable cards
                SizedBox(
                  height: 140,
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemCount: state.experiences.length,
                    itemBuilder: (_, i) {
                      final exp = state.experiences[i];
                      final isSelected = state.selectedIds.contains(exp.id);
                      return GestureDetector(
                        onTap: () => notifier.toggleSelection(exp.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(exp.imageUrl),
                              fit: BoxFit.cover,
                              colorFilter: isSelected
                                  ? null
                                  : const ColorFilter.mode(
                                  Colors.grey, BlendMode.saturation),
                            ),
                            border: isSelected
                                ? Border.all(
                                color: AppTheme.accent, width: 2)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            
                const SizedBox(height: 30),
            
                // Text input
                TextField(
                  style: const TextStyle(color: Colors.white),
                  maxLength: 250,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Describe your perfect hotspot",
                    hintStyle: const TextStyle(color: AppTheme.grey),
                    filled: true,
                    fillColor: AppTheme.input,
                    counterText: "",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  ),
                  onChanged: notifier.updateDescription,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/onboarding'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600,color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
