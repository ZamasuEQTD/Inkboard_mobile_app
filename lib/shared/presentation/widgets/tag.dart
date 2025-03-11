import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final Widget label;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? color;

  const Tag({
    super.key,
    required this.label,
    this.borderRadius,
    this.color,
    this.padding,
  });
  factory Tag.text(
    String text, {
    Key? key,
    BorderRadius? borderRadius,
    Color? color,
    EdgeInsets? padding,
    TextStyle? style,
  }) {
    return Tag(
      key: key,
      label: Text(text, style: style),
      borderRadius: borderRadius,
      color: color,
      padding: padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(5),
      child: ColoredBox(
        color: color ?? Colors.white,
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: label,
        ),
      ),
    );
  }
}
