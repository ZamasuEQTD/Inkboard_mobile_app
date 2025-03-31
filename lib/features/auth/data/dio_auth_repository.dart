import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:inkboard/features/auth/domain/iauth_repository.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/exception_extensions.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/response_extensions.dart';

class DioAuthRepository extends IAuthRepository {
  final Dio dio = GetIt.I.get();
  @override
  Future<Either<Failure, String>> login({required String usuario, required String password}) async {
    try {
      Response response = await dio.post(
        "auth/login",
        data: {
          "username": usuario,
          "password": password,
        },
      );

      if(response.isFailure) {
        return Left(response.toFailure);
      }

      return Right(response.data["data"]);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, String>> registro({required String usuario, required String password}) {
    throw UnimplementedError();
  }
  
}