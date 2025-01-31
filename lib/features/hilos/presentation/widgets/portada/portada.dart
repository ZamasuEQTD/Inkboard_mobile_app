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
    return ClipRRect(
      borderRadius: _radius,
    child: ImageOverlapped.provider(provider: NetworkImage(portada.miniatura.url), 
        boxFit: BoxFit.cover,
        child: Blur(
          blurear: portada.miniatura.spoiler,
          child: GradientEffectWidget(
            colors: _gradient ,
            stops: _stops,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [  
                  Wrap(
                    spacing: 2,
                    runSpacing: 2,
                    children: [
                      Tag.text(portada.subcategoria),
                      if(portada.esNuevo) Tag.text("Nuevo"),
                      ...[
                          if(portada.banderas.esSticky) Tag(child: Icon(Icons.sticky_note_2)),
                          if(portada.banderas.dadosActivado) Tag(child: Icon(Icons.casino)),
                          if(portada.banderas.idUnicoActivado) Tag(child: Icon(Icons.person)),
                          if(portada.banderas.tieneEncuesta) Tag(child: Icon(Icons.bar_chart))
                      ].map((w) => SizedBox.square(dimension: 20,child: FittedBox(child: w)))
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
          )
        )
      ),
    );
  }
}


class PortadaItemSkeleton extends StatelessWidget {
  static final Random _random = Random();

  const PortadaItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _radius,
      child: ColoredBox(color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: List.generate(_random.nextInt(3) + 1, (i)=> Bone.square(
                borderRadius: BorderRadius.circular(10),size: 20,
              )),
            ),
            Wrap(
              spacing: 2,
              runSpacing: 2,
              children: List.generate(4, (i)=> Bone(
                  borderRadius: BorderRadius.circular(10),
                  width: _random.nextInt(150) + 50,
                  height: 20,
                )
              )
            ),
          ],
        )
      ),
    );
  }
}