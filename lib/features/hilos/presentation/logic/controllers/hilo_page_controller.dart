import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkboard/features/core/domain/util/tag_util.dart';
import 'package:inkboard/features/hilos/presentation/pages/hilo_page.dart';

class HiloPageController extends GetxController {
  static int cantidadMaximaDeTaggueos = 5;

  final TextEditingController comentario = TextEditingController();

  void tagguear(String tag) {
    if (limiteDeTaggueosAlcanzado) return;

    if (haTagueadoA(tag)) return;

    comentario.text += ">>$tag";
  }

  bool haTagueadoA(String tag) => TagUtils.incluyeTag(comentario.text, tag);

  bool get limiteDeTaggueosAlcanzado =>
      TagUtils.cantidadTags(comentario.text) >= cantidadMaximaDeTaggueos;
}
