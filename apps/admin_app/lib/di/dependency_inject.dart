import 'package:authentication/data/repositories_impl/auth_repository.dart';
import 'package:authentication/domain/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

class DependenciesInjector {
  DependenciesInjector._private();
  static DependenciesInjector? _instance;

  static DependenciesInjector get instance {
    _instance ??= DependenciesInjector._private();
    return _instance!;
  }

  static final _dl = GetIt.instance;

  Future<void> inject() async {
    await Firebase.initializeApp();

    _dl.registerLazySingleton<AuthRepository>(
      () => FBAuthRepository(
        firebaseFirestore: FirebaseFirestore.instance,
      ),
    );
  }
}
