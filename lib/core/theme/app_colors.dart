import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFE94057);
  static const Color primaryDark = Color(0xFF8A2387);
  static const Color primaryLight = Color(0xFFF27121);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0x66000000); // 40% opacity
  static const Color textPrimary70 = Color(0xB3000000); // 70% opacity
  
  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF3F3F3);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color backgroundDarkSecondary = Color(0xFF1E1E1E);

  // Dark mode text
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textPrimary70Dark = Color(0xB3FFFFFF); // 70% white
  static const Color borderDark = Color(0xFF2C2C2C);

  // Helpers — pick based on brightness
  static Color bg(Brightness b) =>
      b == Brightness.dark ? backgroundDark : background;
  static Color bgSecondary(Brightness b) =>
      b == Brightness.dark ? backgroundDarkSecondary : backgroundSecondary;
  static Color text(Brightness b) =>
      b == Brightness.dark ? textPrimaryDark : textPrimary;
  static Color text70(Brightness b) =>
      b == Brightness.dark ? textPrimary70Dark : textPrimary70;
  static Color borderColor(Brightness b) =>
      b == Brightness.dark ? borderDark : border;
  
  // Border Colors
  static const Color border = Color(0xFFE8E6EA);
  
  // Gradient
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment(-0.52, -0.85),
    end: Alignment(0.52, 0.85),
    colors: [
      Color(0xFFF27121), // 15%
      Color(0xFFE94057), // 58%
      Color(0xFF8A2387), // 93%
    ],
    stops: [0.15, 0.58, 0.93],
  );
}
