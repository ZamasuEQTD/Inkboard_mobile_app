import 'package:dartz/dartz.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';

abstract class IEncuestaRepository {
  Future<Either<Failure, Unit>> votar(String encuesta, String respuesta);
}
