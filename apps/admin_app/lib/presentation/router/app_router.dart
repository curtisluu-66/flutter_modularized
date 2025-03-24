import 'package:admin_app/presentation/screens/auth/sign_in_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter get routeConfigs => _routeConfigs;

  static final _routeConfigs = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SignInPage(),
      ),
    ],
  );
}
