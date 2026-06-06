import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary brand colors
  static const Color primary = Color(0xFFFF69B4);
  static const Color primaryLight = Color(0xFFFF69B4);
  static const Color primaryDark = Color(0xFFC2185B);

  // Accent
  static const Color accent = Color(0xFFFF6B35);
  static const Color accentYellow = Color(0xFFFFD700);

  // Background & surface
  static const Color background = Color(0xFFFFF8FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color scaffoldBg = Color(0xFFFFF8FC);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFFB0B0B0);

  // Loader / shimmer
  static const Color loaderColor = Color(0xFFE91E8C);
  static const Color loaderTrack = Color(0xFFFCE4EC);

  // Gradient stops for splash background
  static const List<Color> splashGradient = [
    Color(0xFFFFF0F7),
    Color(0xFFFFE4F0),
    Color(0xFFFFC8E4),
  ];
}
