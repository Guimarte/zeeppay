import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeeppay/features/login/presentation/bloc/login_bloc.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/theme/colors_app.dart';

final getIt = GetIt.instance;

void setupDependencies(SharedPreferences prefs) async {
  // RegisterBloc
  getIt.registerFactory<LoginBloc>(() => LoginBloc());
  getIt.registerFactory<PaymentsBloc>(() => PaymentsBloc());

  // Register Singleton and Abstractions
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerSingleton<Database>(Database(prefs));
  getIt.registerSingleton<ColorsApp>(ColorsApp());
}
