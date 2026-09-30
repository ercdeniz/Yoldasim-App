import 'package:flutter/material.dart';

extension ContextThemeExtention on BuildContext {
  // --- TEMEL ERİŞİMLER ---
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;

  // --- RENKLER ---
  Color get primary => colors.primary;
  Color get onSurface => colors.onSurface;
  Color get surface => colors.surface;
  Color get error => colors.error;
  Color get secondary => colors.secondary;
  Color get secondaryContainer => colors.secondaryContainer;

  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get cardColor => Theme.of(this).cardColor;

  // --- CİHAZ EKRAN BOYUTLARI ---
  double get widthScreen => MediaQuery.of(this).size.width;
  double get heightScreen => MediaQuery.of(this).size.height;
}
