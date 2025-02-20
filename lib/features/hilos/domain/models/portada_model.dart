class PortadaModel {
  final String id;
  final String titulo;
  final String subcategoria;
  final bool esNuevo;
  final MiniaturaModel miniatura;
  final Banderas banderas;

  const PortadaModel({
    required this.id,
    required this.titulo,
    required this.subcategoria,
    required this.esNuevo,
    required this.miniatura,
    required this.banderas
  });

  factory PortadaModel.fromJson(Map<String, dynamic> json) {
    return PortadaModel(
      id: json['id'],
      titulo: json['titulo'],
      subcategoria: json['subcategoria'],
      esNuevo: json['es_nuevo'],
      miniatura: MiniaturaModel.fromJson(json['miniatura']),
      banderas: Banderas.fromJson(json['banderas']),
    );
  }
}

class MiniaturaModel {
  final String url;
  final bool spoiler;

  const MiniaturaModel({required this.url, required this.spoiler});

  factory MiniaturaModel.fromJson(Map<String, dynamic> json) {
    return MiniaturaModel(
      url: json['url'],
      spoiler: json['spoiler'],
    );
  }
}
 
class Banderas {
final bool esSticky;
 final bool tieneEncuesta;
 final bool dadosActivado;
 final bool idUnicoActivado;

  const Banderas({
    required this.esSticky,
    required this.tieneEncuesta,
    required this.dadosActivado,
    required this.idUnicoActivado,
  });

  factory Banderas.fromJson(Map<String, dynamic> json) {
    return Banderas(
      esSticky: json['es_sticky'],
      tieneEncuesta: json['tiene_encuesta'],
      dadosActivado: json['dados_activado'],
      idUnicoActivado: json['id_unico_activado'],
    );
  }
}