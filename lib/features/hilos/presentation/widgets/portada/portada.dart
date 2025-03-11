import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/auth/presentation/logic/controllers/auth_controller.dart';
import 'package:inkboard/features/hilos/domain/ihilos_repository.dart';
import 'package:inkboard/features/hilos/domain/models/portada_model.dart';
import 'package:inkboard/features/moderacion/presentation/registros/registro_de_usuario.dart';
import 'package:inkboard/shared/presentation/widgets/effects/blur/blur.dart';
import 'package:inkboard/shared/presentation/widgets/effects/gradient/gradient_effect.dart';
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
      child: ClipRRect(
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
                                vertical: 2,
                                horizontal: 4,
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                            if (portada.esNuevo)
                              Tag.text(
                                "Nuevo",
                                color: Colors.purple.shade300,
                                padding: EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 4,
                                ),
                                style: TextStyle(color: Colors.white),
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
                        Builder(
                          builder: (context) {
                            final AuthController auth = Get.find();

                            return IconButton(
                              onPressed: () {
                                showPopover(
                                  context: context,
                                  width: 250,
                                  bodyBuilder: (context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text("Reportar"),
                                          trailing: Icon(Icons.flag),
                                        ),
                                        ListTile(
                                          title: Text("Ocultar"),
                                          trailing: Icon(Icons.visibility_off),
                                        ),
                                        ListTile(
                                          title: Text("Seguir"),
                                          trailing: Icon(
                                            Icons.person_3_outlined,
                                          ),
                                        ),

                                        if (auth.authenticado &&
                                            auth.esModerador) ...[
                                          ListTile(
                                            title: Text("Ver usuario"),
                                            trailing: Icon(
                                              Icons.person_2_outlined,
                                            ),
                                            onTap:
                                                () => showDialog(
                                                  context: context,
                                                  builder:
                                                      (context) =>
                                                          RegistroDeUsuarioModeradorPanel(
                                                            usuario:
                                                                portada
                                                                    .autorId!,
                                                          ),
                                                ),
                                          ),
                                          ListTile(
                                            onTap:
                                                () => GetIt.I
                                                    .get<IHilosRepository>()
                                                    .eliminar(portada.id),
                                            title: Text("Eliminar"),
                                            trailing: Icon(
                                              Icons.delete_outline_outlined,
                                            ),
                                          ),
                                          if (!portada.banderas.esSticky)
                                            ListTile(
                                              title: Text("Esteblecer sticky"),
                                              trailing: Icon(Icons.push_pin),
                                              onTap: () {
                                                GetIt.I
                                                    .get<IHilosRepository>()
                                                    .establecerSticky(
                                                      portada.id,
                                                    );
                                              },
                                            )
                                          else
                                            ListTile(
                                              title: Text("Eliminar sticky"),
                                              trailing: Icon(Icons.push_pin),
                                              onTap: () {
                                                GetIt.I
                                                    .get<IHilosRepository>()
                                                    .eliminarSticky(portada.id);
                                              },
                                            ),
                                        ],
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.more_vert),
                            );
                          },
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
      dimension: 24,
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
