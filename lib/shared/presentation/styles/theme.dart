import 'package:flutter/material.dart';
import 'package:inkboard/shared/presentation/styles/colors.dart';

final defaultFlatInputBorder = new OutlineInputBorder(
  borderSide: BorderSide.none, // Sin borde
  borderRadius: defaultBorderRadius,
);

final defaultBorderRadius = BorderRadius.circular(12);

final shortInputBorderRadius = BorderRadius.circular(6);

final defaultButtonStyle = ButtonStyle(
  elevation: WidgetStatePropertyAll(0),
  textStyle: WidgetStatePropertyAll(
    TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 16,
    ),
  ),
  padding: WidgetStatePropertyAll(
    EdgeInsets.symmetric(horizontal: 16, vertical: 22),
  ),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: defaultBorderRadius,
    ),
  ),
);

class AppThemes {
  const AppThemes._();

  static final ThemeData _default = ThemeData(
    fontFamily: "Poppins",
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: defaultFlatInputBorder,
      enabledBorder: defaultFlatInputBorder,
      focusedBorder: defaultFlatInputBorder,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: defaultButtonStyle,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: defaultButtonStyle),
  );

  static final ThemeData light = _default.copyWith(
    dialogTheme: DialogTheme(
      backgroundColor: AppLightColors.surface,
    ),
    scaffoldBackgroundColor: AppLightColors.surface,
    brightness: Brightness.light,
    inputDecorationTheme: _default.inputDecorationTheme.copyWith(
      fillColor: AppLightColors.inputBackground, // Color de fondo
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: _default.outlinedButtonTheme.style!.copyWith(
        iconColor: WidgetStatePropertyAll(Colors.black),
        foregroundColor: WidgetStatePropertyAll(Colors.black),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _default.elevatedButtonTheme.style!.copyWith(
        backgroundColor: WidgetStatePropertyAll(AppLightColors.primary),
        iconColor: WidgetStatePropertyAll(AppLightColors.onPrimary),
        foregroundColor: WidgetStatePropertyAll(AppLightColors.onPrimary),
      ),
    ),
  );
}
