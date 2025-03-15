import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/media/domain/iminiatura_service.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';
import 'package:inkboard/shared/presentation/widgets/effects/blur/blur.dart';
import 'package:inkboard/shared/presentation/widgets/effects/gradient/gradient_effect.dart';

class PickedMediaMiniatura extends StatefulWidget {
  final PickedFile media;

  final bool blurear;

  const PickedMediaMiniatura({
    super.key,
    required this.media,
    this.blurear = false,
  });

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
      child: Obx(() {
        if (miniaturaGenerada) {
          return ClipRRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Stack(
              children: [
                SizedBox.square(
                  dimension: 80,
                  child: Image(image: miniatura.value!, fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: ClipRect(
                    child: Blur(
                      blurear: widget.blurear,
                      child: GradientEffectWidget(
                        colors: [
                          Colors.black12,
                          Colors.transparent,
                          Colors.black12,
                        ],
                        stops: [0.1, 0.5, 1],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return CircularProgressIndicator();
      }),
    );
  }

  bool get miniaturaGenerada => miniatura.value != null;
}
