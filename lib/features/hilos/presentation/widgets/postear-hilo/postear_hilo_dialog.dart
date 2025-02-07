import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostearHiloController extends GetxController {
  final Rx<List<TextEditingController>> encuesta = Rx([]);

  addOpcion() {
    encuesta.value = [...encuesta.value, TextEditingController()];
  }

  eliminarOpcion(int index) {
    encuesta.value[index].dispose();
    
    encuesta.value.removeAt(index);

    encuesta.refresh();
  }

  void postear() {}
}

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
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                title: Text(
                  "Postear hilo",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "Titulo",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: InputBorder.none,
                  hintText: "Titulo",
                ),
              ),
              PostearHiloDialog.marginSection,
              Text(
                "Descripcion",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                minLines: 5,
                maxLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  hintText: "Descripción",
                ),
              ),
              PostearHiloDialog.marginSection,
              Text(
                "Encuesta",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (true)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.grey.shade200),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Seleccionar Portada",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            )),
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.grey.shade200),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Seleccionar Portada",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              Text(
                "Encuesta",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (postearHiloController.encuesta.value.isEmpty)
                ElevatedButton(
                  onPressed: () {
                    postearHiloController.addOpcion();
                  },
                  child: Text("Agregar encuesta"),
                )
              else ...[
                ...this.postearHiloController.encuesta.value.asMap().entries.map((entry) {
                    log(entry.key.toString());
                    return EncuestaOpcionTextField(
                      controller: entry.value,
                      index: entry.key,
                      onDelete: (index) {
                        postearHiloController.eliminarOpcion(index);
                      },
                    );
                  }),
                ElevatedButton(
                  onPressed: () {
                    postearHiloController.addOpcion();
                  },
                  child: Text("Agregar encuesta"),
                )
              ],
              PostearHiloDialog.marginSection,
              Text(
                "Banderas",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ClipRRect(
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
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Checkbox(
                                value: false,
                                onChanged: (value) {},
                              )
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Id unico",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Checkbox(
                                value: false,
                                onChanged: (value) {},
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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
      );
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Dialog.fullscreen(child: child);
        }

        return Dialog(
          backgroundColor: Colors.white,
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 800), child: child),
        );
      },
    );
  }
}
