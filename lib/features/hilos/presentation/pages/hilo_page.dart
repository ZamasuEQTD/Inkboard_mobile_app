import 'dart:collection';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/auth/presentation/logic/controllers/auth_controller.dart';
import 'package:inkboard/features/auth/presentation/widgets/autenticacion_requerida.dart';
import 'package:inkboard/features/core/presentation/utils/extensions/breakpoints_extensions.dart';
import 'package:inkboard/features/core/presentation/widgets/revelador_de_contenido.dart';
import 'package:inkboard/features/encuestas/domain/iencuesta_repository.dart';
import 'package:inkboard/features/encuestas/domain/models/encuesta.dart';
import 'package:inkboard/features/encuestas/presentation/widgets/encuesta.dart';
import 'package:inkboard/features/hilos/domain/ihilos_repository.dart';
import 'package:inkboard/features/hilos/domain/models/comentario_model.dart';
import 'package:inkboard/features/hilos/domain/models/hilo.dart';
import 'package:inkboard/features/hilos/presentation/logic/controllers/hilo_page_controller.dart';
import 'package:inkboard/features/hilos/presentation/widgets/comentario.dart';
import 'package:inkboard/features/media/domain/models/media.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';
import 'package:inkboard/features/media/presentation/logic/extensions/media_extensions.dart';
import 'package:inkboard/features/media/presentation/widgets/media_box.dart';
import 'package:inkboard/features/media/presentation/widgets/miniatura/picked_media_miniatura.dart';
import 'package:inkboard/shared/presentation/util/extensions/duration_extension.dart';
import 'package:inkboard/shared/presentation/util/extensions/scroll_controller_extension.dart';
import 'package:inkboard/shared/presentation/widgets/grupo_seleccionable/grupo_seleccionable.dart';
import 'package:inkboard/shared/presentation/widgets/tag.dart';

import 'package:skeletonizer/skeletonizer.dart';

class HiloPage extends StatefulWidget {
  const HiloPage({super.key});

  @override
  State<HiloPage> createState() => _HiloPageState();
}

class _HiloPageState extends State<HiloPage> {
  final HiloPageController controller = Get.put(
    HiloPageController(id: Get.parameters["id"]!),
  );

  final GlobalKey key = GlobalKey();

  final ScrollController scroll = ScrollController();

  final HashMap<String, GlobalKey> destacadosKeys = HashMap();

  final HashMap<String, GlobalKey> comentariosKeys = HashMap();

  @override
  void initState() {
    controller.cargarHilo();

    scroll.onBottom(() {});

    controller.destacados.listen((destacados) {
      for (var destacado in destacados) {
        destacadosKeys.putIfAbsent(destacado.id, () => GlobalKey());
      }
    });

    controller.comentarios.listen((comentarios) {
      for (var comentario in comentarios) {
        comentariosKeys.putIfAbsent(comentario.id, () => GlobalKey());
      }
    });

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Future.delayed(Duration(milliseconds: 1000), () {
          String? tag = Get.parameters["tag"];

          if (tag != null) {
            HistorialDeComentariosBottomSheet.show([
              controller.comentariosMap[tag]!,
            ]);
          }
        });
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (context.isLargerThanMd) {
            //no celular
            return LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    SizedBox(
                      width: 0.45 * constraints.maxWidth,
                      height: double.infinity,
                      child: ColoredBox(
                        color: Colors.grey.shade200,
                        child: Obx(
                          () => SingleChildScrollView(
                            child:
                                controller.hilo.value == null
                                    ? HiloBodySkeleton()
                                    : Obx(
                                      () => HiloBody(
                                        hilo: controller.hilo.value!,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 0.55 * constraints.maxWidth,
                      child: Column(
                        children: [
                          Flexible(
                            child: CustomScrollView(
                              clipBehavior: Clip.none,
                              controller: scroll,
                              slivers: [_comentarios],
                            ),
                          ),
                          ComentarHilo(key: key),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }

          //celular
          return Column(
            children: [
              Flexible(
                child: CustomScrollView(
                  controller: scroll,
                  slivers: [
                    SliverToBoxAdapter(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        child: ColoredBox(
                          color: Colors.grey.shade200,
                          child: Obx(
                            () => SafeArea(
                              child:
                                  controller.hilo.value == null
                                      ? HiloBodySkeleton()
                                      : Obx(
                                        () => HiloBody(
                                          hilo: controller.hilo.value!,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _comentarios,
                  ],
                ),
              ),
              ComentarHilo(key: key),
            ],
          );
        },
      ),
    );
  }

  Widget get _comentarios => SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    sliver: SliverMainAxisGroup(
      slivers: [
        Obx(
          () => SliverToBoxAdapter(
            child:
                controller.cargandoHilo.value
                    ? Row(
                      spacing: 4,
                      children: [
                        Bone(
                          height: 24,
                          width: 200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        Bone(
                          height: 24,
                          width: 50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ],
                    )
                    : Text(
                      "Comentarios (${controller.hilo.value!.cantidadComentarios})",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
          ),
        ),
        Obx(() {
          var comentarios = [
            ...controller.destacados,
            ...controller.comentarios,
          ];

          int items =
              comentarios.length +
              (controller.cargandoComentarios.value ? 5 : 0);

          return SliverList.builder(
            itemCount: items,
            itemBuilder: (context, index) {
              if (index >= comentarios.length) return ComentarioSkeleton();

              ComentarioModel c = comentarios[index];

              return ComentarioWidget(
                key: c.destacado ? destacadosKeys[c.id] : comentariosKeys[c.id],
                comentario: comentarios[index],
              );
            },
          );
        }),
      ],
    ),
  );
}

final BorderRadius hiloSectionRadius = BorderRadius.circular(6);

class HiloBody extends StatelessWidget {
  final HiloModel hilo;

  const HiloBody({super.key, required this.hilo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () => Get.bottomSheet(HiloOpcionesBottomSheet(hilo: hilo)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: hiloSectionRadius,
            child: ColoredBox(
              color: Theme.of(context).colorScheme.surface,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  spacing: 4,
                  children: [
                    IconButton(
                      onPressed: Get.back,
                      icon: Icon(Icons.chevron_left),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox.square(
                        dimension: 30,
                        child: Image(
                          image: NetworkImage(hilo.subcategoria.imagen),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        hilo.subcategoria.nombre,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.link,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).marginOnly(bottom: 10),
          ClipRRect(
            borderRadius: hiloSectionRadius,
            child: ColoredBox(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(spacing: 1, children: acciones),
                    Row(
                      spacing: 3.5,
                      children: [
                        Text(
                          hilo.autor,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Tag(
                          color: Colors.grey.shade500,
                          label: Text(
                            hilo.autorRole,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          hilo.createdAt.tiempoTranscurrido,
                          style: TextStyle(
                            fontSize: 8,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ],
                    ).marginOnly(right: 5),
                  ],
                ),
              ),
            ),
          ).marginOnly(bottom: 10),
          portada.marginOnly(bottom: 10),
          if (hilo.encuesta != null) EncuestaHilo(encuesta: hilo.encuesta!),
          SelectableText(
            hilo.titulo,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SelectableText(hilo.descripcion),
        ],
      ).paddingSymmetric(horizontal: 8, vertical: 10),
    );
  }

  Widget get portada => Center(
    child: MediaBox(
      style: DimensionableStyle(
        radius: BorderRadius.circular(10),
        constraints: BoxConstraints(maxHeight: 450),
      ),
      builder:
          (context, dimensionable) => ReveladorDeContenido(
            initialValue: hilo.media.spoiler,
            child: dimensionable,
          ),

      media: MediaSource(source: MediaSourceType.network, model: hilo.media),
    ),
  );

  List<Widget> get acciones => [
    IconButton(
      onPressed: () {
        GetIt.I.get<IHilosRepository>().seguir(hilo.id);
      },
      icon: Icon(Icons.person_2_outlined),
    ),
    IconButton(
      onPressed: () {
        GetIt.I.get<IHilosRepository>().ocultar(hilo.id);
      },
      icon: Icon(Icons.visibility_off_outlined),
    ),
    IconButton(onPressed: () {}, icon: Icon(Icons.flag_outlined)),
    IconButton(
      onPressed: () {
        GetIt.I.get<IHilosRepository>().establecerFavorito(hilo.id);
      },
      icon: Icon(Icons.star_outline),
    ),
  ];
}

class ComentarHilo extends StatefulWidget {
  const ComentarHilo({super.key});

  @override
  State<ComentarHilo> createState() => _ComentarHiloState();
}

class _ComentarHiloState extends State<ComentarHilo> {
  final HiloPageController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: AutenticacionRequeridaButton(
        child: Column(
          spacing: 5,
          children: [
            Obx(() {
              if (controller.hayMediaSeleccionada) {
                return Row(
                  spacing: 3,
                  children: [...medias],
                ).paddingSymmetric(horizontal: 10).paddingOnly(top: 10);
              }

              return SizedBox();
            }),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: [
                Builder(
                  builder:
                      (context) => IconButton(
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(CircleBorder()),
                        ),
                        onPressed: () {
                          Get.bottomSheet(
                            BottomSheet(
                              onClosing: () {},
                              builder:
                                  (context) => GrupoSeleccionableSliverSheet(
                                    grupos: [
                                      GrupoSeleccionableItem(
                                        seleccionables: [
                                          SeleccionableItem(
                                            titulo: "Agregar archivo",
                                            onTap:
                                                () =>
                                                    Get.find<
                                                          HiloPageController
                                                        >()
                                                        .pickGaleriaFile(),
                                          ),
                                          SeleccionableItem(
                                            titulo: "Agregar enlace",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                            ),
                          );
                        },
                        icon: Icon(Icons.more_vert),
                      ),
                ),
                Flexible(
                  child: TextFormField(
                    controller: controller.comentario,
                    maxLines: 5,
                    minLines: 2,
                    decoration: InputDecoration(
                      hintText: "Escribe tu comentario...",
                    ),
                  ),
                ),
                Obx(
                  () => IconButton(
                    style: ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(Size.square(45)),
                      iconColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: controller.comentar,
                    icon: FittedBox(
                      child:
                          controller.comentandoHilo.value
                              ? CircularProgressIndicator(color: Colors.white)
                              : Icon(CupertinoIcons.paperplane_fill, size: 18),
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 10, vertical: 10),
          ],
        ),
      ),
    );
  }

  List<Widget> get medias {
    List<Widget> medias = [];
    for (var i = 0; i < controller.files.length; i++) {
      medias.add(
        Obx(
          () => GestureDetector(
            onTap: () {
              Get.bottomSheet(
                Obx(
                  () =>
                      i < controller.files.length
                          ? VerPickedMediaBottomSheet(
                            file: controller.files[i],
                            onEliminar: () {
                              Get.back();

                              controller.removeFileAt(i);
                            },
                            onBlurear: (value) => controller.blurearFile(i),
                          )
                          : SizedBox(),
                ),
                isScrollControlled: true,
              );
            },
            child: PickedMediaMiniatura(
              key: UniqueKey(),
              media: controller.files[i],
              blurear: controller.files[i].spoiler,
            ),
          ),
        ),
      );
    }

    return medias;
  }
}

class HiloBodySkeleton extends StatelessWidget {
  static final math.Random random = math.Random();
  const HiloBodySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: hiloSectionRadius,
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BackButton(),
                Gap(5),
                Bone.square(size: 35, borderRadius: BorderRadius.circular(10)),
                Gap(5),
                Bone(
                  width: 200,
                  height: 20,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),
        ),
        Gap(10),
        ClipRRect(
          borderRadius: hiloSectionRadius,
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Bone.square(size: 30, borderRadius: BorderRadius.circular(5)),
                Bone.square(size: 30, borderRadius: BorderRadius.circular(5)),
                Bone.square(size: 30, borderRadius: BorderRadius.circular(5)),
              ],
            ).paddingSymmetric(horizontal: 4, vertical: 5),
          ),
        ).marginOnly(bottom: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Bone(
            width: double.infinity,
            height: 240,
            borderRadius: BorderRadius.circular(15),
          ),
        ).marginOnly(bottom: 10),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: List.generate(
            random.nextInt(4) + 1,
            (index) => Bone(
              height: 24,
              width: random.nextInt(280) + 70,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Gap(4),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: List.generate(
            random.nextInt(8) + 1,
            (index) => Bone(
              height: 16,
              width: random.nextInt(280) + 70,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 10);
  }
}

class HiloOpcionesBottomSheet extends StatelessWidget {
  final HiloModel hilo;
  const HiloOpcionesBottomSheet({super.key, required this.hilo});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return BottomSheet(
      onClosing: () {},
      builder:
          (context) => GrupoSeleccionableSliverSheet(
            grupos: [
              if (auth.authenticado && auth.esModerador)
                GrupoSeleccionableItem(
                  seleccionables: [
                    SeleccionableItem(titulo: "Eliminar"),
                    SeleccionableItem(titulo: "Ver usuario"),
                  ],
                ),

              if (hilo.esOp)
                GrupoSeleccionableItem(
                  seleccionables: [
                    SeleccionableItem(titulo: "Desactivar notificaciones"),
                  ],
                ),
            ],
          ),
    );
  }
}

class VerPickedMediaBottomSheet extends StatelessWidget {
  final PickedFile file;

  final void Function() onEliminar;
  final void Function(bool value) onBlurear;

  const VerPickedMediaBottomSheet({
    super.key,
    required this.file,
    required this.onEliminar,
    required this.onBlurear,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      enableDrag: false,
      onClosing: () {},
      builder:
          (context) => SingleChildScrollView(
            child: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: MediaBox(
                    style: DimensionableStyle(
                      constraints: BoxConstraints(maxHeight: 400),
                    ),
                    builder:
                        (context, dimensionable) => ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: dimensionable,
                        ),
                    media: MediaSource(
                      source: MediaSourceType.file,
                      model: file.toMediaModel(),
                    ),
                  ),
                ),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ColoredBox(
                    color: Colors.grey.shade200,
                    child: Column(
                      children: [
                        ListTile(title: Text("Eliminar"), onTap: onEliminar),
                        ListTile(
                          title: Text("Marcar spoiler"),
                          trailing: Checkbox(
                            value: file.spoiler,
                            onChanged: (value) => onBlurear(value!),
                          ),
                        ),
                      ],
                    ).paddingSymmetric(vertical: 5),
                  ),
                ),
              ],
            ).paddingSymmetric(vertical: 10, horizontal: 10),
          ),
    );
  }
}

class EncuestaHilo extends StatefulWidget {
  final EncuestaModel encuesta;

  const EncuestaHilo({super.key, required this.encuesta});

  @override
  State<EncuestaHilo> createState() => _EncuestaHiloState();
}

class _EncuestaHiloState extends State<EncuestaHilo> {
  late final Rx<EncuestaModel> encuesta = Rx(widget.encuesta);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Encuesta(
        encuesta: encuesta.value,
        onVotado: (respuesta) {
          encuesta.value = encuesta.value.copyWith(
            respuestas:
                encuesta.value.respuestas
                    .map(
                      (e) => e.copyWith(
                        votos: e.id == respuesta ? e.votos + 1 : e.votos,
                      ),
                    )
                    .toList(),
          );
        },
        onVotar: (respuesta) {
          var response = GetIt.I.get<IEncuestaRepository>().votar(
            encuesta.value.id,
            respuesta,
          );

          response.then(
            (value) => value.fold(
              (l) {
                log(l.toString());
              },
              (r) {
                encuesta.value = encuesta.value.copyWith(
                  respuestaVotada: respuesta,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
