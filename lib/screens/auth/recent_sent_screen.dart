


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constant/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/providers.dart';
import '../../services/auth_services.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/primary_button.dart';

class ResetSentScreen extends ConsumerWidget {
  final String email;

  const ResetSentScreen({super.key, required this.email});

  Future<void> _resend(BuildContext context, WidgetRef ref) async {
    final error =
    await ref.read(authControllerProvider.notifier).sendReset(email);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(error ?? AppStrings.resetSent)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkPrimary : AppColors.primary;
    final circle =
    isDark ? AppColors.primary.withOpacity(0.25) : AppColors.primarySoft;
    final resending = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        const AppLogo(),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text(
                      AppStrings.checkInbox,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.resetSent,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: circle,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, size: 32, color: accent),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text.rich(
                      TextSpan(
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(text: 'We sent a reset link to '),
                          TextSpan(
                            text: email,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const TextSpan(
                            text: '. It may take a minute to arrive.',
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      label: AppStrings.backToLogin,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.didntReceive,
                          style: theme.textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: resending ? null : () => _resend(context, ref),
                          child: Text(
                            AppStrings.resend,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: resending
                                  ? theme.textTheme.bodySmall?.color
                                  : accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}