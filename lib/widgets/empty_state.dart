import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Enhanced empty state widget with gradient styling and action button
/// Perfect for empty lists, no data scenarios, and encouraging user actions
class EmptyState extends StatelessWidget {
  final String message;
  final String? subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final bool useGradientIcon;

  const EmptyState({
    super.key,
    required this.message,
    this.subtitle,
    this.icon = Icons.hourglass_empty,
    this.actionLabel,
    this.onActionPressed,
    this.useGradientIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Enhanced icon with gradient or subtle styling
            if (useGradientIcon)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(icon, size: 60, color: Colors.white),
              )
            else
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(
                  icon,
                  size: 60,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),

            const SizedBox(height: 24),

            // Main message
            Text(
              message,
              style: AppTextStyles.titleLarge.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            // Optional subtitle
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Optional action button
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: onActionPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: Text(actionLabel!, style: AppTextStyles.button),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Usage examples:
/// 
/// // Basic empty state
/// EmptyState(
///   message: 'No games scheduled yet',
///   icon: Icons.sports_basketball,
/// )
/// 
/// // Empty state with subtitle and action
/// EmptyState(
///   message: 'No players found',
///   subtitle: 'Start by adding some players to your team',
///   icon: Icons.group_add,
///   actionLabel: 'Add Player',
///   onActionPressed: () => Navigator.push(...),
/// )
/// 
/// // Empty state with custom styling
/// EmptyState(
///   message: 'Search results empty',
///   subtitle: 'Try adjusting your search terms',
///   icon: Icons.search_off,
///   useGradientIcon: false,
/// )