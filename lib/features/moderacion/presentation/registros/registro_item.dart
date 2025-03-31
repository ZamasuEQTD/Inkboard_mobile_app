import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkboard/features/moderacion/domain/models/registro.dart';
import 'package:inkboard/shared/presentation/util/extensions/duration_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RegistroItem extends StatelessWidget {
  final Registro registro;
  const RegistroItem({super.key, required this.registro});

  String get titulo =>
      (registro is HiloPosteadoRegistro
          ? "Ha Posteado : "
          : "Ha comentado en : ") +
      registro.hilo.titulo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed("/hilo/${registro.hilo.id}"),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ColoredBox(
          color: Colors.grey.shade200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox.square(
                      dimension: 70,
                      child: Image(
                        image: NetworkImage(registro.hilo.portada),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ).marginOnly(left: 10),
                  ),
                ],
              ),
              Text(
                "Hace ${registro.fecha.tiempoTranscurrido}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              Text(
                registro.contenido,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ).paddingAll(16),
        ),
      ).marginOnly(bottom: 10),
    );
  }
}

class RegistroItemSkeleton extends StatelessWidget {
  const RegistroItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ColoredBox(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const Bone.square(size: 70),
                  ),
                  Flexible(
                    child: const Bone.multiText(
                      lines: 2,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ).marginOnly(left: 10),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Bone.text(
                words: 1,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Bone.multiText(
                lines: 2,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ).paddingAll(16),
        ),
      ).marginOnly(bottom: 10),
    );
  }
}
