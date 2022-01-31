import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_login/Screens/login_screen.dart';
import '../user_secure_storage.dart';
import 'dart:async';


//is used to edit the profile of a user
class LogoutDialog extends StatefulWidget {
  const LogoutDialog({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;




  String? loggedUsername;
  String? loggedUserEmail;

  //final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getLoggedUsernameAndEmail();
  }


  Future<void> getLoggedUsernameAndEmail () async {
    loggedUsername = await UserSecureStorage.getUsername();
    loggedUserEmail = await UserSecureStorage.getUserEmail();
    print("persistent username = " +loggedUsername!+", persistent email = "+loggedUserEmail!);
  }

Future<void> setLoggedUsernameAndEmail () async {
  await UserSecureStorage.setUsername(null);
  await UserSecureStorage.setUserEmail(null);
  print("persistent username = " +loggedUsername!+", persistent email = "+loggedUserEmail!);
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return Dialog(
        child:
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column( //this could be in a different class
              children: [
                 Text('Wanderer', style: TextStyle(color: Colors.cyan.shade700, fontSize: 25, fontWeight: FontWeight.w800),),
                const Padding(padding: EdgeInsets.fromLTRB(0, 8, 00, 0),),
                Text('Programmer: Ferran Iglesias', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),),
                Text('Programmer: Pilar Lopez', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),),
                const Padding(padding: EdgeInsets.fromLTRB(0, 15, 00, 0),),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red) ,
                      onPressed: () {
                        _signOut();
                        Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
                      },
                      child: Text('Log out', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),),
                    ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 20, 00, 0),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          child: const Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop(
                                'dialog');
                            //Navigator.pushNamed(context, LogoutScreen.routeName);
                          },
                        ),

                      ],
                    ),
                  ],
              mainAxisSize: MainAxisSize.min,),
                ),

        );
  }

_signOut() async {
      await setLoggedUsernameAndEmail();
      await _firebaseAuth.signOut();

  }


}