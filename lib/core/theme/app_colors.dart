import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF5B4BC4);
  static const Color primaryLight = Color(0xFF7C6BDB);
  static const Color primaryDark = Color(0xFF4A3BA8);
  static const Color primarySoft = Color(0xFFE8E4FC);
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primaryDark],
  );
  static const Color lightBackground = Color(0xFFFBF9FF);
  static const Color lightSurface = Color(0xFFF3F0FB);
  static const Color lightBorder = Color(0xFFCFC9DE);
  static const Color lightTextPrimary = Color(0xFF1F1B2D);
  static const Color lightTextSecondary = Color(0xFF6B6680);
  static const Color lightHint = Color(0xFF9C97AE);
  static const List<Color> lightGradient = [
    Color(0xFFF1EDFF),
    Color(0xFFFBF9FF),
    Color(0xFFEDE8FF),
  ];
  static const Color darkBackground = Color(0xFF141218);
  static const Color darkSurface = Color(0xFF211F27);
  static const Color darkBorder = Color(0xFF4A4655);
  static const Color darkTextPrimary = Color(0xFFEAE6F2);
  static const Color darkTextSecondary = Color(0xFFB0AABF);
  static const Color darkHint = Color(0xFF7D7790);
  static const Color darkPrimary = Color(0xFFCFC4FF);
  static const List<Color> darkGradient = [
    Color(0xFF1B1726),
    Color(0xFF141218),
    Color(0xFF191524),
  ];
  static const List<Color> noteCardsLight = [
    Color(0xFFEDE9FE),
    Color(0xFFFFEEE4),
    Color(0xFFE6F4EE),
    Color(0xFFFFF6D9),
    Color(0xFFE4F0FB),
  ];
  static const List<Color> noteCardsDark = [
    Color(0xFF3A3650),
    Color(0xFF4A3C38),
    Color(0xFF2F4340),
    Color(0xFF47402C),
    Color(0xFF2E3D50),
  ];
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorDark = Color(0xFFFFB4AB);
  static const Color success = Color(0xFF2E7D5B);
}