import 'package:inkboard/features/categorias/domain/models/subcategoria.dart';

class CategoriaModel {
  final String nombre;
  final List<SubcategoriaModel> subcategorias;

  const CategoriaModel({required this.nombre, required this.subcategorias});

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      nombre: json['nombre'] as String,
      subcategorias:
          (json['subcategorias'] as List<dynamic>)
              .map(
                (subcategoria) => SubcategoriaModel.fromJson(
                  subcategoria as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }
}
