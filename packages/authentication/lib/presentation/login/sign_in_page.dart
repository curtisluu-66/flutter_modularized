import 'package:firebase_auth/firebase_auth.dart'
    hide AuthProvider, EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({
    super.key,
    this.shouldDisplayRegisterActionSwitch = true,
    this.onUserCreated,
    this.onSignedIn,
  });

  final bool shouldDisplayRegisterActionSwitch;
  final void Function(UserCredential credential)? onUserCreated;
  final void Function(User?)? onSignedIn;

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [
        EmailAuthProvider(),
      ],
      showAuthActionSwitch: shouldDisplayRegisterActionSwitch,
      actions: [
        AuthStateChangeAction<UserCreated>((context, state) {
          // Put any new user logic here
          onUserCreated?.call(state.credential);
        }),
        AuthStateChangeAction<SignedIn>((context, state) {
          onSignedIn?.call(state.user);
        }),
      ],
    );
  }
}
