class TagUtils {
  const TagUtils._();

  // Expresión regular para encontrar tags en el formato >>A1B2C3D4
  static final RegExp tagRegex = RegExp(r'>>[A-Z0-9]{8}');

  // Obtiene una lista de tags encontrados en el texto
  static List<String> getTags(String texto) {
    return tagRegex.allMatches(texto).map((match) => match.group(0)!).toList();
  }

  // Retorna la cantidad de tags encontrados en el texto
  static int cantidadTags(String texto) {
    return getTags(texto).length;
  }

  // Verifica si el texto incluye un tag específico
  static bool incluyeTag(String texto, String tag) {
    return texto.contains('>>$tag');
  }
}
