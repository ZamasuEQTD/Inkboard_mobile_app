
import 'package:flutter/material.dart';

class Tag extends StatelessWidget {

  final Widget child;

  final Color? background;

  const Tag({super.key, required this.child, this.background});

  factory Tag.text(String text, {Color? background}) => Tag(
    background: background,
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600)
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      child: child,
    );
  }
}