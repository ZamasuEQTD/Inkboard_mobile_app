import 'dart:collection';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/auth/domain/itoken_decoder.dart';
import 'package:inkboard/features/auth/domain/itoken_storage.dart';

class AuthenticatedUser {
  final String username;

  final List<Roles> roles;

  const AuthenticatedUser({required this.username, required this.roles});

  factory AuthenticatedUser.formJson(Map<String, dynamic> json) {
    return AuthenticatedUser(
      username: json["name"],
      roles: json["role"]
          .map<Roles>(
            (e) => Roles.values.firstWhere(
              (element) => element.name == (e as String).toLowerCase(),
            ),
          )
          .toList(),
    );
}
  
}

enum Roles { moderador, owner, anonimo }

class AuthController extends GetxController {
  final ITokenStorage _storage = GetIt.I.get();
  final ITokenDecoder _decoder = GetIt.I.get();

  final Rx<String?> token = Rx(null);
  final Rx<AuthenticatedUser?> usuario = Rx(null);

  final RxBool authenticando = false.obs;

  bool get authenticado => usuario.value != null;

  bool get esModerador => usuario.value?.roles.contains(Roles.moderador) ?? false;
  AuthenticatedUser get currentUser => usuario.value ?? (throw Exception('No está autenticado'));
  @override
  void onInit() async {
    restaurarSesion();

    super.onInit();
  }

  void restaurarSesion() async {
    String? token = await _storage.recuperar();

    if (token == null) return;

    this.token.value = token;

    usuario.value = await _decoder.decode(token);
  }


  Future<void> login(String token) async {
    if (authenticando.value) return;

    authenticando.value = true;

    await _storage.guardar(token);

    this.token.value = token;

    AuthenticatedUser decodedUsuario = await _decoder.decode(token);

    usuario.value = decodedUsuario;
  }

  Future<void> logout() async {
    await _storage.eliminar();

    token.value = null;
    usuario.value = null;
  }
}
