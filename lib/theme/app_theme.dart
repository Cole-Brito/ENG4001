import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Global ThemeData objects.
/// Import `AppTheme.light` / `.dark` in main.dart.
class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primary,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: const TextTheme(bodyMedium: AppTextStyles.body),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppTextStyles.button,
        ),
      ),
    );
  }

  /// Dark theme with Material 3 support.
  /// Uses the same primary color as light theme.
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primary,
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }

  /// Fallback theme for unsupported platforms.
  static ThemeData get fallback {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primary,
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }

  /// Returns the current theme based on system settings.
  static ThemeData get current {
    return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark
        ? dark
        : light;
  }
}
