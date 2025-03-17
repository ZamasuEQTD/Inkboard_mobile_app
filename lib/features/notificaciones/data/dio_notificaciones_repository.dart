import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/exception_extensions.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/response_extensions.dart';
import 'package:inkboard/features/notificaciones/domain/inotificaciones_repository.dart';
import 'package:inkboard/features/notificaciones/domain/models/notificacion.dart';

class DioNotificacionesRepository extends INotificacionesRepository {
  final Dio dio = GetIt.I.get();

  @override
  Future<Either<Failure, List<Notificacion>>> getMisNotificaciones({
    String? ultimaNotificacion,
  }) async {
    try {
      final response = await dio.get(
        '/notificaciones',
        queryParameters: {'ultima_notificacion': ultimaNotificacion},
      );

      if (response.isFailure) return Left(response.toFailure);

      final List<Notificacion> notificaciones = [];

      for (var element in response.data) {
        notificaciones.add(Notificacion.fromJson(element));
      }

      return Right(notificaciones);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, Unit>> leerNotificacion({required String id}) async {
    try {
      var resposse = await dio.post('/notificaciones/$id/leer');

      if (resposse.isFailure) return Left(resposse.toFailure);

      return const Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, Unit>> leerTodas() async {
    try {
      var response = await dio.post('/notificaciones/leer-todas');

      if (response.isFailure) return Left(response.toFailure);

      return const Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }
}
