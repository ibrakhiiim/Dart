import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Счётчик количества
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final bool compact;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final height = compact ? 36.0 : 52.0;
    final buttonWidth = compact ? 32.0 : 40.0;
    final radius = compact ? 12.0 : 16.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Кнопка минус
          _StepButton(
            icon: Icons.remove_rounded,
            onTap: onDecrement,
            width: buttonWidth,
            height: height,
            radius: radius,
          ),
          // Количество
          SizedBox(
            width: compact ? 24 : 28,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: compact ? 14 : 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // Кнопка плюс
          _StepButton(
            icon: Icons.add_rounded,
            onTap: onIncrement,
            width: buttonWidth,
            height: height,
            radius: radius,
          ),
        ],
      ),
    );
  }
}

// Кнопка шага
class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final double radius;

  const _StepButton({
    required this.icon,
    required this.onTap,
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: Icon(
          icon,
          size: 18,
          color: onTap == null ? AppColors.textSecondary : AppColors.primary,
        ),
      ),
    );
  }
}
