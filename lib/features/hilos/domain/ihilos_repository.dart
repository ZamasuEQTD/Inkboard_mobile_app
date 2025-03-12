import 'package:dartz/dartz.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/hilos/domain/models/comentario_model.dart';
import 'package:inkboard/features/hilos/domain/models/hilo.dart';
import 'package:inkboard/features/hilos/domain/models/portada_model.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';

abstract class IHilosRepository {
  Future<Either<Failure, List<PortadaModel>>> getPortadas({
    String? ultimaPortada,
  });

  Future<Either<Failure, ComentariosHilo>> getComentarios(
    String hilo, {
    String? ultimoComentario,
  });

  Future<Either<Failure, HiloModel>> getHilo(String hilo);

  Future<Either<Failure, Unit>> comentar(
    String hilo, {
    required String comentario,
    PickedFile? file,
  });

  Future<Either<Failure, Unit>> establecerSticky(String hilo);

  Future<Either<Failure, Unit>> seguir(String hilo);
  Future<Either<Failure, Unit>> ocultar(String hilo);
  Future<Either<Failure, Unit>> establecerFavorito(String hilo);

  Future<Either<Failure, Unit>> eliminarSticky(String hilo);
  Future<Either<Failure, Unit>> eliminar(String hilo);

  Future<Either<Failure, String>> postear({
    required String titulo,
    required String descripcion,
    required String subcategoria,
    required List<String> encuesta,
    required bool spoiler,
    required PickedFile portada,
    required bool dados,
    required bool idUnico,
  });
}

class ComentariosHilo {
  final List<ComentarioModel> comentarios;
  final List<ComentarioModel> destacados;

  const ComentariosHilo({required this.comentarios, required this.destacados});

  factory ComentariosHilo.fromJson(Map<String, dynamic> json) {
    return ComentariosHilo(
      comentarios:
          (json['comentarios'] as List<dynamic>)
              .map((e) => ComentarioModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      destacados:
          (json['destacados'] as List<dynamic>)
              .map((e) => ComentarioModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}
