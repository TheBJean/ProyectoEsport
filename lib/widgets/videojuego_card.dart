import 'package:flutter/material.dart';
import '../models/videojuego.dart';
import 'app_colors.dart';
import 'app_styles.dart';
import 'star_rating_widget.dart';

class VideojuegoCard extends StatelessWidget {
  final Videojuego videojuego;
  final List<Widget>? actionButtons;
  final VoidCallback? onTap;

  const VideojuegoCard({
    Key? key,
    required this.videojuego,
    this.actionButtons,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: AppStyles.cardDecoration,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      videojuego.nombre,
                      style: AppStyles.titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (actionButtons != null) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actionButtons!,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              if (videojuego.imagenUrl != null && videojuego.imagenUrl!.isNotEmpty)
                _buildImageContainer(),
              _buildDescriptionContainer(),
              const SizedBox(height: 8),
              _buildBottomRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer() {
    return Container(
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: AppStyles.imageContainerDecoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: videojuego.imagenUrl!.startsWith('http')
            ? Image.network(
                videojuego.imagenUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildErrorImage();
                },
              )
            : Image.asset(
                videojuego.imagenUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildErrorImage();
                },
              ),
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      color: AppColors.secondary,
      child: const Icon(
        Icons.broken_image,
        color: AppColors.textSecondary,
        size: 24,
      ),
    );
  }

  Widget _buildDescriptionContainer() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: AppStyles.descriptionContainerDecoration,
      child: Text(
        videojuego.descripcion,
        style: AppStyles.descriptionStyle,
      ),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPriceTag(),
        _buildRatingSection(),
      ],
    );
  }

  Widget _buildPriceTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: AppStyles.priceDecoration,
      child: Text(
        '\$${videojuego.valor.toStringAsFixed(2)}',
        style: AppStyles.priceStyle,
      ),
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        StarRatingWidget(
          rating: videojuego.valoracion,
          size: 16,
          interactive: false,
        ),
        const SizedBox(width: 4),
        Text(
          videojuego.valoracion.toStringAsFixed(1),
          style: AppStyles.ratingStyle,
        ),
        if (videojuego.resenas != null && videojuego.resenas!.isNotEmpty) ...[
          const SizedBox(width: 8),
          _buildCommentBadge(),
        ],
      ],
    );
  }

  Widget _buildCommentBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: AppStyles.commentBadgeDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.comment, color: AppColors.primary, size: 10),
          const SizedBox(width: 2),
          Text(
            '${videojuego.resenas!.length}',
            style: AppStyles.commentCountStyle,
          ),
        ],
      ),
    );
  }
}
