import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/auth/presentation/widgets/autenticacion_requerida.dart';
import 'package:inkboard/features/core/presentation/utils/extensions/breakpoints_extensions.dart';
import 'package:inkboard/features/hilos/domain/ihilos_repository.dart';
import 'package:inkboard/features/hilos/domain/models/comentario_model.dart';
import 'package:inkboard/features/hilos/domain/models/hilo.dart';
import 'package:inkboard/features/hilos/presentation/logic/controllers/hilo_page_controller.dart';
import 'package:inkboard/features/hilos/presentation/widgets/comentario.dart';
import 'package:inkboard/features/media/domain/models/media.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';
import 'package:inkboard/features/media/presentation/widgets/media_box.dart';
import 'package:inkboard/shared/presentation/util/extensions/duration_extension.dart';
import 'package:inkboard/shared/presentation/util/extensions/scroll_controller_extension.dart';
import 'package:popover/popover.dart';

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

  late final ScrollController scroll = ScrollController();

  final HashMap<String, Key> destacadosKeys = HashMap();

  final HashMap<String, Key> comentariosKeys = HashMap();

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
                                    : HiloBody(hilo: controller.hilo.value!),
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
                          child: SafeArea(
                            child:
                                controller.hilo.value == null
                                    ? HiloBodySkeleton()
                                    : HiloBody(hilo: controller.hilo.value!),
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
    return Column(
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
                  Row(spacing: 4, children: acciones),
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
                      Chip(
                        labelPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 4,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 4,
                        ),
                        backgroundColor: Colors.grey.shade400,
                        label: Text(
                          hilo.autorRole,
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      Text(
                        hilo.createdAt.tiempoTranscurrido,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ).marginOnly(right: 5),
                ],
              ),
            ),
          ),
        ).marginOnly(bottom: 10),

        portada.marginOnly(bottom: 10),
        Text(
          hilo.titulo,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(hilo.descripcion),
      ],
    ).paddingSymmetric(horizontal: 8, vertical: 10);
  }

  Widget get portada => Center(
    child: MediaBox(
      style: DimensionableStyle(
        radius: BorderRadius.circular(10),
        constraints: BoxConstraints(maxHeight: 450),
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
          children: [
            if (controller.hayMediaSeleccionada) Row(children: medias),
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
                          showPopover(
                            context: context,
                            width: 250,
                            arrowWidth: 0,
                            arrowHeight: 0,
                            barrierColor: Colors.transparent,
                            bodyBuilder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: Text("Agregar archivo"),
                                    trailing: Icon(Icons.image),
                                    onTap: () => controller.pickGaleriaFile(),
                                  ),
                                  ListTile(
                                    title: Text("Agregar enlace"),
                                    trailing: Icon(Icons.link),
                                  ),
                                ],
                              );
                            },
                            radius: 15,
                            direction: PopoverDirection.top,
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

  List<Widget> get medias => [];
}

class HiloBodySkeleton extends StatelessWidget {
  static final Random random = Random();
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

abstract class IMiniaturaFactory {
  IMiniaturaService create(MediaProvider provider);
}

abstract class IMiniaturaService {
  Future<ImageProvider> generar(PickedFile media);
}

class PickedMediaMiniatura extends StatefulWidget {
  final PickedFile media;

  const PickedMediaMiniatura({super.key, required this.media});

  @override
  State<PickedMediaMiniatura> createState() => _PickedMediaMiniaturaState();
}

class _PickedMediaMiniaturaState extends State<PickedMediaMiniatura> {
  final Rx<ImageProvider?> miniatura = Rx(null);

  final IMiniaturaFactory _factory = GetIt.I.get();

  @override
  void initState() {
    _factory.create(widget.media.provider).generar(widget.media).then((value) {
      miniatura.value = value;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox.square(
        dimension: 80,
        child: Obx(() {
          if (miniaturaGenerada) {
            return Image(image: miniatura.value!, fit: BoxFit.cover);
          }

          return CircularProgressIndicator();
        }),
      ),
    );
  }

  bool get miniaturaGenerada => miniatura.value != null;
}
