import 'package:dartz/dartz.dart';
import 'package:inkboard/features/categorias/domain/models/categoria.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';

abstract class ICategoriasRepository {
  Future<Either<Failure, List<CategoriaModel>>> getCategories();
}
