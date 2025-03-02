import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/core/presentation/widgets/dialog/dialog_responsive.dart';
import 'package:inkboard/features/moderacion/domain/ibaneos_repository.dart';
import 'package:inkboard/features/moderacion/domain/models/registro.dart';
import 'package:inkboard/features/moderacion/presentation/baneos/banear_usuario.dart';
import 'package:inkboard/features/moderacion/presentation/registros/logic/moderacion_usuario_registro_controller.dart';
import 'package:inkboard/features/moderacion/presentation/registros/registro_item.dart';
import 'package:inkboard/shared/presentation/util/extensions/scroll_controller_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RegistroDeUsuarioModeradorPanel extends StatefulWidget {
  final String usuario;

  const RegistroDeUsuarioModeradorPanel({super.key, required this.usuario});

  @override
  State<RegistroDeUsuarioModeradorPanel> createState() =>
      _RegistroDeUsuarioModeradorPanelState();
}

class _RegistroDeUsuarioModeradorPanelState
    extends State<RegistroDeUsuarioModeradorPanel> {
  late final controller = RegistroUsuarioModeracionController(
    id: widget.usuario,
  );

  RegistroUsuario get usuario => controller.usuario.value!;

  final ScrollController scroll = ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    controller.cargarUsuario();

    scroll.onBottom(() {
      if (controller.isHilosSeleccionado) {
        controller.cargarHilos();
      } else {
        controller.cargarComentarios();
      }
    });

    controller.seleccionado.listen((registro) {
      if (registro == RegistroSeleccionado.comentarios) {
        controller.cargarComentarios();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder:
          (controller) => ResponsiveLayoutDialog(
            child: Obx(
              () => CustomScrollView(
                controller: scroll,
                slivers: [
                  if (controller.isUsuarioCargando)
                    skeleton
                  else ...[
                    usuarioRegistro,

                    seleccionarRegistroButtons,

                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      sliver:
                          controller.isHilosSeleccionado
                              ? hilosHistorial
                              : comentariosHistorial,
                    ),
                  ],
                ],
              ),
            ),
          ),
    );
  }

  Widget get hilosHistorial => Obx(
    () => SliverList.builder(
      itemCount:
          controller.hilosHistorial.length +
          (controller.isHilosCargando ? 20 : 0),
      itemBuilder: (context, index) {
        if (index >= controller.hilosHistorial.length) {
          return const RegistroItemSkeleton();
        }

        return RegistroItem(registro: controller.hilosHistorial[index]);
      },
    ),
  );

  Widget get comentariosHistorial => Obx(
    () => SliverList.builder(
      itemCount:
          controller.comentariosHistorial.length +
          (controller.isComentariosCargando ? 20 : 0),
      itemBuilder: (context, index) {
        if (index >= controller.comentariosHistorial.length) {
          return const RegistroItemSkeleton();
        }

        return RegistroItem(registro: controller.comentariosHistorial[index]);
      },
    ),
  );

  Widget get usuarioRegistro =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ColoredBox(
              color: Colors.grey.shade200,
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipOval(
                            child: ColoredBox(
                              color: Colors.grey.shade300,
                              child: SizedBox.square(
                                dimension: 70,
                                child: Icon(Icons.person_outline),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                usuario.nombre ?? "Anonimo",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                "Unido desde ${usuario.registradoEn.day}/${usuario.registradoEn.month}/${usuario.registradoEn.year}",
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: context.destructibleButtonStyle,
                          onPressed:
                              () => showDialog(
                                context: context,
                                builder:
                                    (context) => BanearUsuarioDialog(
                                      usuario: widget.usuario,
                                    ),
                              ),
                          child: const Text("Banear usuario"),
                        ),
                      ).marginSymmetric(horizontal: 10),
                      SizedBox(height: 5),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            foregroundColor: WidgetStatePropertyAll(
                              Colors.black,
                            ),
                          ),

                          onPressed: () {
                            GetIt.I.get<IBaneosRepository>().desbanear(
                              id: widget.usuario,
                            );
                          },
                          child: const Text("Desbanear usuario"),
                        ),
                      ).marginSymmetric(horizontal: 10),
                    ],
                  ).paddingSymmetric(vertical: 10),
                ),
              ),
            ),
          ),
        ).marginOnly(bottom: 5),
      ).sliverBox;

  Widget get skeleton => Skeletonizer.sliver(
    child: SliverMainAxisGroup(
      slivers: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ColoredBox(
                color: Colors.white,
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Bone.circle(size: 70),
                      SizedBox(width: 10),
                      Flexible(
                        child: Bone.text(
                          words: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).paddingSymmetric(vertical: 20),
              ),
            ),
          ),
        ).sliverBox,
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          sliver: SliverList.builder(
            itemCount: 10,
            itemBuilder: (context, index) => const RegistroItemSkeleton(),
          ),
        ),
      ],
    ),
  );

  Widget get seleccionarRegistroButtons =>
      ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: ColoredBox(
          color: Colors.grey.shade200,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: SeleccionarRegistroButtonStyle().merge(
                    !controller.isHilosSeleccionado
                        ? ButtonStyle(
                          iconColor: WidgetStatePropertyAll(
                            Colors.grey.shade500,
                          ),
                          foregroundColor: WidgetStatePropertyAll(
                            Colors.grey.shade500,
                          ),
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.grey.shade300,
                          ),
                        )
                        : ButtonStyle(
                          iconColor: WidgetStatePropertyAll(Colors.black),
                          foregroundColor: WidgetStatePropertyAll(Colors.black),
                          backgroundColor: WidgetStatePropertyAll(Colors.white),
                        ),
                  ),
                  onPressed: () {
                    controller.seleccionado.value = RegistroSeleccionado.hilos;
                  },
                  icon: const FaIcon(FontAwesomeIcons.fileLines),
                  label: const Text("Hilos"),
                ),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  style: SeleccionarRegistroButtonStyle().merge(
                    !controller.isComentariosSeleccionado
                        ? ButtonStyle(
                          iconColor: WidgetStatePropertyAll(
                            Colors.grey.shade500,
                          ),
                          foregroundColor: WidgetStatePropertyAll(
                            Colors.grey.shade500,
                          ),
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.grey.shade300,
                          ),
                        )
                        : ButtonStyle(
                          iconColor: WidgetStatePropertyAll(Colors.black),
                          foregroundColor: WidgetStatePropertyAll(Colors.black),
                          backgroundColor: WidgetStatePropertyAll(Colors.white),
                        ),
                  ),
                  onPressed: () {
                    controller.seleccionado.value =
                        RegistroSeleccionado.comentarios;
                  },
                  icon: const FaIcon(FontAwesomeIcons.message),
                  label: const Text("Comentarios"),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 10, vertical: 5),
        ),
      ).marginOnly(bottom: 5).paddingSymmetric(horizontal: 15).sliverBox;
}

class SeleccionarRegistroButtonStyle extends ButtonStyle {
  SeleccionarRegistroButtonStyle()
    : super(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      );
}
