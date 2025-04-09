// lib/config/themes/dark_theme.dart

import 'package:flutter/material.dart';
import 'package:workout_tracker/config/constants/app_constants.dart';
import 'app_theme.dart';

class DarkTheme {
  static ThemeData get theme {
    return ThemeData.dark().copyWith(
      primaryColor: AppTheme.primaryColor,
      colorScheme: ColorScheme.dark(
        primary: AppTheme.primaryColor,
        secondary: AppTheme.accentColor,
        error: AppTheme.errorColor,
        background: Color(0xFF121212),
        surface: Color(0xFF1E1E1E),
      ),
      scaffoldBackgroundColor: Color(0xFF121212),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius_m),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primaryColor,
          side: BorderSide(color: AppTheme.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius_m),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius_l),
        ),
        color: Color(0xFF1E1E1E),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Color(0xFF2C2C2C),
        selectedColor: AppTheme.primaryColor.withOpacity(0.3),
        labelStyle: TextStyle(color: Colors.white),
        secondaryLabelStyle: TextStyle(color: AppTheme.primaryColor),
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacing_m,
          vertical: AppTheme.spacing_xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius_xl),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius_m),
          borderSide: BorderSide(color: Color(0xFF3A3A3A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius_m),
          borderSide: BorderSide(color: Color(0xFF3A3A3A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius_m),
          borderSide: BorderSide(color: AppTheme.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius_m),
          borderSide: BorderSide(color: AppTheme.errorColor),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacing_m,
          vertical: AppTheme.spacing_m,
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: AppTheme.headingStyle.copyWith(
          color: Colors.white,
        ),
        titleLarge: AppTheme.subheadingStyle.copyWith(
          color: Colors.white,
        ),
        bodyLarge: AppTheme.bodyStyle.copyWith(
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.white70,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        color: Color(0xFF2C2C2C),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppTheme.primaryColor;
          }
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppTheme.primaryColor;
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppTheme.primaryColor.withOpacity(0.5);
          }
          return null;
        }),
      ),
    );
  }
}

