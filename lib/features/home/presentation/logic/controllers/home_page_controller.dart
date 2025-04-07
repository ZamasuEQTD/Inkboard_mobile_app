import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/hilos/domain/ihilos_repository.dart';
import 'package:inkboard/features/hilos/domain/models/portada_model.dart';

class HomePageController extends GetxController {
  final Rx<List<PortadaModel>> portadas = Rx([]);

  final RxBool cargandoPortadas = false.obs;

  final IHilosRepository repository = GetIt.I.get();

  String? ultimaPortada;

  final RxBool hayMasContenido = true.obs;

  void cargarPortadas() async {
    if (!hayMasContenido.value) return;

    if (cargandoPortadas.value) return;

    cargandoPortadas.value = true;

    final response = await repository.getPortadas(ultimaPortada: ultimaPortada);

    response.fold((l) {}, (r) {

      if(r.isEmpty){
        hayMasContenido.value = false;
      } else  {
        portadas.value = [...portadas.value, ...r];


        ultimaPortada = r.last.id;
      }
    });

    cargandoPortadas.value = false;
  }

  void reiniciar() {
    portadas.value = [];
    ultimaPortada = null;
    hayMasContenido.value = true;
    cargarPortadas();
  }

  void eliminarPortada(String id) {
    portadas.value = portadas.value
        .where((element) => element.id != id)
        .toList();
  }

  void agregarPortada(PortadaModel portada) {
    portadas.value = [portada, ...portadas.value];
  }
}
