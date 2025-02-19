import 'package:inkboard/features/auth/presentation/logic/controllers/auth_controller.dart';

abstract class ITokenDecoder {
  Future<AuthenticatedUser> decode(String token);
}