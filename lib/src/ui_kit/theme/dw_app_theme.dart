import 'package:flutter/material.dart';

class DwAppTheme {
  DwAppTheme({
    required this.theme,
    required this.darkTheme,
    required this.themeMode,
  });
  
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode themeMode;

  DwAppTheme copyWith({
    ThemeData? theme,
    ThemeData? darkTheme,
    ThemeMode? themeMode,
  }) {
    return DwAppTheme(
      theme: theme ?? this.theme,
      darkTheme: darkTheme ?? this.darkTheme,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}