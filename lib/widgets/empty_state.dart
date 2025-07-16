import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// Friendly fallback when a list is empty.
class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.hourglass_empty,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(message, style: AppTextStyles.subhead),
        ],
      ),
    );
  }
}
// Usage example:
// EmptyState(//   message: 'No games scheduled yet.',
//   icon: Icons.sports_esports_outlined, 
// );
// This widget can be used in any screen where you need to show a friendly
// message when there's no data to display, like in a list or grid view.