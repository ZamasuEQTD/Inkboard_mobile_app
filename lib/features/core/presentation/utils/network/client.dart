import 'package:dio/dio.dart';
import 'package:inkboard/features/core/presentation/utils/network/interceptor/token_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var env = dotenv.env;

Dio httpClient = Dio(BaseOptions(baseUrl: env['BASE_URL']!))
  ..interceptors.add(TokenInterceptor());
