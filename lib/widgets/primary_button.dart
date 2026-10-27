import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool tonal;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.tonal = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disabled = onPressed == null || isLoading;

    final content = isLoading
        ? const SizedBox(
      height: 22,
      width: 22,
      child: CircularProgressIndicator(
        strokeWidth: 2.4,
        color: Colors.white,
      ),
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(label),
      ],
    );

    if (tonal) {
      return FilledButton(
        onPressed: disabled ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor:
          isDark ? AppColors.darkSurface : AppColors.primarySoft,
          foregroundColor: isDark ? AppColors.darkPrimary : AppColors.primary,
          elevation: 0,
        ),
        child: content,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: disabled
            ? null
            : [
          BoxShadow(
            color: AppColors.primary.withOpacity(isDark ? 0.25 : 0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FilledButton(
        onPressed: disabled ? null : onPressed,
        child: content,
      ),
    );
  }
}