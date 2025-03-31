import 'package:authentication/domain/entities/users.dart';

enum VerifyUserFailedReason { incorrectApp, userNotFound, unknown }

class VerifyUserResponse {
  final VerifyUserFailedReason? errorReason;
  final UserEntity? verifiedUser;

  VerifyUserResponse({
    required this.errorReason,
    required this.verifiedUser,
  });
}
