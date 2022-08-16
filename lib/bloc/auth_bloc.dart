import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:practice_firebase_testing/api.dart';
import 'package:practice_firebase_testing/userModel.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AppUser? userss;
  // User? currentUser;
  // FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    // currentUser = _auth.currentUser;
    on<SendOTPEvent>((event, emit) =>
        {API().sendOTP(event.phoneNumber), emit(SendOTPState())});
    on<VerifyOTPEvent>((event, emit) async => {
          userss = await API().verifyOTP(event.otp),
          emit(VerifyOTPState(user: userss))
        });
    on<LogoutEvent>((event, emit) => {API().logOut(), emit(LogoutState())});
  }
}
