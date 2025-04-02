import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:inkboard/features/encuestas/domain/models/encuesta.dart';
import 'package:inkboard/features/encuestas/presentation/encuesta_signalr_hub.dart';

class EncuestaController extends GetxController {
  final Rx<String?> seleccionado = Rx(null);

  void seleccionar(String id) {
    if (seleccionado.value == id) {
      seleccionado.value = null;
    } else {
      seleccionado.value = id;
    }
  }

  bool get haySeleccionado => seleccionado.value != null;
}

class Encuesta extends StatefulWidget {
  final EncuestaModel encuesta;

  final void Function(String respuesta) onVotar;
  final void Function(String respuesta) onVotado;
  const Encuesta({super.key, required this.encuesta, required this.onVotar, required this.onVotado});

  @override
  State<Encuesta> createState() => _EncuestaState();
}

class _EncuestaState extends State<Encuesta> {
  final EncuestaController controller = EncuestaController();

  @override
  void initState() {
    var hub = EncuestaSignalRHub()..init(  widget.encuesta.id);

    hub.onUltimoVoto.listen((event) {
      widget.onVotado(event);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder:
          (controller) => ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ColoredBox(
              color: Theme.of(context).colorScheme.surface,
              child: Obx(
                () => Column(
                  children: [
                    ...respuestas,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Votos ',
                            children: [
                              TextSpan(
                                text: "${widget.encuesta.votosTotales}",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Obx(
                          () => ElevatedButton(
                            style:
                                controller.haySeleccionado
                                    ? ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Color.fromRGBO(107, 114, 128, 0.55),
                                      ),
                                    )
                                    : null,
                            onPressed: () {
                              if (haVotado) return;

                              if (controller.haySeleccionado) {
                                widget.onVotar(controller.seleccionado.value!);
                              }
                            },
                            child: Text("Votar"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).paddingSymmetric(horizontal: 10, vertical: 5),
            ),
          ),
    );
  }

  List<Widget> get respuestas {
    List<Widget> respuestas = [];

    for (int i = 0; i < widget.encuesta.respuestas.length; i++) {
      final respuesta = this.widget.encuesta.respuestas[i];
      final isLast = i == this.widget.encuesta.respuestas.length - 1;

      Widget widget = RespuestaEncuesta(
        respuesta: respuesta,
        onSeleccionar: () {
          if (!haVotado) controller.seleccionar(respuesta.id);
        },
        porcentaje:
            this.widget.encuesta.votosTotales == 0
                ? 0
                : respuesta.votos / this.widget.encuesta.votosTotales,
        isSeleccionado:
            controller.seleccionado.value != null &&
            controller.seleccionado.value == respuesta.id,
        isVotado: this.widget.encuesta.respuestaVotada == respuesta.id,
      );

      if (!isLast) {
        widget = widget.marginOnly(bottom: 5);
      }

      respuestas.add(widget);
    }

    return respuestas;
  }

  bool get haVotado => widget.encuesta.respuestaVotada != null;
}

class RespuestaEncuesta extends StatelessWidget {
  final bool isSeleccionado;
  final bool isVotado;

  final double porcentaje;
  final RespuestaModel respuesta;

  final void Function() onSeleccionar;

  const RespuestaEncuesta({
    super.key,
    required this.respuesta,
    required this.isSeleccionado,
    required this.onSeleccionar,
    required this.porcentaje,
    required this.isVotado,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSeleccionar,
      child: LinearPercentageBackground(
        color: Color.fromRGBO(209, 213, 219, 0.45),
        border: Border.all(
          color:
              isVotado || isSeleccionado
                  ? Theme.of(context).colorScheme.outline
                  : Color(0x80D1D5DB),
        ),
        borderRadius: BorderRadius.circular(10),
        porcentaje: porcentaje,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(respuesta.respuesta)),
              Row(
                spacing: 2,
                children: [
                  Text(
                    "${respuesta.votos} votos",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromRGBO(115, 115, 115, 0.9),
                    ),
                  ),
                  Text(
                    "${(porcentaje * 100).toInt()}%",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  if (isSeleccionado)
                    ClipOval(
                      child: ColoredBox(
                        color: Color.fromRGBO(115, 115, 115, 0.45),
                        child: SizedBox.square(
                          dimension: 20,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: FittedBox(
                              child: Icon(Icons.check, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ).animate().scale(
                      curve: Curves.bounceInOut,
                      duration: Duration(milliseconds: 300),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

