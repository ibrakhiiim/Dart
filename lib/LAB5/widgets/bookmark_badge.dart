import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'circle_icon_button.dart';

// Кнопка закладки
class BookmarkBadge extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onTap;

  const BookmarkBadge({
    super.key,
    required this.isBookmarked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CircleIconButton(
      tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark',
      icon: isBookmarked
          ? Icons.bookmark_rounded
          : Icons.bookmark_border_rounded,
      iconColor: isBookmarked ? AppColors.accent : AppColors.primary,
      onTap: onTap,
    );
  }
}
