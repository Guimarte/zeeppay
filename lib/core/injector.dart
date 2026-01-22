import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeeppay/features/home/domain/repository/home_repository.dart';
import 'package:zeeppay/features/home/domain/usecase/home_usecase.dart';
import 'package:zeeppay/features/invoice/domain/repository/invoice_repository.dart';
import 'package:zeeppay/features/invoice/domain/usecase/invoice_usecase.dart';
import 'package:zeeppay/features/login/domain/repository/login_repository.dart';
import 'package:zeeppay/features/login/domain/usecase/login_usecase.dart';
import 'package:zeeppay/features/login/presentation/bloc/login_bloc.dart';
import 'package:zeeppay/features/payments/domain/repository/payments_repository.dart';
import 'package:zeeppay/features/payments/domain/repository/printer_receive_repository.dart';
import 'package:zeeppay/features/payments/domain/usecase/payments_usecase.dart';
import 'package:zeeppay/features/payments/domain/usecase/printer_receive_usecase.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/features/profile/domain/repository/profile_repository.dart';
import 'package:zeeppay/features/profile/domain/usecase/profile_usecase.dart';
import 'package:zeeppay/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zeeppay/features/splash/domain/repository/splash_devices_repository.dart';
import 'package:zeeppay/features/splash/domain/repository/splash_ercards_repository.dart';
import 'package:zeeppay/features/splash/domain/repository/splash_store_repository.dart';
import 'package:zeeppay/features/splash/domain/repository/splash_theme_repository.dart';
import 'package:zeeppay/features/splash/domain/usecase/splash_usecase.dart';
import 'package:zeeppay/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:zeeppay/features/invoice/presentation/bloc/invoice_bloc.dart';
import 'package:zeeppay/features/cashier/data/repositories/cashier_repository_impl.dart';
import 'package:zeeppay/features/cashier/domain/repositories/cashier_repository.dart'
    hide CashierRepositoryImpl;
import 'package:zeeppay/features/cashier/domain/usecases/cashier_usecase.dart';
import 'package:zeeppay/features/cashier/presentation/bloc/cashier_bloc.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/models/sell_model.dart';
import 'package:zeeppay/theme/colors_app.dart';

final getIt = GetIt.instance;

void setupDependencies(SharedPreferences prefs) async {
  // Register Singleton and Abstractions
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerSingleton<Database>(Database(prefs));
  getIt.registerSingleton<ColorsApp>(ColorsApp());

  // SellModel como Factory - cada transação deve ter sua própria instância
  // FIX: Evita que dados de uma transação contaminem a próxima
  getIt.registerFactory<SellModel>(() => SellModel());

  // Register Repositories (mais baixo nível)
  getIt.registerLazySingleton<SplashStoreRepository>(
    () => SplashStoreRepositoryImpl(),
  );
  getIt.registerLazySingleton<SplashERCardsRepository>(
    () => SplashERCardsRepositoryImpl(),
  );
  getIt.registerLazySingleton<SplashThemeRepository>(
    () => SplashThemeRepositoryImpl(),
  );
  getIt.registerLazySingleton<SplashDevicesRepository>(
    () => SplashDevicesRepositoryImpl(),
  );

  getIt.registerLazySingleton<PaymentsRepository>(
    () => PaymentsRepositoryImpl(),
  );

  getIt.registerLazySingleton<PrinterReceiveRepository>(
    () => PrinterReceiveRepositoryImpl(),
  );

  getIt.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl());

  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());

  getIt.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl());

  getIt.registerLazySingleton<InvoiceRepository>(() => InvoiceRepositoryImpl());

  getIt.registerLazySingleton<CashierRepository>(() => CashierRepositoryImpl());

  // Register Usecases (depende do repositório)
  getIt.registerLazySingleton<SplashUsecase>(
    () => SplashUsecase(
      getIt<SplashStoreRepository>(),
      getIt<SplashERCardsRepository>(),
      getIt<SplashThemeRepository>(),
      getIt<SplashDevicesRepository>(),
    ),
  );
  getIt.registerLazySingleton<LoginUsecase>(
    () => LoginUsecaseImpl(getIt<LoginRepository>()),
  );
  getIt.registerLazySingleton<ProfileUsecase>(
    () => ProfileUsecaseImpl(getIt<ProfileRepository>()),
  );

  getIt.registerLazySingleton<PaymentsUsecase>(
    () => PaymentsUsecaseImpl(paymentsRepository: getIt<PaymentsRepository>()),
  );

  getIt.registerLazySingleton<PrinterReceiveUseCase>(
    () => PrinterReceiveUseCaseImpl(
      printerReceiveRepository: getIt<PrinterReceiveRepository>(),
    ),
  );

  getIt.registerLazySingleton<HomeUsecase>(
    () => HomeUsecaseImpl(getIt<HomeRepository>()),
  );

  getIt.registerLazySingleton<InvoiceUsecase>(
    () => InvoiceUsecaseImpl(getIt<InvoiceRepository>()),
  );

  getIt.registerLazySingleton<CashierUsecase>(
    () => CashierUsecaseImpl(getIt<CashierRepository>()),
  );

  // Register Blocs (depende do Usecase)
  getIt.registerFactory<SplashBloc>(
    () => SplashBloc(splashUsecase: getIt<SplashUsecase>()),
  );

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(loginUsecase: getIt<LoginUsecase>()),
  );

  getIt.registerFactory<PaymentsBloc>(
    () => PaymentsBloc(
      paymentsUsecase: getIt<PaymentsUsecase>(),
      printerReceiveUseCase: getIt<PrinterReceiveUseCase>(),
    ),
  );

  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(profileUsecase: getIt<ProfileUsecase>()),
  );

  getIt.registerFactory<InvoiceBloc>(
    () => InvoiceBloc(invoiceUsecase: getIt<InvoiceUsecase>()),
  );

  getIt.registerFactory<CashierBloc>(
    () => CashierBloc(cashierUsecase: getIt<CashierUsecase>()),
  );
}
