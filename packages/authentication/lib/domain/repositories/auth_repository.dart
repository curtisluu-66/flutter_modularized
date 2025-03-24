import 'package:authentication/domain/entities/users.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserEntity?> verifyLoginCredentials({
    required User? user,
  });

  Future<User?> signUp({
    required String email,
    required String password,
  });
}
