import 'package:flutter/material.dart';

class AppTheme {
  static const double paddingTiny = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMediumSmall = 12.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingHuge = 32.0;

  static ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 169, 211));


  // Varierbar text
  static TextStyle get headingStyle => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  
  static TextStyle get subheadingStyle => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );
  
  static TextStyle get bodyStyle => TextStyle(
    fontSize: 16,
    color: Colors.black54,
  );
  
  static TextStyle get smallStyle => TextStyle(
    fontSize: 14,
    color: Colors.black45,
  );
}
