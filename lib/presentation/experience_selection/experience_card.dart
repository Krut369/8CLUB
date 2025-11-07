import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/experience_model.dart';

class ExperienceCard extends StatelessWidget {
  final Experience experience;
  final bool isSelected;
  final VoidCallback onTap;

  const ExperienceCard({
    super.key,
    required this.experience,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(experience.imageUrl),
            fit: BoxFit.cover,
            colorFilter: isSelected
                ? null
                : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
          ),
          border: isSelected
              ? Border.all(color: AppTheme.accent, width: 2)
              : null,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              experience.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
