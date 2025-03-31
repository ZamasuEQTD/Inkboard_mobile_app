import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/exception_extensions.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/response_extensions.dart';
import 'package:inkboard/features/encuestas/domain/iencuesta_repository.dart';

class DioEncuestaRepository extends IEncuestaRepository {
  final Dio dio = GetIt.I.get();

  @override
  Future<Either<Failure, Unit>> votar(String encuesta, String respuesta) async {
    try {
      final response = await dio.post(
        'encuestas/votar/encuesta/$encuesta/respuesta/$respuesta',
      );

      if (response.isFailure) {
        return Left(response.toFailure);
      }

      return const Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }
}
