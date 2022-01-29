import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_login/Screens/login_screen.dart';
import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_login/user_secure_storage.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup_screen';
  const SignupScreen({Key? key}) : super(key: key);
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignupScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool loading = false;
  String wrongregistration="Registration failed";


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
        child: Column(
          children: [
            SizedBox(
              height: size.height / 7,
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
                      height: size.height / 30,
                    ),
                    SizedBox(
                      width: size.width / 1.1,
                      child: Text(
                        "Create Account to Continue",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: size.height / 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: field(
                            size, "username", Icons.account_box, _username),
                      ),
                    ),
                    Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: field(size, "email", Icons.account_box, _email),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: field(size, "password", Icons.lock, _password),
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
                              context, HomeScreen.routeName),
                      child: const Text(
                        "Login",
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
        ),
      ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_username.text.isNotEmpty &&
            _email.text.isNotEmpty &&
            _password.text.isNotEmpty) {
          setState(() {
            loading = true;
          });

          createAccount(_username.text, _email.text, _password.text).then((
              user) {
            if (user != null) {
              setState(() {
                loading = false;
              });
              UserSecureStorage.setUserEmail(_email.text);
              UserSecureStorage.setUsername(_username.text);
              Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, (_) => false);
              Fluttertoast.showToast(msg: "Account created successfully");
            } else {
              print("Registration Failed");
              setState(() {
                loading = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(wrongregistration, style: const TextStyle(
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
          print("Enter name, email and password");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Complete all the fields', style: TextStyle(
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
            "Create Account",
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


  Future<bool> doesUserExist(String currentUserName) async {
    var data = await FirebaseFirestore.instance.collection("users").where(
        "username", isEqualTo: currentUserName).get();
    List results = data.docs;
    if (results.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<User?> createAccount(String username, String email,
      String password) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    FirebaseFirestore _firestore = FirebaseFirestore.instance;


    bool userExistence = await doesUserExist(username);
    if(userExistence){
      setState(() {
        wrongregistration="Username already taken";
      });
    }

    if (userExistence != null && !userExistence) {
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(
            email: email, password: password);

        print("Account created successfully");

        userCredential.user!.updateDisplayName(username);

        await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
          "username": username,
          "email": email,
          "biography": "Write here your biography",
          "followers": 0,
          "following": 0,
          "list_followers": [],
          "list_following": [],
          "profile_picture": "users/user_profile_standard.png",
          "uid": _auth.currentUser!.uid,
        });

        return userCredential.user;
      } catch (e) {
        print(e);
        return null;
      }
    }
  }

}

