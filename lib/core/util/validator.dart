import '../constant/app_strings.dart';

class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (!_emailRegex.hasMatch(v)) return AppStrings.errorEmail;
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 8) return AppStrings.errorPassword;
    return null;
  }

  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) return AppStrings.errorPassword;
    return null;
  }

  static String? Function(String?) confirmPassword(String original) {
    return (String? value) {
      if (value != original) return AppStrings.errorConfirm;
      return null;
    };
  }
}