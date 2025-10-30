import 'package:flutter/material.dart';

class AppColors {
  static const deepBlue = Color(0xFF0F4C81);
  static const softGreen = Color(0xFF68B266);
  static const peach = Color(0xFFFF8A65);
  static const mustard = Color(0xFFF2C94C);
  static const darkText = Color(0xFF2E2E2E);
  static const lightBackground = Color(0xFFF6F7F9);
}

ThemeData buildAppTheme() {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.deepBlue,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.deepBlue,
      onPrimary: Colors.white,
      secondary: AppColors.peach,
      onSecondary: Colors.white,
      background: AppColors.lightBackground,
      onBackground: AppColors.darkText,
      surface: Colors.white,
      onSurface: AppColors.darkText,
      error: Colors.redAccent,
      onError: Colors.white,
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(fontFamily: 'Inter', fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.darkText),
      headline6: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.darkText),
      bodyText1: TextStyle(fontFamily: 'Inter', fontSize: 16, color: AppColors.darkText),
      bodyText2: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.darkText),
      caption: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.darkText),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.darkText),
      titleTextStyle: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.darkText),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.deepBlue,
      foregroundColor: Colors.white,
      elevation: 6,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.mustard,
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    iconTheme: const IconThemeData(size: 24, color: AppColors.darkText),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: TextStyle(color: AppColors.darkText),
    ),
  );
}
