import 'package:flutter/material.dart';

// Define core colors for reuse
const Color _primaryLightColor = Color(0xFFD32F2F); // Slightly deeper red
const Color _secondaryLightColor = Color(0xFF424242); // Dark grey
const Color _backgroundLightColor = Color(0xFFF5F5F5); // Off-white
const Color _cardLightColor = Colors.white;

const Color _primaryDarkColor = Color(0xFFE57373); // Lighter red for dark mode
const Color _secondaryDarkColor = Color(0xFFEEEEEE); // Light grey/white text
const Color _backgroundDarkColor = Color(0xFF121212); // True black
const Color _cardDarkColor = Color(0xFF1E1E1E); // Dark grey for cards

// Centralized definition for border radius
final BorderRadius _defaultBorderRadius = BorderRadius.circular(12.0);

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: _primaryLightColor,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.red, // Keep swatch for compatibility if needed
      accentColor: _secondaryLightColor, // Use accentColor for secondary
      backgroundColor: _backgroundLightColor,
      cardColor: _cardLightColor,
      brightness: Brightness.light,
    ).copyWith(
      primary: _primaryLightColor, // Explicitly set primary
      secondary: _secondaryLightColor, // Explicitly set secondary
      surface: _cardLightColor, // Surface color for cards, dialogs etc.
      onPrimary: Colors.white, // Text/icon color on primary background
      onSecondary: Colors.white, // Text/icon color on secondary background
      onBackground: Colors.black87, // Text/icon color on background
      onSurface: Colors.black87, // Text/icon color on card/surface
    ),
    scaffoldBackgroundColor: _backgroundLightColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryLightColor,
      foregroundColor: Colors.white, // Color for title and icons
      elevation: 1.0, // Subtle elevation
      centerTitle: true, // Center title by default
      titleTextStyle: TextStyle(
        fontFamily: 'Roboto', // Consider adding custom fonts
        fontSize: 20,
        fontWeight: FontWeight.w600, // Slightly bolder
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryLightColor, // Button background
        foregroundColor: Colors.white, // Button text/icon color
        shape: RoundedRectangleBorder(borderRadius: _defaultBorderRadius),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), // Adjusted padding
        elevation: 2, // Subtle elevation
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 4, // Slightly less elevation
      shape: RoundedRectangleBorder(borderRadius: _defaultBorderRadius),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0), // Adjust default margins if needed
      color: _cardLightColor, // Explicit card color
      clipBehavior: Clip.antiAlias, // Improve rendering of rounded corners
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100], // Light fill for text fields
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: _defaultBorderRadius,
        borderSide: BorderSide.none, // No border by default
      ),
      enabledBorder: OutlineInputBorder( // Border when enabled but not focused
        borderRadius: _defaultBorderRadius,
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: _defaultBorderRadius,
        borderSide: const BorderSide(color: _primaryLightColor, width: 2.0), // Primary color focus border
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: _defaultBorderRadius,
        borderSide: BorderSide(color: Colors.redAccent.shade200, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: _defaultBorderRadius,
        borderSide: BorderSide(color: Colors.redAccent.shade700, width: 2.0),
      ),
      labelStyle: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500), // Style for the labelText
      hintStyle: TextStyle(color: Colors.grey[400]), // Style for the hintText
      prefixIconColor: Colors.grey[600], // Default color for prefix icons
      suffixIconColor: Colors.grey[500], // Default color for suffix icons
      errorStyle: TextStyle(color: Colors.redAccent.shade400, fontSize: 12, height: 1), // Error text style
    ),
    textTheme: TextTheme(
      // Define main text styles
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey[800]),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.grey[800]),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[800]), // Used for AppBar title if not overridden
      bodyLarge: TextStyle(fontSize: 16, color: Colors.grey[800]), // Default for most text
      bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[700]), // Smaller text
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // Often used for button text
    ),
    iconTheme: IconThemeData( // Default icon theme
      color: Colors.grey[700],
      size: 24.0,
    ),
    dividerTheme: DividerThemeData( // Theme for dividers
      color: Colors.grey[300],
      thickness: 1.0,
    ),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: _primaryDarkColor,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.red, // Keep swatch for compatibility
      accentColor: _secondaryDarkColor,
      backgroundColor: _backgroundDarkColor,
      cardColor: _cardDarkColor,
      brightness: Brightness.dark,
    ).copyWith(
      primary: _primaryDarkColor,
      secondary: _secondaryDarkColor,
      surface: _cardDarkColor,
      onPrimary: Colors.black, // Text on primary (adjust if needed)
      onSecondary: Colors.black, // Text on secondary (usually button text)
      onBackground: Colors.white70, // Text on background
      onSurface: Colors.white70, // Text on card/surface
      error: Colors.redAccent, // Default error color
      onError: Colors.white, // Text on error color
    ),
    scaffoldBackgroundColor: _backgroundDarkColor,
    appBarTheme: AppBarTheme(
      backgroundColor: _backgroundDarkColor, // Dark background for AppBar
      foregroundColor: _primaryDarkColor, // Use primary color for title/icons
      elevation: 0, // No elevation for a flatter dark look
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _primaryDarkColor, // Match foregroundColor
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryDarkColor, // Use primary color for buttons
        foregroundColor: Colors.black, // Text color on buttons
        shape: RoundedRectangleBorder(borderRadius: _defaultBorderRadius),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: 2,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: _defaultBorderRadius),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      color: _cardDarkColor, // Dark card color
      clipBehavior: Clip.antiAlias,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800], // Darker fill for text fields
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: _defaultBorderRadius,
        borderSide: BorderSide.none,
      ),
       enabledBorder: OutlineInputBorder(
        borderRadius: _defaultBorderRadius,
        borderSide: BorderSide(color: Colors.grey[700]!, width: 1.0), // Subtle border
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: _defaultBorderRadius,
        borderSide: const BorderSide(color: _primaryDarkColor, width: 2.0), // Primary color focus
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: _defaultBorderRadius,
        borderSide: BorderSide(color: Colors.redAccent.shade100, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: _defaultBorderRadius,
        borderSide: BorderSide(color: Colors.redAccent.shade200, width: 2.0),
      ),
      labelStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w500), // Lighter label
      hintStyle: TextStyle(color: Colors.grey[600]), // Darker hint
      prefixIconColor: Colors.grey[400], // Lighter prefix icon
      suffixIconColor: Colors.grey[500], // Lighter suffix icon
      errorStyle: TextStyle(color: Colors.redAccent.shade100, fontSize: 12, height: 1), // Lighter error text
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey[200]),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.grey[200]),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[200]),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.grey[200]),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[400]),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black), // Button text
    ),
     iconTheme: IconThemeData(
      color: Colors.grey[400], // Lighter default icons
      size: 24.0,
    ),
     dividerTheme: DividerThemeData(
      color: Colors.grey[700], // Darker divider
      thickness: 1.0,
    ),
  );
}
