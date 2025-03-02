import 'package:get_it/get_it.dart';
import 'package:inkboard/features/auth/data/dio_auth_repository.dart';
import 'package:inkboard/features/auth/data/token_decoder.dart';
import 'package:inkboard/features/auth/data/token_secure_storage.dart';
import 'package:inkboard/features/auth/domain/iauth_repository.dart';
import 'package:inkboard/features/auth/domain/itoken_decoder.dart';
import 'package:inkboard/features/auth/domain/itoken_storage.dart';
import 'package:inkboard/features/auth/presentation/logic/controllers/auth_controller.dart';

import 'package:inkboard/features/core/presentation/utils/network/client.dart';
import 'package:inkboard/features/hilos/data/dio_hilos_repository.dart';
import 'package:inkboard/features/hilos/domain/ihilos_repository.dart';
import 'package:inkboard/features/media/data/file_picker_service.dart';
import 'package:inkboard/features/media/domain/ifile_picker_service.dart';
import 'package:inkboard/features/moderacion/data/dio_registro_repository.dart';
import 'package:inkboard/features/moderacion/domain/iregistro_repository.dart';


extension DependencyInjection on GetIt {
  GetIt addDependencies(){
    registerSingleton(httpClient);

    registerLazySingleton(() => AuthController());

    registerLazySingleton<IFilePickerService>(() => FilePickerService());

    registerSingleton<IRegistrosRepository>(DioRegistroRepository());
    registerSingleton<IAuthRepository>(DioAuthRepository());

    registerLazySingleton<ITokenStorage>(() => TokenSecureStorage());

    registerLazySingleton<ITokenDecoder>(() => TokenDecoder());

    registerSingleton<IHilosRepository>(DioHilosRepository());
    
    return this;
  }
}