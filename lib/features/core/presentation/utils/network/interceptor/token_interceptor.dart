import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/auth/presentation/logic/controllers/auth_controller.dart';

class TokenInterceptor extends Interceptor {
  final AuthController controller = GetIt.I.get();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if(controller.authenticado) {
      options.headers["Authorization"] = "Bearer ${controller.token.value}";
    }

    super.onRequest(options, handler);
  }
}