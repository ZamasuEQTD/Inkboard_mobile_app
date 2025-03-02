
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/media/domain/iminiatura_service.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';

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
