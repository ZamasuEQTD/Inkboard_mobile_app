import 'dart:ui';

import 'package:flutter/material.dart';

class Blur extends StatelessWidget {

  final bool blurear;

  final Widget child;


  const Blur({super.key, this.child =const SizedBox(), this.blurear = true, });

  @override
  Widget build(BuildContext context) {
    Widget child = this.child;

    if (blurear) {
      child = BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 9,
          sigmaY: 9,
          tileMode: TileMode.decal
        ),
        child: child,
      );
    }

    return child;
  }
}