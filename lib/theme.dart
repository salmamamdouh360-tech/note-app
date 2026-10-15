import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1E6FFF);
  static const field = Color(0xFFF2F2F7);
  static const border = Color(0xFFE5E5EA);
  static const grey = Color(0xFF8A8A8E);
}

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 0),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
);
