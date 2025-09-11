import 'package:acti_buddy/acti_buddy.dart';
import 'package:acti_buddy/core/ui/icons.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class MyQuickActionButton extends StatelessWidget {
  const MyQuickActionButton({
    required this.icon,
    super.key,
    this.label,
    this.size = MyWidgetSize.xl,
    this.iconColor,
    this.onTap,
  });

  final String icon;
  final String? label;
  final MyWidgetSize size;
  final Color? iconColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = switch (size) {
      MyWidgetSize.xs => 16.0,
      MyWidgetSize.s => 32.0,
      MyWidgetSize.m => 48.0,
      MyWidgetSize.l => 72.0,
      MyWidgetSize.xl => 96.0,
    };
    final double iconSize = switch (size) {
      MyWidgetSize.xs => 8.0,
      MyWidgetSize.s => 12.0,
      MyWidgetSize.m => 16.0,
      MyWidgetSize.l => 24.0,
      MyWidgetSize.xl => 36.0,
    };
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: buttonWidth,
        width: buttonWidth * 0.95,
        child: Card(
          margin: EdgeInsets.zero,
          color: cs.surfaceContainerLow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Iconify(iconFromName(icon), color: cs.primary, size: iconSize),
                if (label != null) ...[
                  const SizedBox(height: 8),
                  Expanded(
                    child: Center(
                      child: Text(
                        label!,
                        style: TextStyle(
                          fontSize: 12,
                          color: iconColor ?? cs.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
