import 'package:flutter/material.dart';

extension ScrollControllerExtensions on ScrollController {
  bool get isBottom => position.pixels >= position.maxScrollExtent - 200;


  void onBottom(void Function() onBottom) {
    this.addListener((){
      if (isBottom) onBottom();
    });
  }
}
