import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkboard/shared/presentation/util/extensions/duration_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../domain/models/notificacion.dart';

const BorderRadiusGeometry radius = BorderRadius.all(Radius.circular(10));

class NotificacionItem extends StatelessWidget {
  final Notificacion notificacion;

  const NotificacionItem({super.key, required this.notificacion});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: ColoredBox(
        color: Colors.white,
        child: GestureDetector(
          onTap: () => Get.toNamed("/hilo/${notificacion.hilo.id}"),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: SizedBox.square(
                      dimension: 45,
                      child: Image(
                        image: NetworkImage(notificacion.hilo.portada),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        notificacion.hilo.titulo,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (notificacion is ComentarioRespondido)
                        Text((notificacion as ComentarioRespondido).respondido),
                      Text(notificacion.content, maxLines: 4),
                    ],
                  ).marginOnly(left: 10),
                ],
              ),
              Text(
                "hace ${notificacion.fecha.tiempoTranscurrido}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ],
          ).paddingAll(10),
        ),
      ),
    ).marginOnly(bottom: 10).marginSymmetric(horizontal: 5);
  }

  String get titulo {
    switch (notificacion) {
      case HiloSeguidoComentado():
        return "Hilo seguido comentado";
      case HiloComentado():
        return "Han comentado tu hilo";
      case ComentarioRespondido notificacion:
        return "Han respondido a tu comentario: ${notificacion.respondidoTag}";
      default:
        throw UnimplementedError(
          "No se ha implementado el titulo para $notificacion",
        );
    }
  }
}

class NotificacionSkeletonItem extends StatelessWidget {
  const NotificacionSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Skeletonizer(
      child: ClipRRect(
        borderRadius: radius,
        child: Column(
          children: [
            Bone.text(words: 2),
            Row(children: [Bone.square(size: 50), Bone.text(words: 2)]),
            Bone.text(words: 4),
            Bone.text(words: 1),
          ],
        ),
      ),
    );
  }
}
