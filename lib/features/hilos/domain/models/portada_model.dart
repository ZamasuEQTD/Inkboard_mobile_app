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
}

class MiniaturaModel {
  final String url;
  final bool spoiler;

  const MiniaturaModel({required this.url, required this.spoiler});
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
}