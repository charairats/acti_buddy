import 'package:acti_buddy/shared/widgets/enum.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyGradientText extends StatelessWidget {
  const MyGradientText({
    super.key,
    required this.text,
    this.size = MyWidgetSize.m,
    this.customStyle,
  });

  final String text;
  final MyWidgetSize size;
  final TextStyle? customStyle;

  @override
  Widget build(BuildContext context) {
    final fontSize = switch (size) {
      MyWidgetSize.xs => 8,
      MyWidgetSize.s => 16,
      MyWidgetSize.m => 24,
      MyWidgetSize.l => 32,
      MyWidgetSize.xl => 64,
    };
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [Colors.yellow, Colors.green],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      // The child widget to apply the gradient to
      child: Text(
        text,
        style:
            customStyle ??
            GoogleFonts.sriracha(
              fontSize: fontSize.toDouble(),
              // The color must be white for the gradient to show through
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
