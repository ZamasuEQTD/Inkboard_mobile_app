import 'dart:collection';
import 'dart:developer';

import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/app/presentation/logic/controllers/app_failure_controller.dart';
import 'package:inkboard/features/app/presentation/widgets/snackbar.dart';
import 'package:inkboard/features/core/domain/util/tag_util.dart';
import 'package:inkboard/features/hilos/domain/ihilos_repository.dart';
import 'package:inkboard/features/hilos/domain/models/comentario_model.dart';
import 'package:inkboard/features/hilos/domain/models/hilo.dart';
import 'package:inkboard/features/media/domain/ifile_picker_service.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';

class HiloPageController extends GetxController {
  static int cantidadMaximaDeTaggueos = 5;

  final String id;

  final TextEditingController comentario = TextEditingController();
  final RxList<PickedFile> files = RxList([]);

  final HashMap<String, ComentarioModel> comentariosMap = HashMap();
  final RxList<ComentarioModel> destacados = RxList([]);
  final RxList<ComentarioModel> comentarios = RxList([]);
  final Rx<HiloModel?> hilo = Rx(null);

  final RxBool cargandoHilo = false.obs;
  final RxBool cargandoComentarios = false.obs;
  final RxBool comentandoHilo = false.obs;

  final IFilePickerService _picker = GetIt.I.get();

  final IHilosRepository _repository = GetIt.I.get();

  HiloPageController({required this.id});

  @override
  void onInit() {
    hilo.listen((p0) {
      if (p0 == null) return;

      log(p0.titulo);
    });

    super.onInit();
  }

  void cargarHilo() async {
    cargandoHilo.value = true;
    var res = await _repository.getHilo(id);

    res.fold((l) {}, (r) async {
      hilo.value = r;

      cargandoComentarios.value = true;

      var result = await _repository.getComentarios(hilo.value!.id);

      result.fold((l) {}, (r) {
        for (var c in r.comentarios) {
          comentariosMap[c.tag] = c;
        }

        destacados.value = r.destacados;
        comentarios.value = r.comentarios;
      });

      cargandoComentarios.value = false;
    });

    cargandoHilo.value = false;
  }

  void cargarComentarios() async {
    var res = await _repository.getComentarios("hilo");

    res.fold((l) {}, (r) {});
  }

  void tagguear(String tag) {
    if (limiteDeTaggueosAlcanzado) return;

    if (haTagueadoA(tag)) return;

    comentario.text += ">>$tag ";
  }

  void comentar() async {
    if (comentandoHilo.value) return;

    comentandoHilo.value = true;

    var resonse = await _repository.comentar(
      id,
      comentario: comentario.text,
      file: files.firstOrNull,
    );
    resonse.fold((l) {
      Get.find<AppFailureController>().setFailure(l);
    }, (r) {
      this.comentario.text = "";
      files.value = [];
    });

    comentandoHilo.value = false;
  }

  List<ComentarioModel> getPorTags(List<String> tags) {
    List<ComentarioModel> comentarios = [];

    for (var tag in tags) {
      ComentarioModel? c = comentariosMap[tag];

      if (c != null) {
        comentarios.add(c);
      }
    }

    return comentarios;
  }

  Future pickGaleriaFile() async {
    var picked = await _picker.pickOne();

    if (picked == null) return;

    files.value = [];

    files.value = [picked];

    Get.back();
  }

  void removeFileAt(int index) {
    files.removeAt(index);
  }

  void blurearFile(int index) {
    PickedFile file = files[index];

    files[index] = file.copyWith(spoiler: !file.spoiler);

    files.refresh();
  }

  bool haTagueadoA(String tag) => TagUtils.incluyeTag(comentario.text, tag);
  bool get limiteDeTaggueosAlcanzado =>
      TagUtils.cantidadTags(comentario.text) >= cantidadMaximaDeTaggueos;
  bool get hayMediaSeleccionada => files.isNotEmpty;
}
