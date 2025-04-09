// lib/config/themes/light_theme.dart

import 'package:flutter/material.dart';
import 'package:workout_tracker/config/constants/app_constants.dart';
import 'app_theme.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: AppTheme.primaryColor,
      colorScheme: ColorScheme.light(
        primary: AppTheme.primaryColor,
        secondary: AppTheme.accentColor,
        error: AppTheme.errorColor,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
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
        color: Colors.white,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[200],
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
        labelStyle: TextStyle(color: Colors.black87),
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
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius_m),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius_m),
          borderSide: BorderSide(color: Colors.grey[300]!),
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
          color: Colors.black87,
        ),
        titleLarge: AppTheme.subheadingStyle.copyWith(
          color: Colors.black87,
        ),
        bodyLarge: AppTheme.bodyStyle.copyWith(
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        color: Colors.grey[200],
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
