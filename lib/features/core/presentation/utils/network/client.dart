import 'package:dio/dio.dart';
import 'package:inkboard/features/core/presentation/utils/network/interceptor/token_interceptor.dart';

Dio httpClient = Dio(BaseOptions(baseUrl: ""))..interceptors.add(TokenInterceptor());
