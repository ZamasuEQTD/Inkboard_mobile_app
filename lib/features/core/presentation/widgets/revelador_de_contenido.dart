
import 'package:flutter/material.dart';
import 'package:inkboard/shared/presentation/widgets/effects/blur/blur.dart';

class ReveladorDeContenido extends StatefulWidget {
  final Widget child;

  final bool initialValue;

  const ReveladorDeContenido({
    super.key,
    required this.child,
    required this.initialValue,
  });

  @override
  State<ReveladorDeContenido> createState() => _ReveladorDeContenidoState();
}

class _ReveladorDeContenidoState extends State<ReveladorDeContenido> {
  late var ocultar = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: Blur(
            blurear: ocultar,
            child:
                !ocultar
                    ? SizedBox()
                    : ColoredBox(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 22),
                                ),
                                side: WidgetStatePropertyAll(
                                  BorderSide(color: Colors.white),
                                ),
                                foregroundColor: WidgetStatePropertyAll(
                                  Colors.white,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  ocultar = !ocultar;
                                });
                              },
                              child: FittedBox(
                                child: Text(
                                  "Ver contenido",
                                  style: TextStyle(
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
          ),
        ),
      ],
    );
  }
}