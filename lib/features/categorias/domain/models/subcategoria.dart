class SubcategoriaModel {
  final String id;
  final String nombre;
  final String imagen;

  const SubcategoriaModel({
    required this.id,
    required this.nombre,
    required this.imagen,
  });

  factory SubcategoriaModel.fromJson(Map<String, dynamic> json) {
    return SubcategoriaModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      imagen: json['imagen'] as String,
    );
  }
}
