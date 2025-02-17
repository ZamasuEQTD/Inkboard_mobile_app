import 'package:flutter/material.dart';
import 'package:inkboard/shared/presentation/styles/colors.dart';

final defaultFlatInputBorder = new OutlineInputBorder(
  borderSide: BorderSide.none, // Sin borde
  borderRadius: defaultBorderRadius,
);

final defaultBorderRadius = BorderRadius.circular(12);

final lightBorderRadius = BorderRadius.circular(6);

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
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      side: BorderSide.none,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      labelStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
    ),
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
    iconButtonTheme: IconButtonThemeData(
      style: _default.iconButtonTheme.style!.copyWith(
        backgroundColor: WidgetStatePropertyAll(AppLightColors.primary),
        iconColor: WidgetStatePropertyAll(AppLightColors.onPrimary),
      ),
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
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: lightBorderRadius),
        ),
        backgroundColor: WidgetStatePropertyAll(AppLightColors.primary),
        iconColor: WidgetStatePropertyAll(AppLightColors.onPrimary),
        foregroundColor: WidgetStatePropertyAll(AppLightColors.onPrimary),
      ),
    ),
  );
}
