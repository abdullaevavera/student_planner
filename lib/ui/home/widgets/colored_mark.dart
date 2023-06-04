import 'package:flutter/material.dart';

class ColoredMark extends StatelessWidget {
  final Color color;

  const ColoredMark({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: IconTheme.of(context).size,
        height: IconTheme.of(context).size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      );
}
