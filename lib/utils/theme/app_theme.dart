import 'package:flutter/material.dart';


final scheme = ColorScheme.fromSeed(
  seedColor: Colors.black,
  brightness: Brightness.light,
).copyWith(
  primary: Colors.black,
  secondary: Colors.black,
  tertiary: Colors.black,
  surface: Colors.white,
  background: Colors.white,
  surfaceTint: Colors.transparent,

  surfaceContainerLowest: Colors.white,
  surfaceContainerLow: Colors.white,
  surfaceContainer: Colors.white,
  surfaceContainerHigh: Colors.white,
  surfaceContainerHighest: Colors.white,
);

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: scheme,
  fontFamily: 'OpenSans',

  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
    bodyLarge: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w400),

    titleSmall: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w600),

    headlineMedium: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700),
    headlineSmall: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400)
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(
      color: Color(0xFF9A9A9A),
      fontSize: 16,
    ),
  ),

  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.white,
  ),
  cardTheme: const CardThemeData(
    surfaceTintColor: Colors.transparent,
  ),
);