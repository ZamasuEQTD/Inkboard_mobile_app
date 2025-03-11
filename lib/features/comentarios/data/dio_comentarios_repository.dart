import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/comentarios/domain/icomentarios_repository.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/exception_extensions.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/response_extensions.dart';

class DioComentariosRepository extends IComentariosRepository {
  final Dio dio = GetIt.I.get();

  @override
  Future<Either<Failure, Unit>> destacar(
    String comentarioId,
    String hiloId,
  ) async {
    try {
      var response = await dio.post(
        "comentarios/hilo/$hiloId/destacar/comentario/$comentarioId",
      );

      if (response.isFailure) return Left(response.toFailure);

      return Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, Unit>> eliminar(
    String comentarioId,
    String hiloId,
  ) async {
    try {
      var response = await dio.delete(
        "comentarios/hilo/$hiloId/eliminar/comentario/$comentarioId",
      );

      if (response.isFailure) return Left(response.toFailure);

      return Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, Unit>> ocultar(
    String comentarioId,
    String hiloId,
  ) async {
    try {
      var response = await dio.post(comentarioId);

      if (response.isFailure) return Left(response.toFailure);

      return Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }
}
