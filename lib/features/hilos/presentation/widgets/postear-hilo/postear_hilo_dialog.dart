import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/auth/presentation/widgets/login_dialog.dart';
import 'package:inkboard/features/categorias/domain/icategorias_repository.dart';
import 'package:inkboard/features/categorias/domain/models/categoria.dart';
import 'package:inkboard/features/categorias/domain/models/subcategoria.dart';
import 'package:inkboard/features/categorias/presentation/widgets/seleccionar_subcategoria.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/core/presentation/widgets/dialog/dialog_responsive.dart';
import 'package:inkboard/features/hilos/domain/models/comentario_model.dart';
import 'package:inkboard/features/hilos/domain/models/hilo.dart';
import 'package:inkboard/features/hilos/presentation/pages/hilo_page.dart';
import 'package:inkboard/features/media/domain/models/media.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';
import 'package:inkboard/features/media/presentation/logic/extensions/media_extensions.dart';
import 'package:inkboard/features/media/presentation/widgets/media_box.dart';
import 'package:inkboard/shared/presentation/widgets/effects/blur/blur.dart';

import '../../../../media/data/file_picker_service.dart';
import '../../logic/controllers/postear_hilo_controller.dart';

class EncuestaOpcionTextField extends StatelessWidget {
  final TextEditingController controller;

  final int index;

  final void Function(int index) onDelete;

  const EncuestaOpcionTextField({
    super.key,
    required this.controller,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Opcion ${index + 1}",
        suffixIcon: IconButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.transparent),
          ),
          onPressed: () => onDelete(index),
          icon: Icon(Icons.delete_outline, color: Colors.red),
        ).marginOnly(right: 5),
      ),
    );
  }
}

class PostearHiloDialog extends StatefulWidget {
  static final Widget marginSection = SizedBox(height: 10);
  const PostearHiloDialog({super.key});

  @override
  State<PostearHiloDialog> createState() => _PostearHiloDialogState();
}

class _PostearHiloDialogState extends State<PostearHiloDialog> {
  final postearHiloController = Get.put(PostearHiloController());

  @override
  Widget build(BuildContext context) {
    Widget child = Obx(() {
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Titulo", style: context.formSectionTitleTextStyle),
                TextFormField(
                  decoration: InputDecoration(hintText: "Titulo"),
                  controller: postearHiloController.titulo,
                ),
                PostearHiloDialog.marginSection,
                Text("Descripcion", style: context.formSectionTitleTextStyle),
                TextFormField(
                  minLines: 5,
                  maxLines: 5,
                  decoration: InputDecoration(hintText: "Descripción"),
                  controller: postearHiloController.descripcion,
                ),
                PostearHiloDialog.marginSection,
                Text("Subcategoria", style: context.formSectionTitleTextStyle),
                OutlinedButton(
                  onPressed: () {
                    Get.bottomSheet(
                      BottomSheet(
                        onClosing: () {},
                        builder:
                            (context) => SeleccionarSubcategoriasBottomSheet(
                              onSubcategoriaSeleccionada: (subcategoria) {
                                postearHiloController.subcategoria.value =
                                    subcategoria;
                                Get.back();
                              },
                            ).paddingSymmetric(vertical: 10),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (postearHiloController.haySubcategoriaSeleccionada)
                        Row(
                          spacing: 10,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: SizedBox.square(
                                dimension: 40,
                                child: Image.network(
                                  postearHiloController
                                      .subcategoria
                                      .value!
                                      .imagen,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              postearHiloController.subcategoria.value!.nombre,
                            ),
                          ],
                        )
                      else
                        Text("Seleccionar subcategoria"),

                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
                PostearHiloDialog.marginSection,
                Text("Portada", style: context.formSectionTitleTextStyle),
                //---portada---
                if (!postearHiloController.hayPortadaSeleccionada)
                  _sinPortadaSeleccionadaWidget()
                else
                  portadaSeleccionada().marginOnly(top: 10),
                PostearHiloDialog.marginSection,
                Text(
                  "Encuesta",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                if (!postearHiloController.hayEncuesta)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.poll_outlined),
                      onPressed: () => postearHiloController.addOpcion(),
                      label: Text("Agregar encuesta"),
                    ),
                  )
                else
                  ..._encuestaWidget,
                PostearHiloDialog.marginSection,
                Text("Banderas", style: context.formSectionTitleTextStyle),
                _banderasWidget(),
                PostearHiloDialog.marginSection,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      postearHiloController.postear();
                    },
                    child: Text("Postear"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    return ResponsiveLayoutDialog(title: "Postear hilo", child: child);
  }

  Center portadaSeleccionada() {
    return Center(
      child: MediaBox(
        style: DimensionableStyle(constraints: BoxConstraints(maxHeight: 450)),
        builder: (context, dimensionable) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    dimensionable,
                    Positioned.fill(
                      child: Blur(
                        blurear:
                            postearHiloController.pickedFile.value!.spoiler,
                      ),
                    ),
                  ],
                ),
              ),
              opcionesDePortada(),
            ],
          );
        },
        media: MediaSource(
          source: MediaSourceType.file,
          model: postearHiloController.pickedFile.value!.value.toMediaModel(),
        ),
      ),
    );
  }

  Positioned opcionesDePortada() {
    return Positioned(
      right: -20,
      top: -20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          elevation: 120,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.shade300, width: 0.5),
          ),
          child: ColoredBox(
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  onPressed: postearHiloController.switchSpoiler,
                  icon: Obx(
                    () =>
                        !postearHiloController.isSpoiler
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    postearHiloController.pickedFile.value = null;
                  },
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ClipRRect _banderasWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ColoredBox(
        color: Colors.grey.shade200,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dados activados",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Checkbox(
                      value: postearHiloController.dados.value,
                      onChanged:
                          (value) => postearHiloController.dados.value = value!,
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Id unico",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Checkbox(
                      value: postearHiloController.idUnico.value,
                      onChanged:
                          (value) =>
                              postearHiloController.idUnico.value = value!,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> get _encuestaWidget {
    return [
      ...postearHiloController.encuesta.value.asMap().entries.map((entry) {
        return EncuestaOpcionTextField(
          controller: entry.value,
          index: entry.key,
          onDelete: (index) {
            postearHiloController.eliminarOpcion(index);
          },
        ).marginOnly(bottom: 10);
      }),
      if (postearHiloController.puedeAgregarOpcionDeEncuesta)
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => postearHiloController.addOpcion(),
            child: Text("Agregar opción"),
          ),
        ),
    ];
  }

  Column _sinPortadaSeleccionadaWidget() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  PickedFile? file = await FilePickerService().pickOne();
                  if (file != null) {
                    postearHiloController.agregarPortada(file);
                  }
                },
                icon: Icon(Icons.image),
                label: Text("Agregar Archivo"),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.link),
                label: Text(
                  "Agregar enlace",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        TextFormField(
          minLines: 2,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: "Enlace",
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(Icons.link),
            ).paddingAll(2),
          ),
        ).marginOnly(top: 10),
      ],
    );
  }
}

extension TextStylesFromContext on BuildContext {
  TextStyle get formSectionTitleTextStyle =>
      Theme.of(this).textTheme.labelMedium!;
}
