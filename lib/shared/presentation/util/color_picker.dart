import 'package:flutter/material.dart';

class ColorPicker {
  // Lista de colores predefinidos usando Material Design Colors
  static final List<Color> colors = [
    Colors.yellow.shade500,
    Colors.red.shade500,
    Colors.blue.shade500,
    Colors.green.shade500,
    Colors.purple.shade500,
    Colors.pink.shade500,
    Colors.indigo.shade500,
    Colors.teal.shade500,
    Colors.orange.shade500,
    Colors.grey.shade500,
    Colors.lime.shade500,
    Colors.amber.shade500,
    Colors.brown
        .shade500, // Nota: No existe en Flutter, usar Colors.teal.shade500 como alternativa
    Colors.cyan.shade500,
  ];

  // Constructor privado para evitar instanciación
  ColorPicker._();

  // Genera un color basado en el texto proporcionado
  static Color generar(String text) {
    return generarFromColors(text, colors);
  }

  // Genera un color basado en el texto y una lista personalizada de colores
  static Color generarFromColors(String text, List<Color> colors) {
    if (text.isEmpty) {
      throw ArgumentError("[text] no puede estar vacía");
    }
    if (colors.isEmpty) {
      throw ArgumentError("[colors] no puede estar vacía");
    }

    int n = 0;

    // Suma los valores de los caracteres del texto
    for (int i = 0; i < text.length; i++) {
      n += text.codeUnitAt(i);
    }

    // Calcula el índice del color basado en la suma de los caracteres
    int index = n % colors.length;

    return colors[index];
  }
}
