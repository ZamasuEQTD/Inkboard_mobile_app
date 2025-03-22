import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkboard/features/encuestas/domain/models/encuesta.dart';

class Encuesta extends StatelessWidget {
  final EncuestaModel encuesta;

  const Encuesta({super.key, required this.encuesta});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: ColoredBox(
        color: Colors.grey.shade200,
        child: Column(
          children: [
            ...this.encuesta.respuestas.map(
              (e) => RespuestaEncuesta(respuesta: e),
            ),
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Votos ',
                    children: [
                      TextSpan(
                        text: "${encuesta.votosTotales}",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text("Votar")),
              ],
            ),
          ],
        ).paddingSymmetric(horizontal: 10, vertical: 5),
      ),
    );
  }
}

class RespuestaEncuesta extends StatelessWidget {
  final RespuestaModel respuesta;

  const RespuestaEncuesta({super.key, required this.respuesta});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                children: [
                  Text(respuesta.respuesta, style: TextStyle(fontSize: 12)),
                  Row(
                    spacing: 4,
                    children: [
                      Text(
                        "${respuesta.votos} votos",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "33%",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                      if (true)
                        Icon(
                          Icons.check,
                          weight: 2.5,
                          color: Colors.green.shade500,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
