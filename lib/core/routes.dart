import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/features/configuration/presentation/page/configuration_page.dart';
import 'package:zeeppay/features/login/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:zeeppay/features/login/presentation/pages/login_page.dart';

class Routes {
  final GoRouter goRouter = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => getIt<LoginBloc>(),
            child: LoginPage(),
          );
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) {
          return const ConfigurationPage();
        },
      ),
    ],
  );
}
