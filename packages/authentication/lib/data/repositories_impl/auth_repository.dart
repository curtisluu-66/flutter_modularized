import 'package:authentication/domain/entities/users.dart';
import 'package:authentication/domain/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/utils/logger/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

final class FBAuthRepository implements AuthRepository {
  const FBAuthRepository({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;

  final FirebaseFirestore _firebaseFirestore;

  @override
  Future<UserEntity?> verifyLoginCredentials({
    required User? user,
  }) async {
    if (user == null) return null;

    try {
      final matchedUser =
          await _firebaseFirestore.collection("user").doc(user.uid).get();

      if (matchedUser.exists && matchedUser.data() != null) {
        return UserEntity.fromJson(matchedUser.data()!);
      } else {
        AppLogger.i("No user found in storage, log in failed");
        return null;
      }
    } catch (error, stackTrace) {
      AppLogger.e("Error!", error, stackTrace);

      return null;
    }
  }

  @override
  Future<User?> signUp({
    required String email,
    required String password,
  }) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}
