import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';

// Кружок выбора цвета
class ColorOption extends StatelessWidget {
  final ProductColor option;
  final bool selected;
  final VoidCallback onTap;

  const ColorOption({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final checkColor =
        option.color.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

    return Tooltip(
      message: option.name,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 42,
          height: 42,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? AppColors.accent : Colors.transparent,
              width: 2.5,
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: option.color,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: selected
                ? Icon(Icons.check_rounded, size: 18, color: checkColor)
                : null,
          ),
        ),
      ),
    );
  }
}
