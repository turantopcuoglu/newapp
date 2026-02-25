import 'package:flutter/material.dart';
import '../core/enums.dart';
import '../l10n/app_localizations.dart';

class MealTypeBadge extends StatelessWidget {
  final MealType mealType;

  const MealTypeBadge({super.key, required this.mealType});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withAlpha(80)),
      ),
      child: Text(
        _label(l10n),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }

  String _label(AppLocalizations l10n) {
    switch (mealType) {
      case MealType.breakfast:
        return l10n.recipeBreakfast;
      case MealType.lunch:
        return l10n.recipeLunch;
      case MealType.dinner:
        return l10n.recipeDinner;
      case MealType.snack:
        return l10n.recipeSnack;
    }
  }

  Color get _color {
    switch (mealType) {
      case MealType.breakfast:
        return const Color(0xFFFFA726);
      case MealType.lunch:
        return const Color(0xFF66BB6A);
      case MealType.dinner:
        return const Color(0xFF5C6BC0);
      case MealType.snack:
        return const Color(0xFFAB47BC);
    }
  }
}
