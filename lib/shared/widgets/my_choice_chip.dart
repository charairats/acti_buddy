import 'package:flutter/material.dart';

class MyChoiceChip extends StatelessWidget {
  const MyChoiceChip({
    required this.label,
    required this.selected,
    super.key,
    this.onSelected,
  });

  final String label;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      showCheckmark: false,
      selectedColor: cs.primary,
      labelStyle: TextStyle(
        color: selected ? cs.onPrimary : cs.onSurface,
      ),
    );
  }
}
