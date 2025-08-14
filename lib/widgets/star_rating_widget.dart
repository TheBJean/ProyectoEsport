import 'package:flutter/material.dart';
import 'app_colors.dart';

class StarRatingWidget extends StatelessWidget {
  final double rating;
  final double size;
  final bool interactive;
  final Function(double)? onRatingChanged;
  final Color starColor;
  final Color emptyStarColor;

  const StarRatingWidget({
    Key? key,
    required this.rating,
    this.size = 16.0,
    this.interactive = false,
    this.onRatingChanged,
    this.starColor = AppColors.star,
    this.emptyStarColor = AppColors.textSecondary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1.0;
        final isFilled = rating >= starValue;
        final isPartial = rating > index && rating < starValue;
        final partialFill = isPartial ? (rating - index) : 0.0;

        return GestureDetector(
          onTap: interactive && onRatingChanged != null
              ? () => onRatingChanged!(starValue)
              : null,
          child: Container(
            margin: const EdgeInsets.only(right: 1),
            child: Stack(
              children: [
                // Empty star background
                Icon(
                  Icons.star_border,
                  color: emptyStarColor,
                  size: size,
                ),
                // Filled star overlay
                if (isFilled || isPartial)
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: isFilled ? 1.0 : partialFill,
                      child: Icon(
                        Icons.star,
                        color: starColor,
                        size: size,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
} 