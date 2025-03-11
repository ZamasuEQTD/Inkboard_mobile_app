import 'dart:collection';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/exception_extensions.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/response_extensions.dart';
import 'package:inkboard/features/hilos/domain/ihilos_repository.dart';
import 'package:inkboard/features/hilos/domain/models/comentario_model.dart';
import 'package:inkboard/features/hilos/domain/models/hilo.dart';
import 'package:inkboard/features/hilos/domain/models/portada_model.dart';
import 'package:inkboard/features/media/domain/models/picked_file.dart';
import 'package:http_parser/http_parser.dart';

class DioHilosRepository extends IHilosRepository {
  final Dio dio = GetIt.I.get();

  @override
  Future<Either<Failure, ComentariosHilo>> getComentarios(
    String hilo, {
    String? ultimoComentario,
  }) async {
    try {
      var response = await dio.get(
        "comentarios/hilo/$hilo",
        queryParameters: {"UltimoComentario": ultimoComentario},
      );

      if (response.isFailure) return Left(response.toFailure);

      Map<String, dynamic> data = response.data!["data"];

      return Right(
        ComentariosHilo(
          comentarios:
              List.from(
                data["comentarios"],
              ).map((d) => ComentarioModel.fromJson(d)).toList(),
          destacados:
              List.from(
                data["destacados"],
              ).map((d) => ComentarioModel.fromJson(d)).toList(),
        ),
      );
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, List<PortadaModel>>> getPortadas({
    String? ultimaPortada,
  }) async {
    try {
      var response = await dio.get(
        "hilos",
        queryParameters: {"UltimaPortada": ultimaPortada},
      );

      if (response.isFailure) return Left(response.toFailure);

      List<Map<String, dynamic>> data = List.from(response.data!["data"]);

      return Right(data.map((d) => PortadaModel.fromJson(d)).toList());
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, HiloModel>> getHilo(String hilo) async {
    try {
      var response = await dio.get("hilos/$hilo");

      if (response.isFailure) return Left(response.toFailure);

      Map<String, dynamic> data = response.data!["data"];

      return Right(HiloModel.fromJson(data));
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, Unit>> comentar(
    String hilo, {
    required String comentario,
    PickedFile? file,
  }) async {
    var form = FormData.fromMap({
      "texto": comentario,
      "file": file != null ? await MultipartFile.fromFile(file.source) : null,
    });

    try {
      var response = await dio.post(
        "comentarios/comentar-hilo/$hilo",
        data: form,
      );

      if (response.isFailure) return Left(response.toFailure);

      return Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, String>> postear({
    required String titulo,
    required String descripcion,
    required String subcategoria,
    required List<String> encuesta,
    required bool spoiler,
    required PickedFile portada,
    required bool dados,
    required bool idUnico,
  }) async {
    var form = FormData.fromMap({
      "titulo": titulo,
      "descripcion": descripcion,
      "subcategoria": subcategoria,
      "encuesta": encuesta,
      "spoiler": spoiler,
      "file": await MultipartFile.fromFile(
        portada.source,
        contentType: MediaType.parse(portada.contentType),
      ),
      "dados": dados,
      "idUnico": idUnico,
    });

    try {
      var response = await dio.post("hilos/postear", data: form);

      if (response.isFailure) return Left(response.toFailure);

      return Right(response.data["data"]);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, Unit>> establecerSticky(String hilo) async {
    try {
      var response = await dio.post("hilos/establecer-sticky/$hilo");

      if (response.isFailure) return Left(response.toFailure);

      return Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, Unit>> eliminarSticky(String hilo) async {
    try {
      var response = await dio.post("hilos/eliminar-sticky/$hilo");

      if (response.isFailure) return Left(response.toFailure);

      return Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, Unit>> eliminar(String hilo) async {
    try {
      var response = await dio.delete("hilos/eliminar/$hilo");

      if (response.isFailure) return Left(response.toFailure);

      return Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, Unit>> establecerFavorito(String hilo) async {
    try {
      var response = await dio.post(
        "hilos/colecciones/favaoritos/poner-en-favorito/$hilo",
      );

      if (response.isFailure) return Left(response.toFailure);

      return Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, Unit>> ocultar(String hilo) async {
    try {
      var response = await dio.post("hilos/colecciones/ocultos/ocultar/$hilo");

      if (response.isFailure) return Left(response.toFailure);

      return Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }

  @override
  Future<Either<Failure, Unit>> seguir(String hilo) async {
    try {
      var response = await dio.post("hilos/colecciones/seguidos/seguir/$hilo");

      if (response.isFailure) return Left(response.toFailure);

      return Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }
}
