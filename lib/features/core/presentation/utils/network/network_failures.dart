import 'package:inkboard/features/core/domain/models/failure.dart';

class NetworkFailures {
  static const Failure serverError = Failure(
    code: "Conexion.ErrorServidor",
    descripcion: "Error del servidor",
  );

  static const Failure sinConexion = Failure(
    code: "Conexion.SinConexion",
    descripcion: "Sin conexión a internet",
  );

  static const unknow = Failure(
    code: "Unknown",
    descripcion: "Error desconocido",
  );
}
