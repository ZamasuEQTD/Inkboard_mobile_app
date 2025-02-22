import 'package:inkboard/features/media/domain/models/media.dart';

class HiloModel {
  final String id;
  final String titulo;
  final String descripcion;
  final String? autorId;
  final bool esOp;
  final int cantidadComentarios;
  final bool? recibirNotificaciones;
  final SubcategoriaModel subcategoria;
  final DateTime createdAt;
  final MediaModel media;
  final EncuestaModel? encuesta;
  final String autorRole;
  final String autor;

  const HiloModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    this.autorId,
    required this.esOp,
    required this.cantidadComentarios,
    this.recibirNotificaciones,
    required this.subcategoria,
    required this.createdAt,
    required this.media,
    this.encuesta,
    required this.autorRole,
    required this.autor,
  });

  factory HiloModel.fromJson(Map<String, dynamic> json) {
    return HiloModel(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      autorId: json['autor_id'] as String?,
      esOp: json['es_op'] as bool,
      cantidadComentarios: json['cantidad_comentarios'] as int,
      recibirNotificaciones: json['recibir_notificaciones'] as bool?,
      subcategoria: SubcategoriaModel.fromJson(json['subcategoria'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      media: MediaModel.fromJson(json['media'] as Map<String, dynamic>),
      encuesta: json['encuesta'] != null ? EncuestaModel.fromJson(json['encuesta'] as Map<String, dynamic>) : null,
      autorRole: json['autor_role'] as String,
      autor: json['autor'] as String,
    );
  }
}

class EncuestaModel {
  final String id;
  final List<RespuestaModel> respuestas;
  final String? respuestaVotada;

  const EncuestaModel({
    required this.id,
    required this.respuestas,
    required this.respuestaVotada,
  });

  factory EncuestaModel.fromJson(Map<String, dynamic> json) {
    var respuestasFromJson = json['respuestas'] as List;
    List<RespuestaModel> respuestasList = respuestasFromJson.map((respuesta) => RespuestaModel.fromJson(respuesta as Map<String, dynamic>)).toList();

    return EncuestaModel(
      id: json['id'] as String,
      respuestas: respuestasList,
      respuestaVotada: json['respuesta_votada'] as String?,
    );
  }
}

class RespuestaModel {
  final String id;
  final String respuesta;
  final int votos;

  const RespuestaModel({
    required this.id,
    required this.respuesta,
    required this.votos,
  });
  factory RespuestaModel.fromJson(Map<String, dynamic> json) {
    return RespuestaModel(
      id: json['id'] as String,
      respuesta: json['respuesta'] as String,
      votos: json['votos'] as int,
    );
  }
}

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