import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeeppay/features/login/domain/repository/login_repository.dart';
import 'package:zeeppay/features/login/domain/usecase/login_usecase.dart';
import 'package:zeeppay/features/login/presentation/bloc/login_bloc.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/features/splash/domain/repository/splash_settings_store_repository.dart';
import 'package:zeeppay/features/splash/domain/usecase/splash_usecase.dart';
import 'package:zeeppay/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:zeeppay/shared/database/database.dart';

final getIt = GetIt.instance;

void setupDependencies(SharedPreferences prefs) async {
  // Register Singleton and Abstractions
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerSingleton<Database>(Database(prefs));

  // Register Repositories (mais baixo nível)
  getIt.registerLazySingleton<SplashSettingsStoreRepository>(
    () => SplashSettingsStoreRepositoryImpl(),
  );
  getIt.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl());

  // Register Usecases (depende do repositório)
  getIt.registerLazySingleton<SplashUsecase>(
    () => SplashUsecase(getIt<SplashSettingsStoreRepository>()),
  );
  getIt.registerLazySingleton<LoginUsecase>(
    () => LoginUsecaseImpl(getIt<LoginRepository>()),
  );

  // Register Blocs (depende do Usecase)
  getIt.registerFactory<SplashBloc>(
    () => SplashBloc(splashUsecase: getIt<SplashUsecase>()),
  );

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(loginUsecase: getIt<LoginUsecase>()),
  );

  getIt.registerFactory<PaymentsBloc>(() => PaymentsBloc());
}
