import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class MyLoading extends StatelessWidget {
  const MyLoading({super.key});

  static bool _isShowing = false;

  static void show(BuildContext context) {
    _isShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const MyLoading(),
    );
  }

  static void hide(BuildContext context) {
    if (!_isShowing) return;
    context.pop();
    _isShowing = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SpinKitFadingCube(
      color: cs.primary,
      size: 36,
      duration: Duration(milliseconds: 1200),
    );
  }
}
