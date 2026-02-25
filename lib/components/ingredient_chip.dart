import 'package:flutter/material.dart';

class IngredientChip extends StatelessWidget {
  final String label;
  final bool isAvailable;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const IngredientChip({
    super.key,
    required this.label,
    this.isAvailable = true,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final color = isAvailable
        ? const Color(0xFF6B9E7D)
        : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isAvailable ? color : Colors.grey.shade600,
          ),
        ),
        backgroundColor: color.withAlpha(20),
        deleteIcon: onRemove != null
            ? const Icon(Icons.close, size: 16)
            : null,
        onDeleted: onRemove,
        side: BorderSide.none,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
