import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/app/presentation/widgets/snackbar.dart';
import 'package:inkboard/features/auth/presentation/logic/controllers/auth_controller.dart';
import 'package:inkboard/features/comentarios/domain/icomentarios_repository.dart';
import 'package:inkboard/features/core/presentation/widgets/revelador_de_contenido.dart';
import 'package:inkboard/features/hilos/domain/models/comentario_model.dart';
import 'package:inkboard/features/media/domain/models/media.dart';
import 'package:inkboard/features/media/presentation/widgets/media_box.dart';
import 'package:inkboard/shared/presentation/util/color_picker.dart';
import 'package:inkboard/shared/presentation/util/extensions/duration_extension.dart';
import 'package:inkboard/shared/presentation/widgets/effects/gradient/animated_gradient.dart';
import 'package:inkboard/shared/presentation/widgets/grupo_seleccionable/grupo_seleccionable.dart';
import 'package:inkboard/shared/presentation/widgets/tag.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

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
                              onTap: () {
                                Get.back();
                                HistorialDeComentariosBottomSheet.show(
                                  Get.find<HiloPageController>().getPorTags(
                                    comentario.respondidoPor,
                                  ),
                                );
                              },
                            ),
                          SeleccionableItem(
                            titulo: "Copiar comentario",
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
                                      )
                                      .then((value) {
                                        value.fold((l) {}, (r) {
                                          AppSnackbar.success(
                                            context,
                                            mensaje:
                                                comentario.destacado
                                                    ? "Comentario dejado de destacar"
                                                    : "Comentario destacado",
                                          );
                                        });
                                      }),
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
                                  () => {
                                    GetIt.I
                                        .get<IComentariosRepository>()
                                        .eliminar(
                                          comentario.id,
                                          Get.find<HiloPageController>()
                                              .hilo
                                              .value!
                                              .id,
                                        )
                                        .then((value) {
                                          value.fold((l) {}, (r) {
                                            Get.back();

                                            AppSnackbar.success(
                                              context,
                                              mensaje: "Comentario eliminado",
                                            );
                                          });
                                        }),
                                  },
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
                              spacing: 1.5,
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
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Gap(3),
                Wrap(spacing: 2, runSpacing: 4, children: taggueadoPor),
                Gap(2),
                if (comentario.media != null) media,
                TextoComentario(comentario.texto),
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
                HistorialDeComentariosBottomSheet.show(c.getPorTags([tag]));
              },
              child: Text(
                ">>$tag",
                style: TextStyle(color: CupertinoColors.link, fontSize: 12),
              ),
            ),
          )
          .toList();

  Widget get media => Center(
    child: MediaBox(
      style: DimensionableStyle(radius: BorderRadius.circular(10)),
      builder:
          (context, dimensionable) => ReveladorDeContenido(
            initialValue: comentario.media!.spoiler,
            child: dimensionable,
          ),
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
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
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

  static int showing = 0;

  static show(List<ComentarioModel> comentarios) async {
    var bottomsheet = Get.bottomSheet(
      HistorialDeComentariosBottomSheet(comentarios: comentarios),
      isScrollControlled: true,
      barrierColor: showing > 0 ? Colors.transparent : null,
    );
    showing++;
    await bottomsheet;
    showing--;
  }
}

class TextoComentario extends StatelessWidget {
  final String texto;
  const TextoComentario(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: parseText(texto),
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  List<TextSpan> parseText(String text) {
    final List<TextSpan> spans = [];
    int currentIndex = 0;

    // Regex ordenados por prioridad (de mayor a menor)
    final regexStyles = [
      {
        'regex': RegExp(r'>>[A-Z0-9]{8}'),
        'style': TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
        'onTap': (String match) {
          HistorialDeComentariosBottomSheet.show(
            Get.find<HiloPageController>().getPorTags([match.substring(2)]),
          );
        },
      },
      {
        'regex': RegExp(
          r'(https?://)(www\.)?([a-zA-Z0-9]([-.]?[a-zA-Z0-9])*\.[a-zA-Z]{2,})(\/[^ ]*)?(\?[^ ]*)?',
        ),
        'style': TextStyle(color: Colors.blue),
        'onTap': (String match) {
          Get.bottomSheet(AbrirEnlaceExternoBottomSheet(url: match));
        },
      },
      {
        'regex': RegExp(r'^>\w+', multiLine: true),
        'style': TextStyle(color: Colors.green),
      },
    ];

    // Procesar el texto en el orden de prioridad
    while (currentIndex < text.length) {
      bool matched = false;

      for (final entry in regexStyles) {
        final regex = entry['regex'] as RegExp;
        final onTap = entry['onTap'] as void Function(String)?;
        final match = regex.firstMatch(text.substring(currentIndex));

        if (match != null && match.start == 0) {
          // Añadir el texto previo sin formato (si existe)
          if (match.start > 0) {
            spans.add(
              TextSpan(
                text: text.substring(currentIndex, currentIndex + match.start),
                style: const TextStyle(color: Colors.black),
              ),
            );
          }

          // Añadir el texto coincidente con su estilo
          spans.add(
            TextSpan(
              text: match.group(0),
              recognizer:
                  TapGestureRecognizer()
                    ..onTap = () {
                      if (onTap != null) {
                        onTap(match.group(0)!);
                      }
                    },
              style: entry['style'] as TextStyle?,
            ),
          );

          currentIndex += match.end;
          matched = true;
          break; // Pasar al siguiente segmento del texto
        }
      }

      // Si no hubo coincidencia, añadir el carácter actual como texto normal
      if (!matched) {
        spans.add(
          TextSpan(
            text: text[currentIndex],
            style: const TextStyle(color: Colors.black),
          ),
        );
        currentIndex++;
      }
    }

    return spans;
  }
}

class AbrirEnlaceExternoBottomSheet extends StatelessWidget {
  final String url;
  const AbrirEnlaceExternoBottomSheet({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder:
          (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Ingresar a enlace",

                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "Estás a punto de salir de la aplicación para visitar un sitio externo.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.secondary,
                    // color: const Color(0xffE9ECEF),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          url,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(73, 80, 87, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "No podemos garantizar la seguridad o el contenido de sitios externos. ¿Deseas continuar?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      if (!await launchUrl(Uri.parse(url))) {
                        throw Exception('Could not launch $url');
                      }

                      if (context.mounted) Get.back();
                    },
                    child: const Text("Continuar"),
                  ),
                ),
              ],
            ).paddingOnly(bottom: 10),
          ),
    );
  }
}
