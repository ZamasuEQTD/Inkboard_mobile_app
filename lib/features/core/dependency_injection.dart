import 'package:get_it/get_it.dart';
import 'package:inkboard/features/auth/data/token_decoder.dart';
import 'package:inkboard/features/auth/data/token_secure_storage.dart';
import 'package:inkboard/features/auth/domain/itoken_decoder.dart';
import 'package:inkboard/features/auth/domain/itoken_storage.dart';

import 'package:inkboard/features/core/presentation/utils/network/client.dart';
import 'package:inkboard/features/hilos/data/dio_hilos_repository.dart';
import 'package:inkboard/features/hilos/domain/ihilos_repository.dart';


extension DependencyInjection on GetIt {
  GetIt addDependencies(){
    registerSingleton(httpClient);

    registerLazySingleton<ITokenStorage>(() => TokenSecureStorage());

    registerLazySingleton<ITokenDecoder>(() => TokenDecoder());

    registerSingleton<IHilosRepository>(DioHilosRepository());
    
    return this;
  }
}