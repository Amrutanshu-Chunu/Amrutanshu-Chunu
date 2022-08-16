import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_firebase_testing/PhoneVerificationScreen.dart';

import 'package:practice_firebase_testing/bloc/auth_bloc.dart';

class PhoneSignIn extends StatefulWidget {
  const PhoneSignIn({Key? key}) : super(key: key);

  @override
  State<PhoneSignIn> createState() => _EmailSignInState();
}

class _EmailSignInState extends State<PhoneSignIn> {
  FirebaseAuth auth = FirebaseAuth.instance;

// firebase implementation

  final _formkey = GlobalKey<FormState>();
  final TextEditingController PhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    final uid = user?.uid;
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
                              RegExp regex = RegExp(r'^.{10}$');
                              if (value!.isEmpty) {
                                return ("Please enter Phone Number");
                              }
                              if (!regex.hasMatch(value) &&
                                  value.length != 10) {
                                return ("Enter 10 Digit Mobile Number");
                              }
                              return null;
                            },
                            autofocus: false,
                            controller: PhoneController,
                            keyboardType: TextInputType.phone,
                            onSaved: (value) {
                              value = PhoneController.text;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.phone),
                                contentPadding: const EdgeInsets.all(15),
                                hintText: 'Phone Number',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          ),

                          const SizedBox(height: 20),

                          // login button
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.blue,
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                String phoneNumber =
                                    "+91" + PhoneController.text;
                                context.read<AuthBloc>().add(
                                    SendOTPEvent(phoneNumber: phoneNumber));
                              }
                            },
                            // ignore: sort_child_properties_last
                            child: const Text(
                              'SignIn',
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
        if (state is SendOTPState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    VerificationScreen(phoneNumber: PhoneController.text),
              ));
        }
      },
    );
  }
}
