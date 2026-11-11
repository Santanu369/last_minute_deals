import 'package:flutter/material.dart';

class BasicTextStyle extends StatelessWidget {

  final String title;
  final double size;
  final FontWeight weight;
  final Color? color;
  final double? spacing;
  final double? height;
  final TextDecoration? decoration;
  final List<Shadow>? shadows;
  final TextAlign? textAlign;
  final int? maxLines;
  const BasicTextStyle({super.key, required this.title, required this.weight, required this.size, this.color, this.spacing, this.height, this.decoration, this.shadows, this.textAlign, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(title,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      decoration: decoration,
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: spacing,
        height: height,
        shadows: shadows,
    ),
    );
  }
}