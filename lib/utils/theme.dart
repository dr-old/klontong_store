import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData> {
  /// Constructor initializes with dark theme
  ThemeCubit() : super(_lightTheme);

  // Define custom light and dark themes
  static final _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Color(0xfff5f5f8),
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.amber,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xfff5f5f8),
      foregroundColor: Colors.black,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Colors.black,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Colors.black,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Colors.black87,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Colors.black87,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Colors.black87,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: Colors.black,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: Colors.black,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: Colors.blueGrey,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontFamily: 'Poppins',
        color: Colors.black87,
      ), // BodyText1
      bodyMedium: TextStyle(
        fontSize: 14,
        fontFamily: 'Poppins',
        color: Colors.black54,
      ), // BodyText2
      bodySmall: TextStyle(
        fontSize: 12,
        fontFamily: 'Poppins',
        color: Colors.black45,
      ), // Caption
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: Colors.black,
      ), // Button
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: Colors.black,
      ), // Button smaller
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: Colors.black,
      ), // Overline
    ),
  );

  static final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.indigo,
    scaffoldBackgroundColor: Colors.black38,
    colorScheme: const ColorScheme.dark(
      primary: Colors.indigo,
      secondary: Colors.teal,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Colors.white,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Colors.white70,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Colors.white70,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Colors.white70,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: Colors.white70,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: Colors.white60,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: Colors.white60,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontFamily: 'Poppins',
        color: Colors.white70,
      ), // BodyText1
      bodyMedium: TextStyle(
        fontSize: 14,
        fontFamily: 'Poppins',
        color: Colors.white60,
      ), // BodyText2
      bodySmall: TextStyle(
        fontSize: 12,
        fontFamily: 'Poppins',
        color: Colors.white54,
      ), // Caption
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: Colors.indigo,
      ), // Button
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: Colors.indigo,
      ), // Button smaller
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: Colors.indigo,
      ), // Overline
    ),
  );

  /// Toggles the theme between light and dark mode
  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}
