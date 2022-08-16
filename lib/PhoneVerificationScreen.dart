import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_firebase_testing/api.dart';

import 'package:practice_firebase_testing/homeScreen.dart';
import 'package:practice_firebase_testing/signUp.dart';
import 'package:practice_firebase_testing/userModel.dart';

import 'bloc/auth_bloc.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key, required this.phoneNumber})
      : super(key: key);
  final String? phoneNumber;
  @override
  State<VerificationScreen> createState() => _EmailSignInState();
}

class _EmailSignInState extends State<VerificationScreen> {
// firebase implementation
  AppUser? user;

  final _formkey = GlobalKey<FormState>();
  final TextEditingController OtpController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //Phone Field
                          TextFormField(
                            validator: (value) {
                              RegExp regex = RegExp(r'^.{6}$');
                              if (value!.isEmpty) {
                                return ("Please enter OTP");
                              }
                              if (!regex.hasMatch(value) && value.length != 6) {
                                return ("Enter 6-Digit OTP");
                              }
                              return null;
                            },
                            autofocus: false,
                            controller: OtpController,
                            keyboardType: TextInputType.phone,
                            onSaved: (value) {
                              value = OtpController.text;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.phone),
                                contentPadding: const EdgeInsets.all(15),
                                hintText: 'Enter Your OTP',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          ),

                          const SizedBox(height: 20),

                          // Verify button
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.blue,
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                context.read<AuthBloc>().add(VerifyOTPEvent(
                                    otp: OtpController.text.trim()));
                              }
                            },
                            // ignore: sort_child_properties_last
                            child: const Text(
                              'Verify',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            padding: const EdgeInsets.all(8),
                            minWidth: MediaQuery.of(context).size.width,
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is VerifyOTPState) {
          // final db = FirebaseAuth.instance.currentUser;
          // String? uid = db?.uid;
          if (state.user?.name.toString() != null) {
            print('...VERIFICATION SCREEN....${state.user}............');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SignupPage(phoneNumber: widget.phoneNumber),
                ));
          }
        }
      },
    );
  }
}
