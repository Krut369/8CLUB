import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isDisabled;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: isDisabled
              ? null
              : const LinearGradient(
            colors: [AppTheme.accent, Color(0xFF2563EB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          color: isDisabled ? Colors.grey.shade700 : null,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
