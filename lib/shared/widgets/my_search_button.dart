import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';

class MySearchButton extends StatelessWidget {
  const MySearchButton({super.key, required this.hintText, this.onTap});

  final String hintText;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InputDecorator(
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Iconify(Bi.search, color: cs.onSurface.withAlpha(128)),
            ),
            filled: true,
            fillColor: cs.surfaceContainer,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
          ),
          child: Text(
            hintText,
            style: TextStyle(color: cs.onSurface.withAlpha(128), fontSize: 16),
          ),
        ),
      ),
    );
  }
}
