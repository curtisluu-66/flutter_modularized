import 'package:authentication/domain/entities/users.dart';

enum CreateUserFailedReason {
  incorrectApp,
  firebaseAuth,
  firebaseStorage,
  unknown
}

class CreateUserResponse {
  final CreateUserFailedReason? errorReason;
  final UserEntity? createdUser;

  CreateUserResponse({
    required this.errorReason,
    required this.createdUser,
  });
}
