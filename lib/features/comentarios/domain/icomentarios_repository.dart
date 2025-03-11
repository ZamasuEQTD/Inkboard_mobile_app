import 'package:dartz/dartz.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';

abstract class IComentariosRepository {
  Future<Either<Failure, Unit>> destacar(String comentarioId, String hiloId);
  Future<Either<Failure, Unit>> eliminar(String comentarioId, String hiloId);
  Future<Either<Failure, Unit>> ocultar(String comentarioId, String hiloId);
}
