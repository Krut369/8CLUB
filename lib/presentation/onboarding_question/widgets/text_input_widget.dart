import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class TextInputWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const TextInputWidget({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      maxLength: 600,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: "Start typing here...",
        hintStyle: const TextStyle(color: AppTheme.grey),
        filled: true,
        fillColor: AppTheme.input,
        counterText: "",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
