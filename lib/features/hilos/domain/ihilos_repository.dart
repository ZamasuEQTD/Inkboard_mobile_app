import 'package:dartz/dartz.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/hilos/domain/models/comentario_model.dart';
import 'package:inkboard/features/hilos/domain/models/portada_model.dart';

abstract class IHilosRepository {
  Future<Either<Failure, List<PortadaModel>>> getPortadas( {
    String? ultimaPortada
  });

  Future<Either<Failure, List<ComentarioModel>>> getComentarios(String hilo);
}