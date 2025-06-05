import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/configuration/presentation/page/configuration_page.dart';
import 'package:zeeppay/features/home/presentation/pages/home_page.dart';
import 'package:zeeppay/features/login/presentation/pages/login_page.dart';
import 'package:zeeppay/features/payments/presentation/pages/payments_page.dart';
import 'package:zeeppay/features/profile/presentation/pages/profile_page.dart';
import 'package:zeeppay/features/splash/presentation/page/splash_page.dart';

class Routes {
  final GoRouter goRouter = GoRouter(
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (context, state) => SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => LoginPage()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => ConfigurationPage(),
      ),
      GoRoute(path: '/home', builder: (contex, state) => const HomePage()),
      GoRoute(path: '/payments', builder: (contex, state) => PaymentsPage()),
      GoRoute(path: '/profile', builder: (contex, state) => (ProfilePage())),
    ],
  );
}
