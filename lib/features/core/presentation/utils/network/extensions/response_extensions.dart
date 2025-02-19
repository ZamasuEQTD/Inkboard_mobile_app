import 'package:dio/dio.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/exception_extensions.dart';
import 'package:inkboard/features/core/presentation/utils/network/network_failures.dart';

extension ResponseExtensions on Response {
  Failure get toFailure {


    return NetworkFailures.serverError;
  }

  bool get isFailure => statusCode != 200;
}
