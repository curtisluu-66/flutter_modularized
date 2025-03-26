import 'package:authentication/domain/entities/users.dart';
import 'package:authentication/domain/repositories/auth_repository.dart';
import 'package:core/utils/logger/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(SignInState());

  final AuthRepository _authRepository;

  Future<void> verifyUser(
    User? user,
  ) async {
    final userEntity = await _authRepository.verifyLoginCredentials(
      user: user,
    );

    if (userEntity != null) {
      if (userEntity.role == UserRole.user) {
        AppLogger.i("You are using the correct app!");
      } else {
        AppLogger.e("Wrong app!");
      }
    } else {
      AppLogger.i("Log in failed");
    }
  }
}
