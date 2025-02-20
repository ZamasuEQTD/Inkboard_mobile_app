import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/exception_extensions.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/response_extensions.dart';
import 'package:inkboard/features/hilos/domain/ihilos_repository.dart';
import 'package:inkboard/features/hilos/domain/models/comentario_model.dart';
import 'package:inkboard/features/hilos/domain/models/portada_model.dart';

class DioHilosRepository extends IHilosRepository {
  final Dio dio = GetIt.I.get();

  @override
  Future<Either<Failure, List<ComentarioModel>>> getComentarios(
    String hilo,
  ) async {
    throw new UnimplementedError();
  }

  @override
  Future<Either<Failure, List<PortadaModel>>> getPortadas({
    String? ultimaPortada
  }) async {
    try {
      var response = await dio.get("hilos", queryParameters:  {
        "UltimaPortada" : ultimaPortada
      });

      if (response.isFailure) return Left(response.toFailure);

      List<Map<String, dynamic>> data = List.from(response.data!["data"]);

      return Right(data.map((d) => PortadaModel.fromJson(d)).toList());
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }
}

class ApiResponse<T> {
  final T data;

  const ApiResponse({required this.data});
}
