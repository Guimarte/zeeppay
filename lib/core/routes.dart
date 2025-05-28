import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/configuration/presentation/page/configuration_page.dart';
import 'package:zeeppay/features/payments/presentation/pages/payments_page.dart';

class Routes {
  final GoRouter goRouter = GoRouter(
    routes: <RouteBase>[
      //   GoRoute(path: '/', builder: (context, state) => LoginPage()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const ConfigurationPage(),
      ),
      //GoRoute(path: '/', builder: (contex, state) => const HomePage()),
      GoRoute(path: '/', builder: (contex, state) => PaymentsPage()),
    ],
  );
}
