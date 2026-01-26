import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/cashier/presentation/cashier_page.dart';
import 'package:zeeppay/features/configuration/presentation/page/configuration_page.dart';
import 'package:zeeppay/features/configuration/presentation/page/logs_page.dart';
import 'package:zeeppay/features/home/presentation/pages/home_page.dart';
import 'package:zeeppay/features/invoice/presentation/pages/invoice_page.dart';
import 'package:zeeppay/features/login/presentation/pages/login_page.dart';
import 'package:zeeppay/features/payments/presentation/pages/payments_page.dart';
import 'package:zeeppay/features/profile/presentation/pages/profile_page.dart';
import 'package:zeeppay/features/splash/presentation/page/splash_page.dart';
import 'package:zeeppay/features/token_setup/presentation/pages/token_setup_page.dart';

class Routes {
  final GoRouter goRouter = GoRouter(
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (context, state) => SplashPage()),
      GoRoute(
        path: '/token-setup',
        builder: (context, state) => const TokenSetupPage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => LoginPage()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => ConfigurationPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => HomePage()),
      GoRoute(path: '/payments', builder: (context, state) => PaymentsPage()),
      GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),
      GoRoute(path: '/invoice', builder: (context, state) => InvoicePage()),
      GoRoute(path: '/logs', builder: (context, state) => const LogsPage()),
      GoRoute(
        path: '/cashier',
        builder: (context, state) => const CashierPage(),
      ),
    ],
  );
}
