import 'package:flutter/material.dart';

/// A utility class for providing app-wide theme configurations.
///
/// Contains static methods to easily access theme data for consistent styling.
class AppTheme {
  /// Returns a pre-configured light theme for the application.
  ///
  /// Features:
  /// - Primary color swatch: Indigo
  /// - Secondary header color: Teal
  /// - Scaffold background: Light grey
  /// - Custom text styles for titles and body text
  /// - Card styling with rounded corners and elevation
  /// - Input decoration with rounded borders
  static ThemeData get light {
    return ThemeData(
      primarySwatch: Colors.indigo,
      secondaryHeaderColor: Colors.teal,
      scaffoldBackgroundColor: Colors.grey[100],
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 16),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
