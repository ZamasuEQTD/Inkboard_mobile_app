import 'package:inkboard/features/auth/domain/itoken_decoder.dart';
import 'package:inkboard/features/auth/presentation/logic/controllers/auth_controller.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenDecoder extends ITokenDecoder {
  @override
  Future<AuthenticatedUser> decode(String token) {
    Map<String, dynamic> json = JwtDecoder.decode(token);

    return Future.value(AuthenticatedUser.formJson(json));
  }
}
