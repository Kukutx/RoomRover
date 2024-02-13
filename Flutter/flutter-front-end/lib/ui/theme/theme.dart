import 'package:flutter/material.dart';
import 'package:pw5/ui/theme/text_styles.dart';

class AppTheme {
  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade200,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStatePropertyAll(semibold_16),
        foregroundColor: const MaterialStatePropertyAll(Colors.white),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.pressed)
              ? Colors.grey.shade900
              : Colors.black,
        ),
        minimumSize: const MaterialStatePropertyAll(
          Size.fromHeight(44),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStatePropertyAll(semibold_16),
        foregroundColor: const MaterialStatePropertyAll(Colors.black),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.pressed)
              ? Colors.grey.shade100
              : Colors.transparent,
        ),
        side: const MaterialStatePropertyAll(
          BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
        minimumSize: const MaterialStatePropertyAll(
          Size.fromHeight(44),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: regular_14.copyWith(color: Colors.grey),
      errorStyle: regular_12.copyWith(color: Colors.red),
      border: InputBorder.none,
      suffixIconColor: Colors.grey.shade700,
      contentPadding: EdgeInsets.zero,
      isDense: true,
    ),
  );
}




class LightColors {
  static const Color kLightYellow = Color(0xFFFFF9EC);
  static const Color kLightYellow2 = Color(0xFFFFE4C7);
  static const Color kDarkYellow = Color(0xFFF9BE7C);
  static const Color kPalePink = Color(0xFFFED4D6);

  static const Color kRed = Color(0xFFE46472);
  static const Color kLavender = Color(0xFFD5E4FE);
  static const Color kBlue = Color(0xFF6488E4);
  static const Color kLightGreen = Color(0xFFD9E6DC);
  static const Color kGreen = Color(0xFF309397);

  static const Color kDarkBlue = Color(0xFF0D253F);
}