import 'package:flutter/material.dart';

const appPrimaryBlue = Color(0xFF2A56EF);

const _lightBackground = Color(0xFFE9F1FC);
const _lightSurface = Colors.white;
const _lightSurfaceAlt = Color(0xFFF8F8F8);
const _lightText = Colors.black;
const _lightTextSecondary = Color(0xFF525252);
const _lightHint = Color(0xFF9A9A9A);
const _lightBorder = Color(0x26000000);

const _darkBackground = Color(0xFF262626);
const _darkSurface = Color(0xFF525252);
const _darkSurfaceAlt = Color(0xFF525252);
const _darkText = Colors.white;
const _darkTextSecondary = Colors.white70;
const _darkHint = Colors.white60;
const _darkBorder = Color(0x66FFFFFF);

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color textPrimary;
  final Color textSecondary;
  final Color hint;
  final Color border;
  final Color iconButtonBackground;
  final Color navBackground;
  final Color navInactiveIcon;

  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.textPrimary,
    required this.textSecondary,
    required this.hint,
    required this.border,
    required this.iconButtonBackground,
    required this.navBackground,
    required this.navInactiveIcon,
  });

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? textPrimary,
    Color? textSecondary,
    Color? hint,
    Color? border,
    Color? iconButtonBackground,
    Color? navBackground,
    Color? navInactiveIcon,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      hint: hint ?? this.hint,
      border: border ?? this.border,
      iconButtonBackground: iconButtonBackground ?? this.iconButtonBackground,
      navBackground: navBackground ?? this.navBackground,
      navInactiveIcon: navInactiveIcon ?? this.navInactiveIcon,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;

    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      hint: Color.lerp(hint, other.hint, t)!,
      border: Color.lerp(border, other.border, t)!,
      iconButtonBackground: Color.lerp(iconButtonBackground, other.iconButtonBackground, t)!,
      navBackground: Color.lerp(navBackground, other.navBackground, t)!,
      navInactiveIcon: Color.lerp(navInactiveIcon, other.navInactiveIcon, t)!,
    );
  }
}

const lightAppColors = AppColors(
  background: _lightBackground,
  surface: _lightSurface,
  surfaceAlt: _lightSurfaceAlt,
  textPrimary: _lightText,
  textSecondary: _lightTextSecondary,
  hint: _lightHint,
  border: _lightBorder,
  iconButtonBackground: _lightSurface,
  navBackground: _lightSurface,
  navInactiveIcon: _lightText,
);

const darkAppColors = AppColors(
  background: _darkBackground,
  surface: _darkSurface,
  surfaceAlt: _darkSurfaceAlt,
  textPrimary: _darkText,
  textSecondary: _darkTextSecondary,
  hint: _darkHint,
  border: _darkBorder,
  iconButtonBackground: _darkSurface,
  navBackground: _darkSurface,
  navInactiveIcon: _darkText,
);

TextTheme _buildTextTheme(Color textColor) {
  return TextTheme(
    bodySmall: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w400),
    bodyLarge: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.w400),
    titleSmall: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(color: textColor, fontSize: 28, fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.w700),
    headlineSmall: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w400),
  );
}

ThemeData _buildTheme({
  required Brightness brightness,
  required AppColors colors,
}) {
  final scheme = ColorScheme.fromSeed(
    seedColor: appPrimaryBlue,
    brightness: brightness,
  ).copyWith(
    primary: appPrimaryBlue,
    secondary: appPrimaryBlue,
    tertiary: appPrimaryBlue,
    surface: colors.surface,
    background: colors.background,
    onSurface: colors.textPrimary,
    onBackground: colors.textPrimary,
    surfaceTint: Colors.transparent,
    surfaceContainerLowest: colors.surface,
    surfaceContainerLow: colors.surface,
    surfaceContainer: colors.surface,
    surfaceContainerHigh: colors.surface,
    surfaceContainerHighest: colors.surface,
  );

  final textTheme = _buildTextTheme(colors.textPrimary);

  final inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide.none,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    fontFamily: 'OpenSans',
    textTheme: textTheme,
    extensions: const <ThemeExtension<dynamic>>[],
  ).copyWith(
    extensions: <ThemeExtension<dynamic>>[
      colors,
    ],
    scaffoldBackgroundColor: colors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: colors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      foregroundColor: colors.textPrimary,
      titleTextStyle: textTheme.headlineMedium,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      surfaceTintColor: Colors.transparent,
      backgroundColor: colors.surface,
    ),
    cardTheme: CardThemeData(
      color: colors.surface,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: colors.hint,
        fontSize: 16,
      ),
      filled: true,
      fillColor: colors.surface,
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: inputBorder,
      disabledBorder: inputBorder,
      errorBorder: inputBorder,
      focusedErrorBorder: inputBorder,
    ),
  );
}

final lightTheme = _buildTheme(
  brightness: Brightness.light,
  colors: lightAppColors,
);

final darkTheme = _buildTheme(
  brightness: Brightness.dark,
  colors: darkAppColors,
);

extension AppThemeX on BuildContext {
  AppColors get appColors =>
      Theme.of(this).extension<AppColors>()!;
}