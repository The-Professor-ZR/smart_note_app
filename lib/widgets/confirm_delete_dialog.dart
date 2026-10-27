

import 'package:flutter/material.dart';
import '../core/constant/app_strings.dart';
import '../core/theme/app_colors.dart';

Future<bool> showConfirmDeleteDialog(BuildContext context) async {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final danger = isDark ? AppColors.errorDark : AppColors.error;

  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor:
      isDark ? AppColors.darkSurface : AppColors.lightBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        AppStrings.deleteTitle,
        style: Theme.of(ctx).textTheme.titleLarge,
      ),
      content: Text(
        AppStrings.deleteBody,
        style: Theme.of(ctx).textTheme.bodyMedium,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: TextButton.styleFrom(foregroundColor: danger),
          child: const Text(AppStrings.delete),
        ),
      ],
    ),
  );

  return result ?? false;
}