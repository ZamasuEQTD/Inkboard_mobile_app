import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/exception_extensions.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/response_extensions.dart';
import 'package:inkboard/features/moderacion/domain/ibaneos_repository.dart';
import 'package:inkboard/features/moderacion/domain/models/baneos.dart';

class DioBaneosRepository extends IBaneosRepository {
  final Dio dio = GetIt.I.get();

  @override
  Future<Either<Failure, Unit>> banear({
    required String id,
    required RazonBaneo razon,
    required DuracionBaneo duracion,
    String? mensaje,
  }) async {
    try {
      Response response = await dio.post(
        "/baneos/banear/$id",
        data: {
          "razon": razon.index,
          "duracion": duracion.index,
          "mensaje": mensaje,
        },
      );

      if (response.isFailure) {
        return Left(response.toFailure);
      }

      return const Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, Unit>> desbanear({required String id})async {
     try {
      Response response = await dio.post("/baneos/desbanear/$id");

      if (response.isFailure) {
        return Left(response.toFailure);
      }

      return const Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }
}
