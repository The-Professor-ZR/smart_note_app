




import 'package:flutter/material.dart';
import 'package:smart_note_app/screens/auth/register_screen.dart';
import '../../core/constant/app_strings.dart';
import '../../core/util/validator.dart';
import '../../providers/providers.dart';
import '../../services/auth_services.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/primary_button.dart';
import 'forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final error = await ref
        .read(authControllerProvider.notifier)
        .login(_email.text, _password.text);
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: AppLogo()),
                      const SizedBox(height: 36),
                      Text(
                        AppStrings.welcomeBack,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.signInSubtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 32),
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
                        hint: AppStrings.passwordHintLogin,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        validator: Validators.loginPassword,
                        onSubmitted: (_) => _login(),
                        enabled: !loading,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: loading
                              ? null
                              : () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ForgotPasswordScreen(
                                initialEmail: _email.text.trim(),
                              ),
                            ),
                          ),
                          child: const Text(AppStrings.forgotPassword),
                        ),
                      ),
                      const SizedBox(height: 8),
                      PrimaryButton(
                        label: AppStrings.logIn,
                        isLoading: loading,
                        onPressed: _login,
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.noAccount,
                            style: theme.textTheme.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: loading
                                ? null
                                : () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            ),
                            child: Text(
                              AppStrings.register,
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