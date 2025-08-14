import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  // Gradientes
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [AppColors.secondary, AppColors.tertiary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [AppColors.tertiary, AppColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient priceGradient = LinearGradient(
    colors: [AppColors.success, AppColors.successDark],
  );

  // Decoraciones de cajas
  static BoxDecoration cardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    gradient: cardGradient,
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryWithOpacity(0.15),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration inputDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.primaryWithOpacity(0.3)),
    color: AppColors.secondaryWithOpacity(0.5),
  );

  static BoxDecoration dialogDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.primaryWithOpacity(0.3)),
  );

  static BoxDecoration priceDecoration = BoxDecoration(
    gradient: priceGradient,
    borderRadius: BorderRadius.circular(4),
    boxShadow: [
      BoxShadow(
        color: AppColors.successWithOpacity(0.3),
        blurRadius: 2,
        offset: const Offset(0, 1),
      ),
    ],
  );

  static BoxDecoration imageContainerDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(6),
    border: Border.all(color: AppColors.primaryWithOpacity(0.3)),
  );

  static BoxDecoration descriptionContainerDecoration = BoxDecoration(
    color: AppColors.secondaryWithOpacity(0.5),
    borderRadius: BorderRadius.circular(6),
    border: Border.all(color: AppColors.primaryWithOpacity(0.3)),
  );

  static BoxDecoration commentBadgeDecoration = BoxDecoration(
    color: AppColors.primaryWithOpacity(0.2),
    borderRadius: BorderRadius.circular(4),
  );

  // Estilos de texto
  static const TextStyle titleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    shadows: [Shadow(color: AppColors.primary, blurRadius: 2)],
  );

  static const TextStyle descriptionStyle = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  static const TextStyle priceStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle ratingStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle commentCountStyle = TextStyle(
    fontSize: 10,
    color: AppColors.primary,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle appBarTitleStyle = TextStyle(
    color: AppColors.primary,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.8,
  );

  // Estilos de botones
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.secondary,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static ButtonStyle successButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.success,
    foregroundColor: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static ButtonStyle errorButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.error,
    foregroundColor: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static ButtonStyle purpleButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.purple,
    foregroundColor: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: AppColors.textSecondary,
  );

  // Estilos de AppBar
  static AppBarTheme appBarTheme = const AppBarTheme(
    backgroundColor: AppColors.darkBackground,
    foregroundColor: AppColors.primary,
    elevation: 4,
    shadowColor: AppColors.primary,
    centerTitle: true,
    toolbarHeight: 48,
  );

  // Estilos de SnackBar
  static SnackBarThemeData snackBarTheme = SnackBarThemeData(
    backgroundColor: AppColors.success,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
