import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/notificaciones/domain/inotificaciones_repository.dart';
import 'package:inkboard/features/notificaciones/presentation/logic/mis_notificaciones_controller.dart';
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
        color: Theme.of(context).colorScheme.secondary,
        child: GestureDetector(
          onTap: () {
            Get.find<MisNotificacionesController>().leer(notificacion.id);
            Get.toNamed(
              "/hilo/${notificacion.hilo.id}",
              parameters: {"tag": notificacion.comentario},
            );
          },
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notificacion.hilo.titulo,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          notificacion.content,
                          maxLines: 4,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(115, 115, 115, 0.8),
                          ),
                        ),
                      ],
                    ).marginOnly(left: 10),
                  ),
                ],
              ),
              Text(
                "Hace ${notificacion.fecha.tiempoTranscurrido}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ).paddingAll(8),
        ),
      ),
    ).marginSymmetric(horizontal: 5);
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
