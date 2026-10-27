import 'package:flutter/material.dart';
import '../core/constant/app_strings.dart';
import '../core/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showTitle;

  const AppLogo({super.key, this.size = 44, this.showTitle = true});

  @override
  Widget build(BuildContext context) {
    final icon = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: size * 0.35,
            offset: Offset(0, size * 0.15),
          ),
        ],
      ),
      child: Icon(
        Icons.description_outlined,
        color: Colors.white,
        size: size * 0.55,
      ),
    );

    if (!showTitle) return icon;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 12),
        Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}