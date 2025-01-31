import 'package:dartz/dartz.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/hilos/domain/models/portada_model.dart';

abstract class IHilosRepository {
  Future<Either<Failure, List<PortadaModel>>> getPortadas();
}