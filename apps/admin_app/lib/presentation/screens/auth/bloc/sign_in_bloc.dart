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
      AppLogger.i("Logged in, user role: ${userEntity.role}");
    } else {
      AppLogger.i("Log in failed");
    }
  }
}
