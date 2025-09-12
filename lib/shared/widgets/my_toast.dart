import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';

enum MyToastType { success, error, info }

class MyToast extends StatelessWidget {
  const MyToast({
    required this.type,
    required this.message,
    super.key,
  });

  void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            width: 2,
            color: type == MyToastType.success
                ? Colors.green
                : type == MyToastType.error
                ? Colors.red
                : Colors.blue,
          ),
        ),
        backgroundColor:
            (type == MyToastType.success
                    ? Colors.green
                    : type == MyToastType.error
                    ? Colors.red
                    : Colors.blue)
                .withAlpha(180),
        content: MyToast(type: type, message: message),
      ),
    );
  }

  final String message;
  final MyToastType type;

  @override
  Widget build(BuildContext context) {
    final color = type == MyToastType.success
        ? Colors.green
        : type == MyToastType.error
        ? Colors.red
        : Colors.blue;

    final icon = type == MyToastType.success
        ? Bi.check
        : type == MyToastType.error
        ? Bi.x_circle
        : Bi.info_circle;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Iconify(icon, color: Colors.white),
        const SizedBox(width: 8),
        Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
