import 'package:authentication/domain/responses/verify_user_response.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<VerifyUserResponse?> verifyLoginCredentials({
    required User? user,
  });

  Future<User?> signUp({
    required String email,
    required String password,
  });
}
