abstract class ITokenStorage {
  Future<void> guardar(String token);
  Future<String?> recuperar();
  Future<void> eliminar();
}