import 'package:flutter/material.dart';

import '../core/theme.dart';

/// The tick next to a meal in a meal list: filled once the meal is logged as
/// cooked, hollow while it is still only planned.
///
/// Cooked state is the single input to the nutrition summary, so this control
/// is how the list and the summary stay one story instead of two.
class CookedTick extends StatelessWidget {
  final bool isCooked;
  final VoidCallback? onTap;
  final String tooltip;
  final double size;

  const CookedTick({
    super.key,
    required this.isCooked,
    required this.onTap,
    required this.tooltip,
    this.size = 26,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isCooked
                ? AppTheme.successGreen
                : AppTheme.successGreen.withAlpha(12),
            shape: BoxShape.circle,
            border: Border.all(
              color: isCooked
                  ? AppTheme.successGreen
                  : AppTheme.dividerColor,
              width: 1.5,
            ),
          ),
          child: Icon(
            isCooked ? Icons.check_rounded : Icons.restaurant_rounded,
            size: size * 0.58,
            color: isCooked ? Colors.white : AppTheme.textLight,
          ),
        ),
      ),
    );
  }
}
