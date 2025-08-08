import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Enhanced custom button with gradient styling and multiple variants
/// Supports gradient, outlined, and text button styles with consistent theming
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expanded = true,
    this.variant = ButtonVariant.gradient,
    this.size = ButtonSize.medium,
    this.isLoading = false,
  });

  // Convenience constructors for different variants
  const CustomButton.outlined({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expanded = true,
    this.size = ButtonSize.medium,
    this.isLoading = false,
  }) : variant = ButtonVariant.outlined;

  const CustomButton.text({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expanded = false,
    this.size = ButtonSize.medium,
    this.isLoading = false,
  }) : variant = ButtonVariant.text;

  const CustomButton.small({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expanded = false,
    this.variant = ButtonVariant.gradient,
    this.isLoading = false,
  }) : size = ButtonSize.small;

  @override
  Widget build(BuildContext context) {
    Widget button;

    // Loading state
    if (isLoading) {
      button = _buildLoadingButton();
    } else {
      switch (variant) {
        case ButtonVariant.gradient:
          button = _buildGradientButton();
          break;
        case ButtonVariant.outlined:
          button = _buildOutlinedButton();
          break;
        case ButtonVariant.text:
          button = _buildTextButton();
          break;
      }
    }

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }

  Widget _buildGradientButton() {
    return Container(
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
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: _getPadding(),
        ),
        child: _buildButtonContent(Colors.white),
      ),
    );
  }

  Widget _buildOutlinedButton() {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: _getPadding(),
      ),
      child: _buildButtonContent(AppColors.primary),
    );
  }

  Widget _buildTextButton() {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: _getPadding(),
      ),
      child: _buildButtonContent(AppColors.primary),
    );
  }

  Widget _buildLoadingButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: _getPadding(),
        ),
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(Color textColor) {
    final textStyle =
        size == ButtonSize.small
            ? AppTextStyles.buttonSmall.copyWith(color: textColor)
            : AppTextStyles.button.copyWith(color: textColor);

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: size == ButtonSize.small ? 18 : 20),
          const SizedBox(width: 8),
          Text(label, style: textStyle),
        ],
      );
    }

    return Text(label, style: textStyle);
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }
}

/// Button variant enum for different styling options
enum ButtonVariant {
  gradient, // Gradient background (default)
  outlined, // Outlined style
  text, // Text only style
}

/// Button size enum for different sizing options
enum ButtonSize {
  small, // Compact button
  medium, // Standard button (default)
  large, // Large button
}
