import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';

class Spoileable<T> extends Equatable {
  final bool spoiler;

  final T value;

  const Spoileable({required this.spoiler, required this.value});

  @override
  // TODO: implement props
  List<Object?> get props => [this.value, this.spoiler];

  Spoileable<T> copyWith({bool? spoiler, T? value}) {
    return Spoileable<T>(
      spoiler: spoiler ?? this.spoiler,
      value: value ?? this.value,
    );
  }
}

class PostearHiloController extends GetxController {
  final titulo = "".obs;
  final descripcion = "".obs;

  final dados = false.obs;
  final idUnico = false.obs;

  final RxList<TextEditingController> encuesta = RxList([]);

  final Rx<Spoileable<PickedFile>?> pickedFile = Rx(null);

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

  Future<void> postear() async {
    if (isPosteando) return;
  }

  void switchSpoiler() {
     pickedFile.value =  pickedFile.value!.copyWith(
      spoiler: !isSpoiler,
    );
  }

  void agregarPortada(PickedFile file){
    pickedFile.value = Spoileable(spoiler: false, value: file);
  }

  void eliminarPortada(){
    pickedFile.value = null;
  }

  bool get isPosteando => posteando.value;
  bool get hayEncuesta => encuesta.isNotEmpty;
  bool get hayPortadaSeleccionada => pickedFile.value != null;
  bool get puedeAgregarOpcionDeEncuesta => encuesta.length < 4;
  bool get isSpoiler => pickedFile.value!.spoiler;
}
