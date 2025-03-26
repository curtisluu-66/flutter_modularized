import 'dart:async';

import 'package:core/utils/logger/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:user_app/di/dependency_inject.dart';
import 'package:user_app/presentation/router/app_router.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await DependenciesInjector.instance.inject();

    runApp(const MyApp());
  }, (error, stack) {
    AppLogger.e("Error!", error, stack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MBox',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.routeConfigs,
    );
  }
}
