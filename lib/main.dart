import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_login/Screens/logout_screen.dart';
import 'package:my_login/Screens/signup_screen.dart';
import 'package:my_login/Screens/home_screen.dart';

import 'Screens/login_screen.dart';
import 'Screens/trip_detail.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wanderer',
      theme: ThemeData(
          primarySwatch: Colors.cyan,
      ),
      home:const LoginScreen(),
      initialRoute: '/',
      routes: {
        SignupScreen.routeName: (context) => const SignupScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        TripDetail.routeName: (context) => const TripDetail(), //esto registra la ruta de la pantalla TripDetail
        LogoutScreen.routeName: (context) => const LogoutScreen(),
      },
    );
  }
}
