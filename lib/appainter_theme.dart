import 'package:flutter/material.dart';

ThemeData buildTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFFFFA866),
    canvasColor: Color(0xFFFFFEF7),
    scaffoldBackgroundColor: Color(0xFFFFFEF7),
    cardColor: Color(0xFFFFFEF7),
    dividerColor: Color(0xFF79747E),
    splashColor: Color(0x66C8C8C8),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFD0F06700),
      iconTheme: IconThemeData(
        color: Color(0xFF000000),
      ),
      toolbarTextStyle: TextStyle(
        color: Color(0xFFFFFFFF),
        decoration: TextDecoration.none,
        fontFamily: 'Roboto',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
        textBaseline: TextBaseline.alphabetic,
      ),
    ),
    buttonTheme: ButtonThemeData(
      alignedDropdown: false,
      height: 36,
      minWidth: 88,
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.elliptical(2, 2)),
      ),
      buttonColor: Color.fromARGB(255, 130, 69, 23), // Add other button properties based on JSON data
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black, // Text color
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, backgroundColor: Color(0xFFFFA866), // Text color
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black, side: BorderSide(color: Colors.black), // Border color
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: Color(0xDD000000),
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        textBaseline: TextBaseline.alphabetic,
      ),
      bodyMedium: TextStyle(
        color: Color(0xDD000000),
        fontFamily: 'Roboto',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        textBaseline: TextBaseline.alphabetic,
      ),
      bodySmall: TextStyle(
        color: Color(0x8A000000),
        fontFamily: 'Roboto',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        textBaseline: TextBaseline.alphabetic,
      ),
      // Add other text styles based on JSON data
    ),
    colorScheme: ColorScheme(
      background: Color(0xFFFFC294),
      brightness: Brightness.light,
      error: Color(0xFFB00020),
      onError: Color(0xFFFFFFFF),
      primary: Color(0xFFFFA866),
      onPrimary: Color(0xFF000000),
      secondary: Color(0xFFFFA866),
      onSecondary: Color(0xFF000000),
      surface: Color(0xFFFFC294),
      onSurface: Color(0xFF000000),
      // Add other color scheme properties based on JSON data
    ),
  );
}
