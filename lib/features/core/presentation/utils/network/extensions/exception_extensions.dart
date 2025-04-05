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

    if(response != null && response!.data != null){
      var data = response!.data;

      return Failure(code: data["title"], descripcion: data["detail"]?? "Error del servidor");
    }

    return NetworkFailures.unknow;
  }
}