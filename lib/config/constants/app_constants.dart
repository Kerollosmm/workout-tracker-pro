// lib/config/themes/app_theme.dart

import 'package:flutter/material.dart';
import 'package:workout_tracker/config/themes/dark_theme.dart';
import 'package:workout_tracker/config/themes/light_theme.dart';


class AppTheme {
  // Get the current theme based on setting
  static ThemeData getTheme(bool isDarkMode) {
    return isDarkMode ? darkTheme : lightTheme;
  }
  
  // Convenience getters
  static ThemeData get lightTheme => LightTheme.theme;
  static ThemeData get darkTheme => DarkTheme.theme;
  
  // Color constants used across the app
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color accentColor = Color(0xFF03A9F4);
  static const Color errorColor = Color(0xFFE57373);
  static const Color successColor = Color(0xFF81C784);
  static const Color warningColor = Color(0xFFFFD54F);
  
  // Muscle group colors
  static const Map<String, Color> muscleGroupColors = {
    'Chest': Color(0xFFF44336),      // Red
    'Back': Color(0xFF2196F3),       // Blue
    'Shoulders': Color(0xFFFF9800),  // Orange
    'Arms': Color(0xFF9C27B0),       // Purple
    'Legs': Color(0xFF4CAF50),       // Green
    'Core': Color(0xFFFFD600),       // Yellow
    'Cardio': Color(0xFFE91E63),     // Pink
    'Full Body': Color(0xFF009688),  // Teal
  };
  
  // Common text styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );
  
  // Card decorations
  static BoxDecoration cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    );
  }
  
  // Common button styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  static ButtonStyle secondaryButtonStyle = OutlinedButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  // Common spacing constants
  static const double spacing_xs = 4.0;
  static const double spacing_s = 8.0;
  static const double spacing_m = 16.0;
  static const double spacing_l = 24.0;
  static const double spacing_xl = 32.0;
  
  // Common border radius constants
  static const double borderRadius_s = 4.0;
  static const double borderRadius_m = 8.0;
  static const double borderRadius_l = 12.0;
  static const double borderRadius_xl = 20.0;
  
  // Get color for a specific muscle group (or default if not found)
  static Color getColorForMuscleGroup(String muscleGroup) {
    return muscleGroupColors[muscleGroup] ?? Colors.grey;
  }
}
