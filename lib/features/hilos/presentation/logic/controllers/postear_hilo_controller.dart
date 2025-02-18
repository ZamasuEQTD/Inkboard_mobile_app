import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';

class PostearHiloController extends GetxController {
  final titulo = "".obs;
  final descripcion = "".obs;

  final dados = false.obs;
  final idUnico = false.obs;

  final RxList<TextEditingController> encuesta = RxList([]);

  final Rx<PickedFile?> pickedFile = null.obs;

  final posteando = false.obs;

  void addOpcion() {
    if (!puedeAgregarOpcionDeEncuesta) return;

    encuesta.value = [...encuesta, TextEditingController()];
  }

  void eliminarOpcion(int index) {
    encuesta[index].dispose();

    encuesta.removeAt(index);

    encuesta.refresh();
  }

  Future<void> postear() async{
    if(isPosteando) return;
  }

  bool get isPosteando => posteando.value;
  bool get hayEncuesta => encuesta.isNotEmpty;
  bool get hayPortadaSeleccionada => pickedFile.value != null;
  bool get puedeAgregarOpcionDeEncuesta => encuesta.length < 4;
}
