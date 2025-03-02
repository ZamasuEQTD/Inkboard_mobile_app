
import 'package:equatable/equatable.dart';

class RegistroUsuario extends Equatable {
  final String? nombre;
  final DateTime registradoEn;
  const RegistroUsuario({
    this.nombre,
    required this.registradoEn,
  });

  factory RegistroUsuario.fromJson(Map<String, dynamic> json) =>
      RegistroUsuario(
        nombre: json["staffname"],
        registradoEn: DateTime.parse(json["registrado_en"]),
      );

  @override
  List<Object?> get props => [nombre, registradoEn];
}

typedef RegistroId = String;

abstract class Registro {
  final HiloRegistro hilo;
  final DateTime fecha;
  final String contenido;
  const Registro({
    required this.hilo,
    required this.fecha,
    required this.contenido,
  });
}

class HiloPosteadoRegistro extends Registro {
  const HiloPosteadoRegistro({
    required super.hilo,
    required super.fecha,
    required super.contenido,
  });

  factory HiloPosteadoRegistro.fromJson(Map<String, dynamic> json) =>
      HiloPosteadoRegistro(
        hilo: HiloRegistro.fromJson(Map<String, dynamic>.from(json)),
        fecha: DateTime.parse(json["created_at"]),
        contenido: json["contenido"],
      );
}

class HiloComentadoRegistro extends Registro {
  final String id;
  final String comentario;
  final String? imagen;
  const HiloComentadoRegistro({
    required this.id,
    required super.hilo,
    required super.fecha,
    required super.contenido,
    required this.comentario,
    this.imagen,
  });

  factory HiloComentadoRegistro.fromJson(Map<String, dynamic> json) =>
      HiloComentadoRegistro(
        id: json["comentario_id"],
        fecha: DateTime.parse(json["created_at"]),
        contenido: json["contenido"],
        hilo: HiloRegistro.fromJson(json),
        comentario: json["comentario_tag"],
        imagen: json["imagen"],
      );
}

class HiloRegistro {
  final String id;
  final String titulo;
  final String portada;
  const HiloRegistro({
    required this.id,
    required this.titulo,
    required this.portada,
  });

  factory HiloRegistro.fromJson(Map<String, dynamic> json) => HiloRegistro(
        id: json["id"],
        titulo: json["titulo"],
        portada:  json["miniatura"],
      );
}
