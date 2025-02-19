import 'package:dio/dio.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/core/presentation/utils/network/network_failures.dart';


extension NetworkExceptionExtensions on Exception {
  Failure get toFailure {
    if (this is DioException) {
      return (this as DioException).toDioFailure;
    }

    return NetworkFailures.unknow;
  }
}

extension DioExtensions on DioException {
  Failure get toDioFailure {
    return NetworkFailures.unknow;
  }
}