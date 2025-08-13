import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Comprehensive text styles for the ROS Racket Sports Management App
/// Uses custom fonts: BebasNeue, bebasneuecyrillic, GlacialIndifference
class AppTextStyles {
  // === HEADLINES (BebasNeue for Impact) ===
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'BebasNeue',
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'BebasNeue',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: 'BebasNeue',
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );

  // === TITLES (BebasNeue Cyrillic for Variety) ===
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'bebasneuecyrillic',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'bebasneuecyrillic',
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: 'bebasneuecyrillic',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondaryLight,
  );

  // === BODY TEXT (GlacialIndifference for Readability) ===
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'GlacialIndifference',
    fontSize: 16,
    color: AppColors.textLight,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'GlacialIndifference',
    fontSize: 14,
    color: AppColors.textSecondaryLight,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'GlacialIndifference',
    fontSize: 12,
    color: AppColors.textTertiaryLight,
  );

  // === LABELS AND UI ELEMENTS ===
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'GlacialIndifference',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'GlacialIndifference',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondaryLight,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'GlacialIndifference',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiaryLight,
  );

  // === BUTTONS ===
  static const TextStyle button = TextStyle(
    fontFamily: 'GlacialIndifference',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: 'GlacialIndifference',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  // === SPECIAL STYLES ===
  static const TextStyle caption = TextStyle(
    fontFamily: 'GlacialIndifference',
    fontSize: 12,
    color: AppColors.textTertiaryLight,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: 'GlacialIndifference',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    color: AppColors.textTertiaryLight,
  );

  // === STATUS STYLES ===
  static const TextStyle error = TextStyle(
    fontFamily: 'GlacialIndifference',
    fontSize: 14,
    color: AppColors.error,
  );

  static const TextStyle success = TextStyle(
    fontFamily: 'GlacialIndifference',
    fontSize: 14,
    color: AppColors.success,
  );

  static const TextStyle warning = TextStyle(
    fontFamily: 'GlacialIndifference',
    fontSize: 14,
    color: AppColors.warning,
  );

  // === DARK THEME VARIANTS ===
  static TextStyle headlineLargeDark = headlineLarge.copyWith(
    color: AppColors.textDark,
  );
  static TextStyle headlineMediumDark = headlineMedium.copyWith(
    color: AppColors.textDark,
  );
  static TextStyle headlineSmallDark = headlineSmall.copyWith(
    color: AppColors.textDark,
  );
  static TextStyle titleLargeDark = titleLarge.copyWith(
    color: AppColors.textDark,
  );
  static TextStyle titleMediumDark = titleMedium.copyWith(
    color: AppColors.textDark,
  );
  static TextStyle titleSmallDark = titleSmall.copyWith(
    color: AppColors.textSecondaryDark,
  );
  static TextStyle bodyLargeDark = bodyLarge.copyWith(
    color: AppColors.textDark,
  );
  static TextStyle bodyMediumDark = bodyMedium.copyWith(
    color: AppColors.textSecondaryDark,
  );
  static TextStyle bodySmallDark = bodySmall.copyWith(
    color: AppColors.textTertiaryDark,
  );
  static TextStyle labelLargeDark = labelLarge.copyWith(
    color: AppColors.textDark,
  );
  static TextStyle labelMediumDark = labelMedium.copyWith(
    color: AppColors.textSecondaryDark,
  );
  static TextStyle labelSmallDark = labelSmall.copyWith(
    color: AppColors.textTertiaryDark,
  );
  static TextStyle captionDark = caption.copyWith(
    color: AppColors.textTertiaryDark,
  );
  static TextStyle overlineDark = overline.copyWith(
    color: AppColors.textTertiaryDark,
  );
}
