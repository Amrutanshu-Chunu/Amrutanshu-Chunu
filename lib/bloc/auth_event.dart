part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class SendOTPEvent extends AuthEvent {
  String phoneNumber;
  SendOTPEvent({
    required this.phoneNumber,
  });
}

class VerifyOTPEvent extends AuthEvent {
  String otp;
  VerifyOTPEvent({
    required this.otp,
  });
}

class LogoutEvent extends AuthEvent {}

class AuthenticatedEvent extends AuthEvent {}

class UnAuthenticatedEvent extends AuthEvent {}
