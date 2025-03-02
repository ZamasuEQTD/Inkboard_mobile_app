import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkboard/features/hilos/domain/models/comentario_model.dart';
import 'package:inkboard/features/media/domain/models/media.dart';
import 'package:inkboard/features/media/presentation/widgets/media_box.dart';
import 'package:inkboard/shared/presentation/util/color_picker.dart';
import 'package:inkboard/shared/presentation/util/extensions/duration_extension.dart';
import 'package:inkboard/shared/presentation/widgets/effects/gradient/animated_gradient.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../logic/controllers/hilo_page_controller.dart';

final EdgeInsets comentarioPadding = EdgeInsets.all(8);

final BorderRadius comentarioRadius = BorderRadius.circular(12);

class ComentarioWidget extends StatelessWidget {
  final ComentarioModel comentario;
  const ComentarioWidget({super.key, required this.comentario});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: comentarioRadius,
          child: ColoredBox(
            color: Theme.of(context).colorScheme.secondary,
            child: Padding(
              padding: comentarioPadding,
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
                            ColorComentario(comentario: comentario),
                            Flexible(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 4,
                                runSpacing: 4,
                                children: tags,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(comentario.createdAt.tiempoTranscurrido),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Wrap(spacing: 2, runSpacing: 4, children: taggueadoPor),
                  if (comentario.media != null) media,
                  Text(comentario.texto),
                ],
              ),
            ),
          ),
        ).marginSymmetric(vertical: 4),

        // Positioned(
        //   left: -25,
        //   child: SizedBox.square(
        //     dimension: 50,
        //     child: ColoredBox(color: Colors.red),
        //   ),
        // ),
      ],
    );
  }

  void _onTagguear() {
    return Get.find<HiloPageController>().tagguear(comentario.tag);
  }

  List<Widget> get tags => [
    Text(comentario.autor, style: TextStyle(fontWeight: FontWeight.bold)),
    if (comentario.esOp) Chip(label: Text("OP")),
    if (comentario.destacado)
      Chip(backgroundColor: Colors.yellow.shade300, label: Text("Destacado")),
    MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _onTagguear,
        child: Chip(label: Text(comentario.tag)),
      ),
    ),
    if (comentario.tagUnico != null)
      Chip(
        backgroundColor: ColorPicker.generar(comentario.tagUnico!),
        label: Text(
          comentario.tagUnico!,
          style: TextStyle(color: Colors.white),
        ),
      ),
  ];

  List<Widget> get taggueadoPor =>
      comentario.respondidoPor
          .map<Widget>(
            (tag) => MouseRegion(
              onEnter: (event) {},
              onExit: (event) {},
              child: Text(
                ">>$tag",
                style: TextStyle(color: CupertinoColors.link, fontSize: 16),
              ),
            ),
          )
          .toList();

  Widget get media => Center(
    child: MediaBox(
      style: DimensionableStyle(radius: BorderRadius.circular(10)),
      media: MediaSource(
        source: MediaSourceType.network,
        model: comentario.media!,
      ),
    ).marginSymmetric(vertical: 5),
  );
}

class ColorComentario extends StatelessWidget {
  static final HashMap<String, Widget> _colors = HashMap.from({
    "rojo": ColoredBox(color: Colors.red),
    "verde": ColoredBox(color: Colors.green),
    "azul": ColoredBox(color: Colors.blue),
    "amarillo": ColoredBox(color: Colors.yellow),
    "multi": MultiColor(),
    "invertido": MultiInvertido(),
  });

  final ComentarioModel comentario;
  const ColorComentario({super.key, required this.comentario});

  @override
  Widget build(BuildContext context) {
    Widget color = _colors[comentario.color.toLowerCase()]!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Stack(
        children: [
          SizedBox.square(dimension: 50, child: color),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(2),
              child: FittedBox(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get label => comentario.dados ?? (comentario.esOp ? "OP" : comentario.autorRole);
}

class ComentarioSkeleton extends StatelessWidget {
  static final Random _random = Random();

  const ComentarioSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: comentarioRadius,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.secondary,
        child: Padding(
          padding: comentarioPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2.5,
            children: [
              Row(
                spacing: 4,
                children: [
                  Bone.square(size: 50, borderRadius: BorderRadius.circular(4)),
                  Bone(
                    width: 100,
                    height: 14,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
              if (_random.nextBool())
                Bone(
                  width: 250,
                  height: 150,
                  borderRadius: BorderRadius.circular(4),
                ),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: List.generate(
                  _random.nextInt(10),
                  (index) => Bone(
                    height: 16,
                    width: _random.nextInt(200) + 20,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MultiColor extends LinearGradientAnimation {
  static const List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue,
  ];

  const MultiColor({super.key}) : super(colors: _colors);
}

class MultiInvertido extends LinearGradientAnimation {
  static const List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue,
  ];

  const MultiInvertido({super.key}) : super(colors: _colors, reverse: true);
}
