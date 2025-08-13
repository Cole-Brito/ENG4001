import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Enhanced info card with gradient icon and modern Material 3 styling
/// Perfect for user details, settings, statistics, and information display
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final bool useGradientIcon;
  final Widget? trailing;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.backgroundColor,
    this.useGradientIcon = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: backgroundColor ?? Theme.of(context).cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Gradient icon container
              if (useGradientIcon)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                )
              else
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 24),
                ),

              const SizedBox(width: 16),

              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Optional trailing widget
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ] else if (onTap != null) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
