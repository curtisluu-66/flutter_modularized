import 'package:authentication/domain/entities/users.dart';
import 'package:authentication/domain/repositories/auth_repository.dart';
import 'package:authentication/domain/responses/create_user_response.dart';
import 'package:authentication/domain/responses/verify_user_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/constants/constants.dart';
import 'package:core/utils/logger/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

final class FBAuthRepository implements AuthRepository {
  FBAuthRepository({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;

  final FirebaseFirestore _firebaseFirestore;

  @override
  Future<VerifyUserResponse?> verifyLoginCredentials({
    required User? user,
  }) async {
    if (user == null) return null;

    try {
      final matchedUser = await _firebaseFirestore
          .collection(FirestoreConstants.kUserCollectionName)
          .doc(user.uid)
          .get();

      if (matchedUser.exists && matchedUser.data() != null) {
        final verifiedUser = UserEntity.fromJson(matchedUser.data()!);

        final didUserMatchApp =
            await kIsAdminApp == (verifiedUser.role == UserRole.admin);

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
  Future<CreateUserResponse?> createUser({
    required UserCredential? credential,
  }) async {
    if (await kIsAdminApp) {
      AppLogger.e("User cannot be created in admin app!");
      return CreateUserResponse(
        createdUser: null,
        errorReason: CreateUserFailedReason.incorrectApp,
      );
    }

    final user = credential?.user;
    final userEntity = AppUser(
      dob: Timestamp.fromDate(DateTime.now()),
      email: user?.email,
      fullName: user?.displayName,
      userId: user?.uid,
    );

    try {
      try {
        // Store user data in Firestore
        await FirebaseFirestore.instance
            .collection(FirestoreConstants.kUserCollectionName)
            .doc(user?.uid)
            .set(
              userEntity.toJson(),
            );

        return CreateUserResponse(
          errorReason: null,
          createdUser: userEntity,
        );
      } catch (firestoreError) {
        AppLogger.e("Error!", firestoreError);
        // Rollback registration when storage creation failed.
        await user?.delete();

        return CreateUserResponse(
          createdUser: null,
          errorReason: CreateUserFailedReason.firebaseStorage,
        );
      }
    } catch (authError) {
      AppLogger.e("Error!", authError);
      return CreateUserResponse(
        createdUser: null,
        errorReason: CreateUserFailedReason.firebaseAuth,
      );
    }
  }
}
