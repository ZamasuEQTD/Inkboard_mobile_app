import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/auth/presentation/logic/controllers/auth_controller.dart';
import 'package:inkboard/features/comentarios/domain/icomentarios_repository.dart';
import 'package:inkboard/features/hilos/domain/models/comentario_model.dart';
import 'package:inkboard/features/media/domain/models/media.dart';
import 'package:inkboard/features/media/presentation/widgets/media_box.dart';
import 'package:inkboard/shared/presentation/util/color_picker.dart';
import 'package:inkboard/shared/presentation/util/extensions/duration_extension.dart';
import 'package:inkboard/shared/presentation/widgets/effects/gradient/animated_gradient.dart';
import 'package:inkboard/shared/presentation/widgets/grupo_seleccionable/grupo_seleccionable.dart';
import 'package:inkboard/shared/presentation/widgets/tag.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../logic/controllers/hilo_page_controller.dart';

final EdgeInsets comentarioPadding = EdgeInsets.all(8);

final BorderRadius comentarioRadius = BorderRadius.circular(12);

class ComentarioWidget extends StatelessWidget {
  final ComentarioModel comentario;
  const ComentarioWidget({super.key, required this.comentario});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress:
          () => Get.bottomSheet(
            BottomSheet(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              onClosing: () {},
              builder:
                  (context) => GrupoSeleccionableSliverSheet(
                    grupos: [
                      GrupoSeleccionableItem(
                        seleccionables: [
                          SeleccionableItem(
                            titulo: "Reportar",
                            leading: Icon(Icons.flag_outlined),
                          ),
                          SeleccionableItem(
                            titulo: "Ocultar",
                            leading: Icon(Icons.visibility_off_outlined),
                          ),
                          SeleccionableItem(
                            titulo: "Ocultar",
                            leading: Icon(Icons.visibility_off_outlined),
                          ),
                          if (comentario.respondidoPor.isNotEmpty)
                            SeleccionableItem(
                              titulo: "Ver historial de respuestas",
                              onTap:
                                  () => Get.bottomSheet(
                                    HistorialDeComentariosBottomSheet(
                                      comentarios:
                                          Get.find<HiloPageController>()
                                              .getPorTags(
                                                comentario.respondidoPor,
                                              ),
                                    ),
                                  ),
                            ),
                          SeleccionableItem(
                            titulo: "Copiar titulo",
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: comentario.texto),
                              );
                              Get.back();
                            },
                            leading: Icon(Icons.copy),
                          ),
                        ],
                      ),
                      if (Get.find<HiloPageController>().hilo.value!.esOp)
                        GrupoSeleccionableItem(
                          seleccionables: [
                            SeleccionableItem(
                              titulo:
                                  comentario.destacado
                                      ? "Dejar de destacar"
                                      : "Destacar",
                              onTap:
                                  () => GetIt.I
                                      .get<IComentariosRepository>()
                                      .destacar(
                                        comentario.id,
                                        Get.find<HiloPageController>()
                                            .hilo
                                            .value!
                                            .id,
                                      ),
                              leading:
                                  comentario.destacado
                                      ? Icon(Icons.star)
                                      : Icon(Icons.star_border),
                            ),
                          ],
                        ),
                      if (comentario.esAutor)
                        GrupoSeleccionableItem(
                          seleccionables: [
                            SeleccionableItem(
                              titulo:
                                  comentario.recibirNotificaciones!
                                      ? "Desactivar notificaciones"
                                      : "Activar notificaciones",

                              leading:
                                  comentario.recibirNotificaciones!
                                      ? Icon(Icons.notifications)
                                      : Icon(Icons.notifications_off),
                            ),
                          ],
                        ),
                      if (Get.find<AuthController>().esModerador)
                        GrupoSeleccionableItem(
                          seleccionables: [
                            SeleccionableItem(titulo: "Ver usuario"),
                            SeleccionableItem(
                              titulo: "Eliminar",
                              onTap:
                                  () => GetIt.I
                                      .get<IComentariosRepository>()
                                      .eliminar(
                                        comentario.id,
                                        Get.find<HiloPageController>()
                                            .hilo
                                            .value!
                                            .id,
                                      ),
                            ),
                          ],
                        ),
                    ],
                  ),
            ),
          ),
      child: ClipRRect(
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 4,
                      children: [
                        ColorComentario(comentario: comentario),
                        Flexible(
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            child: Wrap(
                              spacing: 2,
                              runSpacing: 2,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: tags,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      comentario.createdAt.tiempoTranscurrido,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
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
    );
  }

  void _onTagguear() {
    return Get.find<HiloPageController>().tagguear(comentario.tag);
  }

  List<Widget> get tags => [
    Text(
      comentario.autor,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
    ),
    if (comentario.esOp) Tag(label: Text("OP")),
    if (comentario.destacado)
      Tag(color: Colors.yellow.shade300, label: Text("Destacado")),
    GestureDetector(
      onTap: _onTagguear,
      child: Tag(label: Text(comentario.tag)),
    ),
    if (comentario.tagUnico != null)
      Tag(
        color: ColorPicker.generar(comentario.tagUnico!),
        label: Text(
          comentario.tagUnico!,
          style: TextStyle(color: Colors.white),
        ),
      ),
  ];

  List<Widget> get taggueadoPor =>
      comentario.respondidoPor
          .map<Widget>(
            (tag) => GestureDetector(
              onTap: () {
                HiloPageController c = Get.find<HiloPageController>();
                Get.bottomSheet(
                  HistorialDeComentariosBottomSheet(
                    comentarios: c.getPorTags([tag]),
                  ),
                  isScrollControlled: true,
                );
              },
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
              padding: EdgeInsets.all(7),
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

  String get label =>
      comentario.dados ?? (comentario.esOp ? "OP" : comentario.autorRole);
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

class HistorialDeComentariosBottomSheet extends StatelessWidget {
  final List<ComentarioModel> comentarios;
  const HistorialDeComentariosBottomSheet({
    super.key,
    required this.comentarios,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      onClosing: () {},
      builder:
          (context) => CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                sliver: SliverList.builder(
                  itemCount: comentarios.length,
                  itemBuilder:
                      (context, index) =>
                          ComentarioWidget(comentario: comentarios[index]),
                ),
              ),
            ],
          ),
    );
  }
}
