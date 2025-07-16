import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// Consistent header used across lists & sections.
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionHeader({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo.shade700),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.headline),
      ],
    );
  }
}
