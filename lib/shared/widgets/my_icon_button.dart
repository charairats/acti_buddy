import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class MyIconButton extends StatelessWidget {
  const MyIconButton({super.key, this.icon, this.label, this.onPressed});

  final String? icon;
  final String? label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: cs.onSurface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Stack(
          children: [
            if (label != null)
              Center(
                child: Text(
                  label!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: cs.surface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (icon != null) Positioned(left: 0, child: Iconify(icon!)),
          ],
        ),
      ),
    );
  }
}
