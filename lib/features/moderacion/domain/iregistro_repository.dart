import 'package:dartz/dartz.dart';
import 'package:inkboard/features/core/domain/models/failure.dart';
import 'package:inkboard/features/moderacion/domain/models/registro.dart';

abstract class IRegistrosRepository {
  Future<Either<Failure,RegistroUsuario>> getRegistroUsuario(String id);
  Future<Either<Failure,List<HiloComentadoRegistro>>> getComentariosHistorial(String id, {
    String? ultimoComentario,
  });
  Future<Either<Failure,List<HiloPosteadoRegistro>>> getHilosHistorial(String id, {
    String? ultimoHilo,
  }); 
}