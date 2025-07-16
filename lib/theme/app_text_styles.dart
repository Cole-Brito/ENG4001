import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Re-usable text styles.
/// Prefer these over hard-coding font sizes in widgets.
class AppTextStyles {
  static const headline = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );
  static const headlineLight = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w300,
    color: AppColors.text,
  );

  static const subhead = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
  static const subheadLight = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: AppColors.text,
  );

  static const body = TextStyle(fontSize: 14, color: AppColors.text);

  static const bodyLight = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: AppColors.text,
  );

  static const bodyBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const bodyItalic = TextStyle(
    fontSize: 14,
    fontStyle: FontStyle.italic,
    color: AppColors.text,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static const label = TextStyle(fontSize: 14, color: AppColors.text);

  static const labelBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );
  static const labelLight = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: AppColors.text,
  );

  static const captionLight = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: Colors.grey,
  );

  static const captionBold = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  static const caption = TextStyle(fontSize: 12, color: Colors.grey);

  static const error = TextStyle(fontSize: 14, color: AppColors.error);

  static const errorLight = TextStyle(
    fontSize: 14,
    color: AppColors.error,
    fontWeight: FontWeight.w300,
  );
  static const errorBold = TextStyle(
    fontSize: 14,
    color: AppColors.error,
    fontWeight: FontWeight.bold,
  );

  static const linkBold = TextStyle(
    fontSize: 14,
    color: AppColors.accent,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
  );

  static const link = TextStyle(
    fontSize: 14,
    color: AppColors.accent,
    decoration: TextDecoration.underline,
  );
}
