import 'package:get_it/get_it.dart';
import 'package:inkboard/features/auth/data/dio_auth_repository.dart';
import 'package:inkboard/features/auth/data/token_decoder.dart';
import 'package:inkboard/features/auth/data/token_secure_storage.dart';
import 'package:inkboard/features/auth/domain/iauth_repository.dart';
import 'package:inkboard/features/auth/domain/itoken_decoder.dart';
import 'package:inkboard/features/auth/domain/itoken_storage.dart';
import 'package:inkboard/features/auth/presentation/logic/controllers/auth_controller.dart';
import 'package:inkboard/features/categorias/data/dio_categoria_repository.dart';
import 'package:inkboard/features/categorias/domain/icategorias_repository.dart';
import 'package:inkboard/features/comentarios/data/dio_comentarios_repository.dart';
import 'package:inkboard/features/comentarios/domain/icomentarios_repository.dart';

import 'package:inkboard/features/core/presentation/utils/network/client.dart';
import 'package:inkboard/features/encuestas/data/dio_encuesta_repository.dart';
import 'package:inkboard/features/encuestas/domain/iencuesta_repository.dart';
import 'package:inkboard/features/hilos/data/dio_hilos_repository.dart';
import 'package:inkboard/features/hilos/domain/ihilos_repository.dart';
import 'package:inkboard/features/media/data/file_picker_service.dart';
import 'package:inkboard/features/media/data/minatura_service.dart';
import 'package:inkboard/features/media/domain/ifile_picker_service.dart';
import 'package:inkboard/features/media/domain/iminiatura_service.dart';
import 'package:inkboard/features/moderacion/data/dio_baneos_repository.dart';
import 'package:inkboard/features/moderacion/data/dio_registro_repository.dart';
import 'package:inkboard/features/moderacion/domain/ibaneos_repository.dart';
import 'package:inkboard/features/moderacion/domain/iregistro_repository.dart';

extension DependencyInjection on GetIt {
  GetIt addDependencies() {
    registerLazySingleton(() => VideoCompressMiniaturaGenerador());
    registerLazySingleton(() => YoutubeMiniaturaService());
    registerLazySingleton(() => ImagenMiniaturaService());

    registerLazySingleton<IMiniaturaFactory>(() => GetItMiniaturaFactory());

    registerSingleton(httpClient);

    registerLazySingleton(() => AuthController());

    registerLazySingleton<IFilePickerService>(() => FilePickerService());

    registerSingleton<IRegistrosRepository>(DioRegistroRepository());
    registerSingleton<IAuthRepository>(DioAuthRepository());

    registerLazySingleton<ITokenStorage>(() => TokenSecureStorage());

    registerLazySingleton<ITokenDecoder>(() => TokenDecoder());

    registerLazySingleton<IBaneosRepository>(() => DioBaneosRepository());

    registerSingleton<IHilosRepository>(DioHilosRepository());

    registerSingleton<ICategoriasRepository>(DioCategoriaRepository());

    registerSingleton<IComentariosRepository>(DioComentariosRepository());

    registerSingleton<IEncuestaRepository>(DioEncuestaRepository());
    return this;
  }
}
