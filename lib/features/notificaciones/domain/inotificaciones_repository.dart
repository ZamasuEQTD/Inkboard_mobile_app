
import 'package:dartz/dartz.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/notificaciones/domain/models/notificacion.dart';

abstract class INotificacionesRepository {
  Future<Either<Failure, List<Notificacion>>> getMisNotificaciones({
    String? ultimaNotificacion
  });

  Future<Either<Failure, Unit>> leerNotificacion({
    required String id,
  });

  Future<Either<Failure, Unit>> leerTodas();
}
