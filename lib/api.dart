import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:practice_firebase_testing/userModel.dart';

String _verificationId = '';

String otpInput = '';

class API {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AppUser? user, _loggedInUser;
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
      timeout: const Duration(seconds: 5),
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  }

//  Verify Otp
  Future<AppUser?> verifyOTP(String otp) async {
    otpInput = otp;
    AppUser? user;
    UserCredential userCredential;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: otp);
    // try {
    userCredential =
        await _auth.signInWithCredential(credential).then((uid) => uid);

    CollectionReference usercollection =
        FirebaseFirestore.instance.collection('users');

    final db = usercollection
        .where("uid", isEqualTo: userCredential.user?.uid)
        .get()
        .then(
      (querySnapshot) async {
        final userData =
            await querySnapshot.docs.first.data() as Map<String, dynamic>;
        user = AppUser.fromMap(userData);
        _loggedInUser = user;
        print('........API..........$user');
        return user;
      },
    );
    return user;
    print('?????$user');
  }

// LogOut
  void logOut() async {
    await _auth.signOut();
  }

  // SignUp
  signUp(AppUser _appUser) async {
    try {
      final userdata = FirebaseAuth.instance.currentUser;
      final uid = userdata?.uid.toString();
      FirebaseFirestore.instance.collection('users').doc(_appUser.userId).set(
        {
          'uid': uid,
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

  // get user
  Future getAppUserFromUid(String uid) async {
    String? _loggedInUser;

    CollectionReference db = FirebaseFirestore.instance.collection('users');
    final user = db.where("uid", isEqualTo: uid).get().then(
      (DocumentSnapshot) {
        final userData =
            DocumentSnapshot.docs.first.data() as Map<String, dynamic>;
        final user = AppUser.fromMap(userData).name.toString();
        _loggedInUser = user;
        return _loggedInUser;
      },
    );
    // return _loggedInUser.toString();
  }
}
