import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class MediaPreviewWidget extends StatelessWidget {
  final String label;
  final VoidCallback onDelete;

  const MediaPreviewWidget({
    super.key,
    required this.label,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: onDelete,
        ),
      ],
    );
  }
}
