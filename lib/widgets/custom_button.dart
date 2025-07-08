import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// Reusable elevated button with icon & central style.
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;
  final bool expanded;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.check_circle_outline,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label, style: AppTextStyles.button),
    );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
