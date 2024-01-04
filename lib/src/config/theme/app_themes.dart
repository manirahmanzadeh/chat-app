import 'package:flutter/material.dart';

mixin AppTheme {
  static ThemeData get light => ThemeData(
        primaryColor: const Color(0xFF08b2e3),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          outline: Color(0xFFCDCDCD),
          primary: Color(0xFF08b2e3),
          onPrimary: Colors.white,
          secondary: Color(0xFFefe9f4),
          onSecondary: Colors.black,
          error: Color(0xFFee6352),
          onError: Colors.white,
          background: Color(0xFFefe9f4),
          onBackground: Color(0xFF474747),
          surface: Color(0xFFF2F2F2),
          onSurface: Color(0xFF474747),
          errorContainer: Color(0xFFee6352),
          onErrorContainer: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF08b2e3),
          foregroundColor: Colors.black,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF08b2e3),
          foregroundColor: Colors.black,
        ),
    iconTheme: const IconThemeData(
      color: Color(0xFF08b2e3),
    )
      );
}
