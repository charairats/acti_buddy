import 'package:flutter/material.dart';

class MyChip extends StatelessWidget {
  const MyChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Chip(
      label: Text(label, style: TextStyle(color: cs.onSurface)),
    );
  }
}
