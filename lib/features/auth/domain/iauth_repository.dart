import 'package:dartz/dartz.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';

abstract class IAuthRepository {
  Future<Either<Failure, String>> login({
    required String usuario,
    required String password,
  });
  Future<Either<Failure, String>> registro({
    required String usuario,
    required String password,
  });
}
