


import 'package:flutter/material.dart';
import 'package:smart_note_app/screens/auth/recent_sent_screen.dart';
import '../../core/constant/app_strings.dart';
import '../../core/util/validator.dart';
import '../../providers/providers.dart';
import '../../services/auth_services.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ForgotPasswordScreen extends ConsumerStatefulWidget {
  final String initialEmail;

  const ForgotPasswordScreen({super.key, this.initialEmail = ''});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email =
  TextEditingController(text: widget.initialEmail);

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _send() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final email = _email.text.trim();
    final error =
    await ref.read(authControllerProvider.notifier).sendReset(email);
    if (!mounted) return;
    if (error != null) {
      _showError(error);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ResetSentScreen(email: email)),
      );
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
                        AppStrings.resetTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          AppStrings.resetSubtitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 28),
                      CustomTextField(
                        controller: _email,
                        label: AppStrings.emailLabel,
                        hint: AppStrings.emailHint,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: Validators.email,
                        onSubmitted: (_) => _send(),
                        enabled: !loading,
                      ),
                      const SizedBox(height: 22),
                      PrimaryButton(
                        label: AppStrings.sendResetLink,
                        isLoading: loading,
                        onPressed: _send,
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