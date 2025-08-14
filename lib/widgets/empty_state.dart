import 'package:flutter/material.dart';
import 'app_colors.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double iconSize;

  const EmptyState({
    Key? key,
    this.icon = Icons.games,
    required this.title,
    required this.subtitle,
    this.iconSize = 64,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: AppColors.primaryWithOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// Estados vacíos predefinidos
class EmptyStates {
  static const EmptyState noVideojuegos = EmptyState(
    title: 'No hay videojuegos',
    subtitle: 'No hay videojuegos disponibles',
  );

  static const EmptyState noVideojuegosAdmin = EmptyState(
    title: 'No hay videojuegos',
    subtitle: 'Agrega tu primer videojuego',
  );

  static const EmptyState noResenas = EmptyState(
    icon: Icons.comment_outlined,
    title: 'No hay reseñas aún',
    subtitle: 'Sé el primero en dejar una reseña',
    iconSize: 48,
  );
}
