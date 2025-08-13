import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Consistent section header with gradient icon and modern styling
/// Perfect for organizing content in lists, screens, and sections
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final bool useGradientIcon;
  final EdgeInsetsGeometry? padding;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
    this.useGradientIcon = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    );

    return Padding(
      padding: padding ?? defaultPadding,
      child: Row(
        children: [
          // Gradient icon container
          if (useGradientIcon)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            )
          else
            Icon(icon, color: iconColor ?? AppColors.primary, size: 24),

          const SizedBox(width: 12),

          // Title text
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
