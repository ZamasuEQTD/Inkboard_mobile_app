import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/auth/presentation/logic/controllers/auth_controller.dart';
import 'package:inkboard/features/hilos/domain/ihilos_repository.dart';
import 'package:inkboard/features/hilos/domain/models/portada_model.dart';
import 'package:inkboard/features/moderacion/presentation/registros/registro_de_usuario.dart';
import 'package:inkboard/shared/presentation/widgets/effects/blur/blur.dart';
import 'package:inkboard/shared/presentation/widgets/effects/gradient/gradient_effect.dart';
import 'package:inkboard/shared/presentation/widgets/grupo_seleccionable/grupo_seleccionable.dart';
import 'package:inkboard/shared/presentation/widgets/image_overlapped.dart';
import 'package:inkboard/shared/presentation/widgets/tag.dart';
import 'package:popover/popover.dart';
import 'package:skeletonizer/skeletonizer.dart';

const _radius = BorderRadius.all(Radius.circular(8));

class PortadaItem extends StatelessWidget {
  static const _gradient = [
    Colors.black87,
    Colors.transparent,
    Colors.transparent,
    Colors.black87,
  ];

  static const _stops = [0.0, 0.3, 0.6, 1.0];

  final PortadaModel portada;

  const PortadaItem({super.key, required this.portada});

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Colors.white),
      child: GestureDetector(
        onLongPress:
            () =>
                Get.bottomSheet(OpcionesDePortadaBottomSheet(portada: portada)),
        child: ClipRRect(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: _radius,
          child: ImageOverlapped.provider(
            provider: NetworkImage(portada.miniatura.url),
            boxFit: BoxFit.cover,
            child: Blur(
              blurear: portada.miniatura.spoiler,
              child: GradientEffectWidget(
                colors: _gradient,
                stops: _stops,
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            spacing: 2,
                            runSpacing: 2,
                            children: [
                              Tag.text(
                                portada.subcategoria,
                                color: Colors.green,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              if (portada.esNuevo)
                                Tag.text(
                                  "Nuevo",
                                  color: Colors.indigo.shade300,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 2,
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ...[
                                if (portada.banderas.esSticky)
                                  TagPortadaIcon(
                                    icon: Icon(Icons.sticky_note_2),
                                    background: Colors.amber.shade700,
                                  ),
                                if (portada.banderas.dadosActivado)
                                  TagPortadaIcon(icon: Icon(Icons.casino)),
                                if (portada.banderas.idUnicoActivado)
                                  TagPortadaIcon(icon: Icon(Icons.person)),
                                if (portada.banderas.tieneEncuesta)
                                  TagPortadaIcon(icon: Icon(Icons.bar_chart)),
                              ],
                            ],
                          ),
                        ],
                      ),
                      Text(
                        portada.titulo,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PortadaItemSkeleton extends StatelessWidget {
  static final Random _random = Random();

  const PortadaItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: ShimmerEffect(
        baseColor: Colors.white,
        highlightColor: Colors.grey.shade100,
      ),
      child: ClipRRect(
        borderRadius: _radius,
        child: ColoredBox(
          color: Colors.grey.shade200,
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  runSpacing: 4,
                  spacing: 4,
                  children: List.generate(
                    _random.nextInt(3) + 1,
                    (i) => Bone.square(
                      borderRadius: BorderRadius.circular(10),
                      size: 30,
                    ),
                  ),
                ),
                Wrap(
                  spacing: 2,
                  runSpacing: 2,
                  children: List.generate(
                    3,
                    (i) => Bone(
                      borderRadius: BorderRadius.circular(10),
                      width: _random.nextInt(70) + 50,
                      height: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TagPortadaIcon extends StatelessWidget {
  final Widget icon;

  final Color? background;

  const TagPortadaIcon({super.key, required this.icon, this.background});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 20,
      child: FittedBox(
        child: Tag(
          padding: EdgeInsets.all(2),
          color: background ?? Colors.blue,
          label: icon,
        ),
      ),
    );
  }
}

class OpcionesDePortadaBottomSheet extends StatelessWidget {
  final PortadaModel portada;
  const OpcionesDePortadaBottomSheet({super.key, required this.portada});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return BottomSheet(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      onClosing: () {},
      builder:
          (context) => GrupoSeleccionableSliverSheet(
            grupos: [
              GrupoSeleccionableItem(
                seleccionables: [
                  SeleccionableItem(titulo: "Reportar"),
                  SeleccionableItem(
                    titulo: "Ocultar",
                    onTap:
                        () =>
                            GetIt.I.get<IHilosRepository>().ocultar(portada.id),
                  ),
                  SeleccionableItem(titulo: "Seguir"),
                  SeleccionableItem(titulo: "Agregar a favoritos"),
                  SeleccionableItem(
                    titulo: "Copiar titulo",
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: portada.titulo));
                      Get.back();
                    },
                  ),
                ],
              ),
              if (auth.authenticado && auth.esModerador)
                GrupoSeleccionableItem(
                  seleccionables: [
                    SeleccionableItem(
                      titulo:
                          portada.banderas.esSticky
                              ? "Eliminar sticky"
                              : "Establecer sticky",
                      onTap: () {
                        var repo = GetIt.I.get<IHilosRepository>();

                        if (portada.banderas.esSticky) {
                          repo.eliminarSticky(portada.id);
                        } else {
                          repo.establecerSticky(portada.id);
                        }

                        Get.back();
                      },
                    ),
                    SeleccionableItem(
                      titulo: "Eliminar",
                      onTap: () {
                        var response = GetIt.I.get<IHilosRepository>().eliminar(
                          portada.id,
                        );
                      },
                    ),
                    SeleccionableItem(titulo: "Ver usuario", onTap: () => Get.bottomSheet(RegistroDeUsuarioModeradorPanel(usuario: this.portada.autorId!),),),
                  ],
                ),
            ],
          ),
    );
  }
}
