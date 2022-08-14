import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:practice_firebase_testing/PhoneSignIn.dart';

import 'package:practice_firebase_testing/homeScreen.dart';

import 'bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //most important thing is to initialise firebase in project
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(),
        child: MaterialApp(
            title: 'TNS Health',
            theme: ThemeData(
              primarySwatch: Colors.red,
            ),
            debugShowCheckedModeBanner: false,
            home: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                return Container();
              },
            )));
  }
}





// StreamBuilder(
//               stream: context.read<AuthBloc>().add(AuthenticatedEvent()),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.active) {
//                   final user = snapshot.data;

//                   if (user == null) {
//                     return const PhoneSignIn();
//                   } else {
//                     return HomeScreen();
//                   }
//                 }
//                 return const CircularProgressIndicator();
//               }),
