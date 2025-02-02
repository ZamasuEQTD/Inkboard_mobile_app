import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final Widget child;

  final Color? background;
  final EdgeInsets? padding;

  const Tag({super.key, required this.child, this.background, this.padding});

  factory Tag.text(String text, {Color? background, TextStyle? style, EdgeInsets? padding}) =>
      Tag(
        background: background,
        padding: padding,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600).merge(style)),
      );

  @override
  Widget build(BuildContext context) {
    Widget child = this.child;

    if (padding != null) {
      child = Padding(padding: padding!, child: child);
    }

    if (background != null) {
      child = ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        child: ColoredBox(color: background!, child: child),
      );
    }

    return child;
  }
}
