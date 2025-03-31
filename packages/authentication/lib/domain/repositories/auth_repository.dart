import 'package:authentication/domain/responses/create_user_response.dart';
import 'package:authentication/domain/responses/verify_user_response.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<VerifyUserResponse?> verifyLoginCredentials({
    required User? user,
  });

  Future<CreateUserResponse?> createUser({
    required UserCredential? credential,
  });
}
