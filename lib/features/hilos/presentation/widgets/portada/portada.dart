import 'dart:math';

import 'package:flutter/material.dart';
import 'package:inkboard/features/hilos/domain/models/portada_model.dart';
import 'package:inkboard/shared/presentation/widgets/effects/blur/blur.dart';
import 'package:inkboard/shared/presentation/widgets/effects/gradient/gradient_effect.dart';
import 'package:inkboard/shared/presentation/widgets/image_overlapped.dart';
import 'package:inkboard/shared/presentation/widgets/tag.dart';
import 'package:skeletonizer/skeletonizer.dart';

const _radius = BorderRadius.all(Radius.circular(10));

class PortadaItem extends StatelessWidget {
  static const _gradient = [
    Colors.black45,
    Colors.transparent,
    Colors.transparent,
    Colors.black45,
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
                          Wrap(
                            spacing: 2,
                            runSpacing: 2,
                            children: [
                              Tag.text(
                                portada.subcategoria,
                                background: Colors.red,
                                padding: EdgeInsets.all(2),
                                style: TextStyle(color: Colors.white),
                              ),
                              if (portada.esNuevo)
                                Tag.text(
                                  "Nuevo",
                                  background: Colors.blue,
                                  padding: EdgeInsets.all(2),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ...[
                                if (portada.banderas.esSticky)
                                  TagPortadaIcon(
                                    icon: Icon(Icons.sticky_note_2),
                                    background: Colors.amber,
                                  ),
                                if (portada.banderas.dadosActivado)
                                  TagPortadaIcon(icon: Icon(Icons.casino)),
                                if (portada.banderas.idUnicoActivado)
                                  TagPortadaIcon(icon: Icon(Icons.person)),
                                if (portada.banderas.tieneEncuesta)
                                  TagPortadaIcon(icon: Icon(Icons.bar_chart))
                              ]
                            ],
                          ),
                          Text(
                            portada.titulo,
                            maxLines: 2,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ))),
        ));
  }
}

class PortadaItemSkeleton extends StatelessWidget {
  static final Random _random = Random();

  const PortadaItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _radius,
      child: ColoredBox(
          color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(
                    _random.nextInt(3) + 1,
                    (i) => Bone.square(
                          borderRadius: BorderRadius.circular(10),
                          size: 20,
                        )),
              ),
              Wrap(
                  spacing: 2,
                  runSpacing: 2,
                  children: List.generate(
                      4,
                      (i) => Bone(
                            borderRadius: BorderRadius.circular(10),
                            width: _random.nextInt(150) + 50,
                            height: 20,
                          ))),
            ],
          )),
    );
  }
}

class TagPortadaIcon extends StatelessWidget {
  final Widget icon;

  final Color? background;

  const TagPortadaIcon({super.key, required this.icon, this.background});

  @override
  Widget build(BuildContext context) {
    return Tag(
        padding: EdgeInsets.all(2),
        background: background ?? Colors.blue,
        child: icon);
  }
}
