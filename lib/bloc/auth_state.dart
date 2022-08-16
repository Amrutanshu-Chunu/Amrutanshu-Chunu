part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class SendOTPState extends AuthState {}

class VerifyOTPState extends AuthState {
  AppUser? user;
  VerifyOTPState({
    this.user,
  });
}

class LogoutState extends AuthState {}

class AuthenticatedState extends AuthState {
  User? user;
  AuthenticatedState({
    this.user,
  });
}

class UnAuthenticatedState extends AuthState {}
