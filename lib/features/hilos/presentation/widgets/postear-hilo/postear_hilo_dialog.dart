import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          color: Colors.red.shade500,
          onPressed: () => onDelete(index),
          icon: Icon(Icons.delete_outline),
        ),
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
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            title: Text(
              "Postear hilo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Titulo",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Titulo",
                        ),
                      ),
                      PostearHiloDialog.marginSection,
                      Text(
                        "Descripcion",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        minLines: 5,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Descripción",
                        ),
                      ),
                      PostearHiloDialog.marginSection,
                      Text(
                        "Portada",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      //---portada---
                      if (!postearHiloController.hayPortadaSeleccionada)
                        _sinPortadaSeleccionadaWidget()
                      else
                        Container(),
                      PostearHiloDialog.marginSection,
                      Text(
                        "Encuesta",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                      Text(
                        "Banderas",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      _banderasWidget(),
                      PostearHiloDialog.marginSection,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text("Postear"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Dialog.fullscreen(child: child);
        }

        Size size = MediaQuery.of(context).size;

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: size.height * 0.85),
            child: SizedBox(
              width: 600,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: child,
              ),
            ),
          ),
        );
      },
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Checkbox(
                        value: postearHiloController.dados.value,
                        onChanged: (value) =>
                            postearHiloController.dados.value = value!)
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Id unico",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Checkbox(
                      value: postearHiloController.idUnico.value,
                      onChanged: (value) =>
                          postearHiloController.idUnico.value = value!,
                    )
                  ],
                )
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
        )
    ];
  }

  Column _sinPortadaSeleccionadaWidget() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.file_copy),
                label: Text(
                  "Agregar Archivo",
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.link),
                label: Text(
                  "Agregar enlace",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
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
          ),
        ).marginOnly(top: 10)
      ],
    );
  }
}
