import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_login/Screens/logout_screen.dart';
import 'package:my_login/Screens/signup_screen.dart';
import 'package:my_login/Screens/home_screen.dart';
import 'package:my_login/Screens/spot_detail.dart';

import 'Screens/login_screen.dart';
import 'Screens/trip_detail.dart';
import 'Screens/user_detail.dart';
import 'logged_user_info.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    LoggedUserInfo userInfo = LoggedUserInfo();
    await userInfo.iniLoggedUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wanderer',
      theme: ThemeData(
          primarySwatch: Colors.cyan,
        cardColor: Colors.deepOrangeAccent, /*Color.fromRGBO(255, 170, 0, 0.5)*/ //the light orange
      ),
      //TODO: cuando hagamos datos persistentes en el dispositivo, uno será el estado de login. Aquí habria que comprobar si logged in y poner home en HomeScreen
      home:LoginScreen(),
      initialRoute: '/',
      routes: {
        SignupScreen.routeName: (context) => const SignupScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        TripDetail.routeName: (context) => const TripDetail(), //esto registra la ruta de la pantalla TripDetail
        SpotDetail.routeName: (context) => const SpotDetail(),
        LogoutScreen.routeName: (context) => const LogoutScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        UserDetail.routeName: (context) => const UserDetail(),
      },
    );
  }

}
