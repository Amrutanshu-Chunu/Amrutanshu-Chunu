import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:practice_firebase_testing/api.dart';
import 'package:practice_firebase_testing/userModel.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  Future<AppUser?>? user;
  Stream<User?>? userdata;
  AuthBloc() : super(AuthInitial()) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    on<SendOTPEvent>((event, emit) =>
        {API().sendOTP(event.phoneNumber), emit(SendOTPState())});
    on<VerifyOTPEvent>((event, emit) =>
        {user = API().verifyOTP(event.otp), emit(VerifyOTPState(user: user))});
    on<LogoutEvent>((event, emit) => {API().logOut(), emit(LogoutState())});
    on<AuthenticatedEvent>((event, emit) => {
          userdata = API().authstateChanges(),
          if (userdata != null)
            {emit(AuthenticatedState())}
          else
            {emit(UnAuthenticatedState())}
        });
  }
}
