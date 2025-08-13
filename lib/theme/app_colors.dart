import 'package:flutter/material.dart';

/// Central color palette for the ROS Racket Sports Management App
/// Includes the signature gradient colors and semantic colors
class AppColors {
  // === ROS Gradient Palette ===
  static const Color primary = Color(0xFF10138A); // Deep ROS Blue
  static const Color secondary = Color(0xFF1E3A8A); // Gradient Middle
  static const Color tertiary = Color(0xFF3B82F6); // Gradient End

  // === Gradient Definition ===
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary, tertiary],
  );

  static const LinearGradient primaryGradientVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary, secondary, tertiary],
  );

  // === Light Theme Colors ===
  static const Color backgroundLight = Colors.white;
  static const Color surfaceLight = Colors.white;
  static const Color textLight = Colors.black;
  static const Color textSecondaryLight = Colors.black87;
  static const Color textTertiaryLight = Colors.black54;

  // === Dark Theme Colors ===
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textDark = Colors.white;
  static const Color textSecondaryDark = Colors.white70;
  static const Color textTertiaryDark = Colors.white54;

  // === Semantic Colors ===
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue

  // === Utility Colors ===
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFD1D5DB);
  static const Color shadow = Color(0x1A000000);
}
