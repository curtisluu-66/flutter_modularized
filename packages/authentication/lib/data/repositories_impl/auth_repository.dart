import 'package:authentication/domain/entities/users.dart';
import 'package:authentication/domain/repositories/auth_repository.dart';
import 'package:authentication/domain/responses/verify_user_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/constants/constants.dart';
import 'package:core/utils/logger/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';

final class FBAuthRepository implements AuthRepository {
  FBAuthRepository({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;

  final FirebaseFirestore _firebaseFirestore;

  bool? _kIsAdminApp;

  Future<bool> get isAdminApp async {
    try {
      if (_kIsAdminApp == null) {
        final packageInfo = await PackageInfo.fromPlatform();
        _kIsAdminApp = packageInfo.packageName == kAdminAppPackageName;
      }

      return _kIsAdminApp!;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<VerifyUserResponse?> verifyLoginCredentials({
    required User? user,
  }) async {
    if (user == null) return null;

    try {
      final matchedUser =
          await _firebaseFirestore.collection("user").doc(user.uid).get();

      if (matchedUser.exists && matchedUser.data() != null) {
        final verifiedUser = UserEntity.fromJson(matchedUser.data()!);

        final didUserMatchApp =
            await isAdminApp == (verifiedUser.role == UserRole.admin);

        return VerifyUserResponse(
          errorReason:
              didUserMatchApp ? null : VerifyUserFailedReason.incorrectApp,
          verifiedUser: didUserMatchApp ? verifiedUser : null,
        );
      } else {
        AppLogger.i("No user found in storage, log in failed");
        return VerifyUserResponse(
          errorReason: VerifyUserFailedReason.userNotFound,
          verifiedUser: null,
        );
      }
    } catch (error, stackTrace) {
      AppLogger.e("Error!", error, stackTrace);
      return VerifyUserResponse(
        errorReason: VerifyUserFailedReason.unknown,
        verifiedUser: null,
      );
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
