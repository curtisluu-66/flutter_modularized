import 'package:go_router/go_router.dart';
import 'package:user_app/presentation/screens/auth/sign_in_page.dart';

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
