import 'package:flutter/material.dart';
import '../core/constant/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../widgets/app_logo.dart';
import '../widgets/gradient_background.dart';
import '../widgets/primary_button.dart';
import 'auth/login_screens.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _getStarted(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkPrimary : AppColors.primary;

    return Scaffold(
      body: GradientBackground(
        child: Stack(
          children: [
            const Positioned(
              right: -50,
              bottom: -60,
              child: _DecorativeStack(),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 40, 28, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppLogo(size: 64, showTitle: false),
                    const SizedBox(height: 28),
                    Text(
                      AppStrings.welcomeTag,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Devixo\nNotes',
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        height: 1.02,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      AppStrings.welcomeBody,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.textTheme.bodyMedium?.color,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: 190,
                      child: PrimaryButton(
                        label: '${AppStrings.getStarted}  →',
                        onPressed: () => _getStarted(context),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppStrings.welcomeFooter,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecorativeStack extends StatelessWidget {
  const _DecorativeStack();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget tile(double size, double angle, Color color) {
      return Transform.rotate(
        angle: angle,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      );
    }

    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          tile(
            230,
            -0.2,
            AppColors.primarySoft.withOpacity(isDark ? 0.12 : 0.55),
          ),
          tile(
            230,
            -0.1,
            AppColors.primaryLight.withOpacity(isDark ? 0.3 : 0.45),
          ),
          tile(
            230,
            0.06,
            isDark ? AppColors.primaryDark : AppColors.primary,
          ),
        ],
      ),
    );
  }
}