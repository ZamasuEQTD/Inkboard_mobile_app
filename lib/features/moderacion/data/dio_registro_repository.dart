import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/exception_extensions.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/response_extensions.dart';
import 'package:inkboard/features/moderacion/domain/iregistro_repository.dart';
import 'package:inkboard/features/moderacion/domain/models/registro.dart';

class DioRegistroRepository extends IRegistrosRepository {
  final Dio dio = GetIt.I.get();

  @override
  Future<Either<Failure, List<HiloComentadoRegistro>>> getComentariosHistorial(
    String id, {
    String? ultimoComentario,
  }) async{
    try {
      Response response = await dio.get(
        "/registros/comentarios/usuario/$id",
        queryParameters: {
          if (ultimoComentario != null) 'ultimo_comentario': ultimoComentario,
        },
      );

      if (response.isFailure) {
        return Left(response.toFailure);
      }

      List<Map<String, dynamic>> value = List.from(response.data!["data"]);

      return Right(
        value
            .map(
              (e) => HiloComentadoRegistro.fromJson(
                Map<String, dynamic>.from({...e}),
              ),
            )
            .toList(),
      );

    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, List<HiloPosteadoRegistro>>> getHilosHistorial(
    String id, {
    String? ultimoHilo,
  }) async {
    try {
      Response response = await dio.get(
        "/registros/hilos-posteados/usuario/$id",
        queryParameters: {
          if (ultimoHilo != null) 'ultimo_hilo': ultimoHilo,
        },
      );

      if (response.isFailure) {
        return Left(response.toFailure);
      }

      List<Map<String, dynamic>> value = List.from(response.data!["data"]);

      return Right(
        value
            .map(
              (e) => HiloPosteadoRegistro.fromJson(
                Map<String, dynamic>.from({...e}),
              ),
            )
            .toList(),
      );
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, RegistroUsuario>> getRegistroUsuario(String id) async {
    try {
      Response response = await dio.get("/registros/usuario/$id");

      if (response.isFailure) {
        return Left(response.toFailure);
      }

      return Right(RegistroUsuario.fromJson(response.data["data"]));
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }
}
