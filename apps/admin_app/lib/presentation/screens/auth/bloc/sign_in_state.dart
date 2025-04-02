part of 'sign_in_bloc.dart';

abstract class SignInState {}

class SignInInitialState extends SignInState {}

class SignInSuccess extends SignInState {}

class SignInFailed extends SignInState {}
