import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkboard/features/core/presentation/widgets/dialog/dialog_responsive.dart';
import 'package:inkboard/features/notificaciones/presentation/logic/mis_notificaciones_controller.dart';
import 'package:inkboard/features/notificaciones/presentation/widgets/notificacion.dart';
import 'package:inkboard/shared/presentation/util/extensions/scroll_controller_extension.dart';

class MisNotificacionesLayout extends StatefulWidget {
  const MisNotificacionesLayout({super.key});

  @override
  State<MisNotificacionesLayout> createState() => _MisNotificacionesLayoutState();
}

class _MisNotificacionesLayoutState extends State<MisNotificacionesLayout> {
  final ScrollController scroll = ScrollController();

  final MisNotificacionesController controller = Get.put(
    MisNotificacionesController(),
  );

  @override
  void initState() {
    scroll.onBottom(() {
      controller.cargar();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutDialog(
      child: CustomScrollView(
        controller: scroll,
        slivers: [
          SliverList.builder(
            itemCount: controller.notificaciones.length,
            itemBuilder: (context, index) {
              if (index >= controller.notificaciones.length) {
                return const NotificacionSkeletonItem();
              }

              final notificacion = controller.notificaciones[index];

              return NotificacionItem(notificacion: notificacion);
            },
          ),
        ],
      ),
    );
  }
}
