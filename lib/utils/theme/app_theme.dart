import 'package:flutter/material.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'OpenSans',

  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
    bodyLarge: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w400),

    titleSmall: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w600),

    headlineMedium: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700),
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