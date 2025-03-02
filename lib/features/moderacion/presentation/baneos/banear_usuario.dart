import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/core/presentation/utils/extensions/breakpoints_extensions.dart';
import 'package:inkboard/features/core/presentation/widgets/dialog/dialog_responsive.dart';
import 'package:inkboard/features/moderacion/domain/ibaneos_repository.dart';
import 'package:inkboard/features/moderacion/domain/models/baneos.dart';

class BanearUsuarioController extends GetxController {
  final razon = Rx<RazonBaneo?>(null);
  final duracion = Rx<DuracionBaneo?>(null);
  final TextEditingController controller = TextEditingController();

  final RxBool baneando = false.obs;

  final IBaneosRepository _repository = GetIt.I.get();

  final String id;

  BanearUsuarioController({required this.id});

  Future banear() async {
    if (baneando.value) return;

    baneando.value = true;

    var result = await _repository.banear(
      id: id,
      razon: razon.value!,
      duracion: duracion.value!,
    );

    result.fold((l) {}, (r) {});

    baneando.value = false;
  }
}

class BanearUsuarioDialog extends StatefulWidget {
  static final HashMap<DuracionBaneo, String> duraciones = HashMap.from({
    DuracionBaneo.unDia: "Un dia",
    DuracionBaneo.cincoMinutos: "Cinco minutos",
    DuracionBaneo.unaHora: "Una hora",
    DuracionBaneo.unaSemana: "Una semana",
    DuracionBaneo.unMes: "Un mes",
    DuracionBaneo.permanente: "Permanente",
  });

  static final HashMap<RazonBaneo, String> razones = HashMap.from({
    RazonBaneo.otro: "Otro",
    RazonBaneo.spam: "Spam",
    RazonBaneo.contenidoInapropiado: "Contenido inapropiado",
    RazonBaneo.categoriaIncorrecta: "Categoría incorrecta",
  });

  final String usuario;

  const BanearUsuarioDialog({super.key, required this.usuario});

  @override
  State<BanearUsuarioDialog> createState() => _BanearUsuarioDialogState();
}

class _BanearUsuarioDialogState extends State<BanearUsuarioDialog> {
  late final controller = Get.put(BanearUsuarioController(id: widget.usuario));

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutDialog(
      title: "Banear usuario",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Razon", style: Theme.of(context).textTheme.labelMedium),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: GestureDetector(
              onTap:
                  () => showDialog(
                    context: context,
                    builder: (context) => SeleccionarRazonDialog(),
                  ),
              child: ColoredBox(
                color: Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          BanearUsuarioDialog.razones[controller.razon.value] ??
                              "Seleccionar razón",
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ),
          ).marginOnly(bottom: 10),
          Text("Duración", style: Theme.of(context).textTheme.labelMedium),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: GestureDetector(
              onTap: () => showDialog(context: context, builder: (context) => SeleccionarDuracionDialog(),),
              child: ColoredBox(
                color: Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          BanearUsuarioDialog.duraciones[controller
                                  .duracion
                                  .value] ??
                              "Seleccionar duracción",
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ),
          ).marginOnly(bottom: 10),
          Text("Mensaje", style: Theme.of(context).textTheme.labelMedium),
          TextFormField(
            maxLines: 4,
            minLines: 4,
            decoration: InputDecoration(hintText: "Mensaje"),
          ).marginOnly(bottom: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: context.destructibleButtonStyle,
              onPressed: () {
                controller.banear();
              },
              child: Text("Banear"),
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 10),
    );
  }
}

extension ButtonStyles on BuildContext {
  ButtonStyle get destructibleButtonStyle => ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Theme.of(this).colorScheme.error),
    foregroundColor: WidgetStatePropertyAll(Theme.of(this).colorScheme.onError),
  );
}

class SeleccionarDuracionDialog extends StatelessWidget {
  const SeleccionarDuracionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Seleccionar duración",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        ...DuracionBaneo.values.map(
          (e) => ListTile(
            onTap: () {
              Get.find<BanearUsuarioController>().duracion.value = e;

              Get.back();
            },
            title: Text(BanearUsuarioDialog.duraciones[e]!),
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 10, vertical: 15);

    return ResponsiveLayoutDialog(
      smTarget: SmTarget.bottomsheet,
      style: DialogStyle(width: 400),
      showAppbar: false,
      child: child,
    );
  }
}



class SeleccionarRazonDialog extends StatelessWidget {
  const SeleccionarRazonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Seleccionar razón",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        ...RazonBaneo.values.map(
          (e) => ListTile(
            onTap: () {
              Get.find<BanearUsuarioController>().razon.value = e;

              Get.back();
            },
            title: Text(BanearUsuarioDialog.razones[e]!),
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 10, vertical: 15);

    return ResponsiveLayoutDialog(
      smTarget: SmTarget.bottomsheet,
      style: DialogStyle(width: 400),
      showAppbar: false,
      child: child,
    );
  }
}
