import 'package:dio/dio.dart';
import 'package:inkboard/features/core/presentation/utils/network/interceptor/token_interceptor.dart';

Dio httpClient = Dio(BaseOptions(baseUrl: "http://192.168.2.101:3000/api/"))..interceptors.add(TokenInterceptor());
