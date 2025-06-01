import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeeppay/features/login/domain/repository/login_settings_store_repository.dart';
import 'package:zeeppay/features/login/domain/usecase/login_usecase.dart';
import 'package:zeeppay/features/login/presentation/bloc/login_bloc.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/theme/colors_app.dart';

final getIt = GetIt.instance;

void setupDependencies(SharedPreferences prefs) async {
  // Register Singleton and Abstractions
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerSingleton<Database>(Database(prefs));
  getIt.registerSingleton<ColorsApp>(ColorsApp());

  // Register Repositories (mais baixo nível)
  getIt.registerLazySingleton<LoginSettingsStoreRepository>(
    () => LoginSettingsRepositoryImpl(),
  );

  // Register Usecases (depende do repositório)
  getIt.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(getIt<LoginSettingsStoreRepository>()),
  );

  // Register Blocs (depende do Usecase)
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(loginUsecase: getIt<LoginUsecase>()),
  );

  getIt.registerFactory<PaymentsBloc>(() => PaymentsBloc());
}
