import 'package:dartz/dartz.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';

import 'models/baneos.dart';

abstract class IBaneosRepository {
  Future<Either<Failure, Unit>> banear({
    required String id,
    required RazonBaneo razon,
    required DuracionBaneo duracion,
    String? mensaje,
  });

  Future<Either<Failure, Unit>> desbanear({
    required String id,
  });
}
