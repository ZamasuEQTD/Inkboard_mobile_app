
import 'package:flutter/material.dart';

class LinearPercentageBackground extends StatelessWidget {
  final Color color;

  final double porcentaje;

  final BorderRadius? borderRadius;

  final Border? border;

  final Widget? child;
  const LinearPercentageBackground({
    super.key,
    required this.color,
    required this.porcentaje,
    this.borderRadius,
    this.border,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, Colors.transparent], // Verde y transparente
          stops: [
            porcentaje,
            porcentaje,
          ], // El verde ocupa el 50% y el transparente el otro 50%
          begin: Alignment.centerLeft, // Comienza desde la izquierda
          end: Alignment.centerRight, // Termina en la derecha
        ),
        borderRadius: borderRadius,
        border: border,
      ),
      child: child,
    );
  }
}