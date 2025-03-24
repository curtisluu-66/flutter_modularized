import 'package:admin_app/presentation/screens/auth/bloc/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication/presentation/login/sign_in_page.dart' as auth;
import 'package:get_it/get_it.dart';

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
          return auth.SignInPage(
            shouldDisplayRegisterActionSwitch: false,
            onSignedIn: _cubit.verifyUser,
            onUserCreated: (credential) {},
          );
        },
      ),
    );
  }
}
