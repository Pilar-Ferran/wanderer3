import 'package:my_login/user_secure_storage.dart';

import 'signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login_screen';
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool loading = false;
  Map<String, dynamic>? userMap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: loading
          ? Center(
        child: SizedBox(
          height: size.height / 20,
          width: size.height / 20,
          child: const CircularProgressIndicator(),
        ),
      )
          : Container(
          constraints: BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/ff97d9.png'),
              fit: BoxFit.cover,
            ),
          ),
          child:
          Column(
            children: [
              SizedBox(
                height: size.height / 5,
              ),
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/white.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height / 20,
                      ),
                      SizedBox(
                        width: size.width / 1.1,
                        child: const Text(
                          "Wanderer",
                          style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: size.height / 15,
                      ),
                      Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: field(size, "Email", Icons.account_box, _email),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Container(
                          width: size.width,
                          alignment: Alignment.center,
                          child: field(size, "Password", Icons.lock, _password),
                        ),
                      ),
                      SizedBox(
                        height: size.height / 40,
                      ),
                      customButton(size),
                      SizedBox(
                        height: size.height / 40,
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(
                                context, SignupScreen.routeName),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(
                            color: Colors.cyan,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height / 20,
                      ),
                    ],
                  ),
                ),
              ),

            ],
          )
      ),
      //),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        usernameFromEmail(_email.text);
        if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
          setState(() {
            loading = true;
          });

          logIn(_email.text, _password.text).then((user) {
            if (user != null) {
              print("Login Successful");

              UserSecureStorage.setUsername(userMap!['username']);
              UserSecureStorage.setUserEmail(_email.text);
              /*setState(() {
                loading = false;
              });*/

              Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, (_) => false);
            } else {
              print("Incorrect Email or Password");
              setState(() {
                loading = false;
              });


              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Incorrect Email or Password', style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),),
                  backgroundColor: Colors.red,
                  action: SnackBarAction(label: 'Try again',
                      textColor: Colors.white,
                      onPressed: ScaffoldMessenger
                          .of(context)
                          .hideCurrentSnackBar),
                ),
              );
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Complete the fields', style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),),
              backgroundColor: Colors.cyan,
              action: SnackBarAction(label: 'Try again',
                  textColor: Colors.white,
                  onPressed: ScaffoldMessenger
                      .of(context)
                      .hideCurrentSnackBar),
            ),
          );
          print("Complete the fields email and password");
        }
      },
      child: Container(
          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.cyan,
          ),
          alignment: Alignment.center,
          child: const Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

  Widget field(Size size, String hintText, IconData icon,
      TextEditingController cont) {
    return SizedBox(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        controller: cont,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }


  void usernameFromEmail(String email) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection('users')
        .where("email", isEqualTo: email)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
      });
    }).onError((error, stackTrace) {
      setState(() {
        userMap = null;
      });
    });
  }

  Future<User?> logIn(String email, String password) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      print("Login Sucessfull");
      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) =>
          userCredential.user!.updateDisplayName(value['username']));

      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
