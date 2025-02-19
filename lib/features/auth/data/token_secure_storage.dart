import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/auth/domain/itoken_storage.dart';

class TokenSecureStorage extends ITokenStorage {
  
  static const String key = "token";

  final FlutterSecureStorage _storage = GetIt.I.get();

  @override
  Future<void> eliminar() {
    return _storage.delete(key: key);
  }

  @override
  Future<void> guardar(String token) {
    return _storage.write(key: key, value: token);
  }

  @override
  Future<String?> recuperar() {
    return _storage.read(key: key);
  }
}
