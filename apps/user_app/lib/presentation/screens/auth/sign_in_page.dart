import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication/presentation/login/sign_in_page.dart';
import 'package:get_it/get_it.dart';
import 'package:user_app/presentation/screens/auth/bloc/sign_in_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final _cubit = SignInCubit(
    authRepository: GetIt.I.get(),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Builder(
        builder: (context) {
          return AuthScreen(
            shouldDisplayRegisterActionSwitch: true,
            onSignedIn: _cubit.verifyUser,
            onUserCreated: (credential) {
              _cubit.createUser(credential);
            },
          );
        },
      ),
    );
  }
}
