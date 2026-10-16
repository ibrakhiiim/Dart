import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Звёзды рейтинга
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;

  const RatingStars({super.key, required this.rating, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final IconData icon;
        if (rating >= index + 1) {
          icon = Icons.star_rounded;
        } else if (rating >= index + 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_border_rounded;
        }
        return Icon(icon, size: size, color: AppColors.star);
      }),
    );
  }
}
