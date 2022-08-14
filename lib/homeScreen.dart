import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_firebase_testing/PhoneSignIn.dart';
import 'package:practice_firebase_testing/api.dart';

import 'bloc/auth_bloc.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            LogoutEvent(),
                          );
                    },
                    child: const Text('LogOut'),
                  ),
                  const Icon(Icons.location_on)
                ],
              );
            }, listener: (context, state) {
              if (state is LogoutState) {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhoneSignIn(),
                    ));
              }
            })),
      ),
    );
  }
}
