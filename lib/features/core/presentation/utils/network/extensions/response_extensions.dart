import 'package:dio/dio.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/core/presentation/utils/network/network_failures.dart';

extension ResponseExtensions on Response {

  static List<int> codes = [200, 201, 204];
  Failure get toFailure {


    return NetworkFailures.serverError;
  }

  bool get isFailure => !codes.contains(statusCode);
}
