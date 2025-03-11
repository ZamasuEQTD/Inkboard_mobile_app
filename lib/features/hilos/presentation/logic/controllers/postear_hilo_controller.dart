import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/categorias/domain/models/subcategoria.dart';
import 'package:inkboard/features/hilos/domain/ihilos_repository.dart';
import 'package:inkboard/features/hilos/domain/models/hilo.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';

class Spoileable<T> extends Equatable {
  final bool spoiler;

  final T value;

  const Spoileable({required this.spoiler, required this.value});

  @override
  List<Object?> get props => [this.value, this.spoiler];

  Spoileable<T> copyWith({bool? spoiler, T? value}) {
    return Spoileable<T>(
      spoiler: spoiler ?? this.spoiler,
      value: value ?? this.value,
    );
  }
}

class PostearHiloController extends GetxController {
  final titulo = TextEditingController();
  final descripcion = TextEditingController();

  final Rx<SubcategoriaModel?> subcategoria = Rx(null);

  final dados = false.obs;
  final idUnico = false.obs;

  final RxList<TextEditingController> encuesta = RxList([]);

  final Rx<Spoileable<PickedFile>?> pickedFile = Rx(null);

  final posteando = false.obs;

  final IHilosRepository _repository = GetIt.I.get();

  void addOpcion() {
    if (!puedeAgregarOpcionDeEncuesta) return;

    encuesta.value = [...encuesta, TextEditingController()];
  }

  void eliminarOpcion(int index) {
    encuesta[index].dispose();

    encuesta.removeAt(index);

    encuesta.refresh();
  }

  void switchSpoiler() {
    pickedFile.value = pickedFile.value!.copyWith(spoiler: !isSpoiler);
  }

  void agregarPortada(PickedFile file) {
    pickedFile.value = Spoileable(spoiler: false, value: file);
  }

  void eliminarPortada() {
    pickedFile.value = null;
  }

  void postear() async {
    if (isPosteando) return;

    posteando.value = true;

    var result = await _repository.postear(
      titulo: titulo.text,
      descripcion: descripcion.text,
      subcategoria: subcategoria.value!.id,
      dados: dados.value,
      encuesta: encuesta.map((o) => o.text).toList(),
      idUnico: idUnico.value,
      spoiler: isSpoiler,
      portada: pickedFile.value!.value,
    );

    posteando.value = false;

    result.fold((l) {}, (r) {
      Get.back();

      Get.toNamed("hilo/$r");
    });
  }

  bool get isPosteando => posteando.value;
  bool get hayEncuesta => encuesta.isNotEmpty;
  bool get hayPortadaSeleccionada => pickedFile.value != null;
  bool get puedeAgregarOpcionDeEncuesta => encuesta.length < 4;
  bool get isSpoiler => pickedFile.value!.spoiler;
  bool get haySubcategoriaSeleccionada => subcategoria.value != null;
}
