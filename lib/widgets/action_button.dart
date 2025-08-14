import 'package:flutter/material.dart';
import 'app_colors.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String tooltip;
  final double size;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.tooltip,
    this.size = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color, size: size),
      onPressed: onPressed,
      tooltip: tooltip,
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }
}

// Botones predefinidos para acciones comunes
class ActionButtons {
  static ActionButton edit({
    required VoidCallback onPressed,
    double size = 18,
  }) {
    return ActionButton(
      icon: Icons.edit,
      color: AppColors.warning,
      onPressed: onPressed,
      tooltip: 'Editar videojuego',
      size: size,
    );
  }

  static ActionButton delete({
    required VoidCallback onPressed,
    double size = 18,
  }) {
    return ActionButton(
      icon: Icons.delete,
      color: AppColors.error,
      onPressed: onPressed,
      tooltip: 'Eliminar videojuego',
      size: size,
    );
  }

  static ActionButton view({
    required VoidCallback onPressed,
    double size = 18,
  }) {
    return ActionButton(
      icon: Icons.visibility,
      color: AppColors.primary,
      onPressed: onPressed,
      tooltip: 'Ver reseñas',
      size: size,
    );
  }

  static ActionButton star({
    required VoidCallback onPressed,
    double size = 18,
  }) {
    return ActionButton(
      icon: Icons.star,
      color: AppColors.star,
      onPressed: onPressed,
      tooltip: 'Valorar',
      size: size,
    );
  }

  static ActionButton comment({
    required VoidCallback onPressed,
    double size = 18,
  }) {
    return ActionButton(
      icon: Icons.add_comment,
      color: AppColors.purple,
      onPressed: onPressed,
      tooltip: 'Agregar reseña',
      size: size,
    );
  }
}
