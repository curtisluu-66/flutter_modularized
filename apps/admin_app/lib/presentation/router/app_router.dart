import 'package:admin_app/presentation/screens/auth/sign_in_page.dart';
import 'package:admin_app/presentation/screens/home/home_page.dart';
import 'package:feature_movie/presentation/router.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  AppRoutes._();

  static const signIn = '/';
  static const home = '/home';
}

class AppRouter {
  static GoRouter get routeConfigs => _routeConfigs;

  static final _routeConfigs = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      ...FeatureMovieRouter.adminFeatureRoutes,
    ],
  );
}
