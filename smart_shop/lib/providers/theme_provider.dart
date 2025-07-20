import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  static const String _themeKey = 'theme_mode';

  ThemeProvider(this.prefs) {
    _loadTheme();
  }

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? _darkTheme : _lightTheme;

  void _loadTheme() {
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }


  static final _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFFF8E1),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFB08968),
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFDDB892),
      onPrimaryContainer: Color(0xFF3E2723),
      secondary: Color(0xFFF57C00),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFFFE0B2),
      onSecondaryContainer: Color(0xFF3E2723),
      tertiary: Color(0xFFE6CCB2),
      onTertiary: Color(0xFF3E2723),
      tertiaryContainer: Color(0xFFFFF3E0),
      onTertiaryContainer: Color(0xFF3E2723),
      background: Color(0xFFFFF8E1),
      onBackground: Color(0xFF3E2723),
      surface: Color(0xFFFFF3E0),
      onSurface: Color(0xFF3E2723),
      surfaceVariant: Color(0xFFFFF3E0),
      onSurfaceVariant: Color(0xFF5D4037),
      error: Colors.red,
      onError: Colors.white,
      errorContainer: Color(0xFFFFCDD2),
      onErrorContainer: Color(0xFFB71C1C),
      outline: Color(0xFF8D6E63),
      outlineVariant: Color(0xFFD7CCC8),
      shadow: Colors.black,
      scrim: Colors.black26,
      inverseSurface: Color(0xFF3E2723),
      onInverseSurface: Color(0xFFFFF8E1),
      inversePrimary: Color(0xFF8D6E63),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFF3E0),
      foregroundColor: Color(0xFF3E2723),
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFB08968),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF3E2723),
        side: const BorderSide(color: Color(0xFFB08968)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFB08968),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFFF3E0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFB08968)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFB08968), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD7CCC8)),
      ),
      hintStyle: const TextStyle(color: Color(0xFF8D6E63)),
      labelStyle: const TextStyle(color: Color(0xFF5D4037)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFFFFF3E0),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFFFFF8E1),
      surfaceTintColor: Colors.transparent,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFE6CCB2),
      selectedColor: const Color(0xFFB08968),
      disabledColor: const Color(0xFFEFEBE9),
      labelStyle: const TextStyle(color: Color(0xFF3E2723)),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFD7CCC8),
      thickness: 1,
    ),
    iconTheme: const IconThemeData(color: Color(0xFF3E2723)),
    primaryIconTheme: const IconThemeData(color: Color(0xFF3E2723)),
  );

  
  static final _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Colors.white,
      onPrimary: Colors.black,
      surface: Colors.black,
      background: Colors.black,
      onSurface: Colors.white,
      onBackground: Colors.white,
      secondary: Colors.white,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
   
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      labelStyle: const TextStyle(color: Colors.white),
      hintStyle: TextStyle(color: Colors.grey[600]),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey[800]!,
      thickness: 1,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    primaryIconTheme: const IconThemeData(color: Colors.white),
  );
}
