import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constant/app_strings.dart';
import '../../core/util/validator.dart';
import '../../providers/providers.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/primary_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final error = await ref
        .read(authControllerProvider.notifier)
        .register(_email.text, _password.text);
    if (!mounted) return;
    if (error != null) {
      _showError(error);
    } else {
      Navigator.of(context).popUntil((r) => r.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _formKey,
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
                              onPressed: loading
                                  ? null
                                  : () => Navigator.of(context).pop(),
                            ),
                          ),
                          const AppLogo(),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text(
                        AppStrings.createAccount,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.registerSubtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 28),
                      CustomTextField(
                        controller: _email,
                        label: AppStrings.emailLabel,
                        hint: AppStrings.emailHint,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                        enabled: !loading,
                      ),
                      const SizedBox(height: 18),
                      CustomTextField(
                        controller: _password,
                        label: AppStrings.passwordLabel,
                        hint: AppStrings.passwordHintRegister,
                        isPassword: true,
                        validator: Validators.password,
                        enabled: !loading,
                      ),
                      const SizedBox(height: 18),
                      CustomTextField(
                        controller: _confirm,
                        label: AppStrings.confirmLabel,
                        hint: AppStrings.confirmHint,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        validator: (v) =>
                            Validators.confirmPassword(_password.text)(v),
                        onSubmitted: (_) => _register(),
                        enabled: !loading,
                      ),
                      const SizedBox(height: 28),
                      PrimaryButton(
                        label: AppStrings.createAccountButton,
                        isLoading: loading,
                        onPressed: _register,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.termsText,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.haveAccount,
                            style: theme.textTheme.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: loading
                                ? null
                                : () => Navigator.of(context).pop(),
                            child: Text(
                              AppStrings.logInLink,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
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
      ),
    );
  }
}