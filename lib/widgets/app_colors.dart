import 'package:flutter/material.dart';

class AppColors {
  // Colores principales
  static const Color primary = Color(0xFF66C0F4);
  static const Color secondary = Color(0xFF1B2838);
  static const Color tertiary = Color(0xFF2A475E);
  static const Color darkBackground = Color(0xFF171A21);
  static const Color dialogBackground = Color(0xFF1F2251);
  
  // Colores de texto
  static const Color textPrimary = Color(0xFFC7D5E0);
  static const Color textSecondary = Color(0xFF8F98A0);
  
  // Colores de estado
  static const Color success = Color(0xFF5C7E10);
  static const Color successDark = Color(0xFF4A6B0A);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color star = Color(0xFFFFD700);
  static const Color purple = Color(0xFF9B59B6);
  
  // Opacidades
  static Color primaryWithOpacity(double opacity) => primary.withValues(alpha: opacity);
  static Color secondaryWithOpacity(double opacity) => secondary.withValues(alpha: opacity);
  static Color successWithOpacity(double opacity) => success.withValues(alpha: opacity);
  static Color errorWithOpacity(double opacity) => error.withValues(alpha: opacity);
  static Color purpleWithOpacity(double opacity) => purple.withValues(alpha: opacity);
}
