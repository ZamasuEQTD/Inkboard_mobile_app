import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:inkboard/features/categorias/domain/icategorias_repository.dart';
import 'package:inkboard/features/categorias/domain/models/categoria.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/exception_extensions.dart';
import 'package:inkboard/features/core/presentation/utils/network/extensions/response_extensions.dart';

class DioCategoriaRepository extends ICategoriasRepository {
  final Dio dio = GetIt.I.get();
  @override
  Future<Either<Failure, List<CategoriaModel>>> getCategories() async {
    try {
      var response = await dio.get("categorias");

      if (response.isFailure) return Left(response.toFailure);

      return Right(
        (response.data!["data"] as List)
            .map((categoria) => CategoriaModel.fromJson(categoria))
            .toList(),
      );
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }
}
