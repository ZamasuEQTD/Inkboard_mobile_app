import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkboard/features/hilos/domain/models/comentario_model.dart';
import 'package:inkboard/shared/presentation/util/color_picker.dart';

import '../logic/controllers/hilo_page_controller.dart';

class ComentarioWidget extends StatelessWidget {
  final ComentarioModel comentario;
  const ComentarioWidget({
    super.key,
    required this.comentario,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ColoredBox(
        color: Colors.grey.shade200,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 4,
                      children: [
                        ColorComentario(
                          comentario: comentario,
                        ),
                        Flexible(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              Text(
                                comentario.autor,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (comentario.esOp) Chip(label: Text("OP")),
                              if (comentario.destacado)
                                Chip(
                                  backgroundColor: Colors.yellow.shade300,
                                  label: Text("Destacado"),
                                ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: _onTagguear,
                                  child: Chip(
                                    label: Text(this.comentario.tag),
                                  ),
                                ),
                              ),
                              if (comentario.tagUnico != null)
                                Chip(
                                  backgroundColor:
                                      ColorPicker.generar(comentario.tagUnico!),
                                  label: Text(
                                    "XAS",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text("2m"),
                      IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
                    ],
                  )
                ],
              ),
              Text(comentario.texto)
            ],
          ),
        ),
      ),
    ).marginSymmetric(vertical: 4);
  }

  void _onTagguear() {
    return Get.find<HiloPageController>().tagguear(comentario.tag);
  }
}

class ColorComentario extends StatelessWidget {
  final ComentarioModel comentario;
  const ColorComentario({
    super.key,
    required this.comentario,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox.square(
        dimension: 50,
        child: ColoredBox(
          color: Colors.red.shade500,
          child: Padding(
            padding: EdgeInsets.all(2),
            child: FittedBox(
              child: Text(
                "ANON",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String get label => comentario.dados ?? (comentario.esOp ? " OP" : "ANON");
}
