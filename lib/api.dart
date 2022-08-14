import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice_firebase_testing/userModel.dart';

String _verificationId = '';
AppUser? user;
String? uid;
String otpInput = '';

class API {
  final FirebaseAuth _auth = FirebaseAuth.instance;
//SendOtp
  void sendOTP(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await _auth.signInWithCredential(credential);
        } catch (e) {
          print('8888888888$e');
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: otpInput);
        _verificationId = verificationId;

        // Sign the user in (or link) with the credential
        try {
          await _auth.signInWithCredential(credential);
        } catch (e) {
          print('...................verifii$e..............');
        }
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  }

//  Verify Otp
  Future<AppUser?> verifyOTP(String otp) async {
    otpInput = otp;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: otp);
    try {
      await _auth
          .signInWithCredential(credential)
          .then((value) => uid = value.user?.uid);

      CollectionReference usercollection =
          FirebaseFirestore.instance.collection('users');

      final userData = usercollection
          .where("uid", isEqualTo: uid = uid.toString())
          .get()
          .then(
        (querySnapshot) {
          final userData =
              querySnapshot.docs.first.data() as Map<String, dynamic>;
          user = AppUser.fromMap(userData);
          // _loggedInUser = user;
          return user;
        },
      );
      uid;
    } catch (e) {
      print('..........verify $e................');
    }
    return user;
  }

  AppUser? userdetails() {
    return user;
  }

// LogOut
  void logOut() async {
    await _auth.signOut();
  }

  // SignUp
  signUp(AppUser _appUser) async {
    try {
      FirebaseFirestore.instance.collection('users').doc(_appUser.userId).set(
        {
          'uid': uid.toString(),
          'userId': _appUser.userId,
          'name': _appUser.name,
          'email': _appUser.email,
          'phoneNumber': _appUser.phoneNumber
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'Phone Number-already-in-use') {
        return 'Email already is in use';
        // return null;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return null;
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return UserCredential;
  }

  // Authstate changes keep loggedIn
  Stream<User?>? authstateChanges() {
    Stream<User?> authState = FirebaseAuth.instance.authStateChanges();
    return authState;
  }
}
