import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../user_secure_storage.dart';

import 'dart:async';


//is used to edit the profile of a user
class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({Key? key, required this.userMapInit, required this.refreshParent,}) : super(key: key);
  final Map<String,dynamic> userMapInit;
  final Function() refreshParent;
  @override
  State<StatefulWidget> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {


  final formKey = GlobalKey<FormState>();
  String? loggedUsername;
  String? loggedUserEmail;
  Map<String, dynamic>? userMap;
  bool pass=false;

  //final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getLoggedUsernameAndEmail();
    userMap=widget.userMapInit;
  }


  Future<void> getLoggedUsernameAndEmail () async {
    loggedUsername = await UserSecureStorage.getUsername();
    loggedUserEmail = await UserSecureStorage.getUserEmail();
    print("persistent username = " +loggedUsername!+", persistent email = "+loggedUserEmail!);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
        child: ListView(children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(  //this could be in a different class
              children: [
                const Padding(padding: EdgeInsets.fromLTRB(0, 10, 00, 0),),
                Text('Edit Profile', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Form(
                  key: formKey,
                  child: Column(children: [
                    const Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0),),
                    TextFormField(
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                      initialValue: widget.userMapInit['username'],
                      decoration:
                      const InputDecoration(
                        hintText: 'Enter your new username',
                        labelText: 'Username*',
                      ),
                      onChanged: (value) {
                        userMap!['username']= value;
                      },
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 22, 0, 0),),
                    TextFormField(
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                      initialValue: widget.userMapInit['biography'],
                      decoration:
                      const InputDecoration(
                        hintText: 'Enter your new biography',
                        labelText: 'Biography*',
                      ),
                      minLines: 1,
                      maxLines: 20,
                      onChanged: (value) {
                       userMap!['biography'] = value;
                      },
                    ),


                    const Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          child: const Text("Cancel"),
                          onPressed: ()  {
                            //userMap=widget.userMapInit;

                            widget.refreshParent();
                            Navigator.of(context, rootNavigator: true).pop('dialog');

                            //Navigator.pushNamed(context, LogoutScreen.routeName);
                          },
                        ),
                        const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),),

                        ElevatedButton( //create/save button
                          child: const Text("Save"),
                          style: ElevatedButton.styleFrom(primary: Colors.green),
                          onPressed: ()  {
                            print(pass.toString() + ' 1');
                                save().then((value) {print(pass.toString() + ' 2'); if(pass) {//Navigator.pushNamed(context, LogoutScreen.routeName);
                                  widget.refreshParent();
                                  Navigator.of(context, rootNavigator: true).pop('dialog');
    }});
                          },
                        ),
                      ],
                    ),
                  ],),
                ),
              ],
            ),
          )
        ],)
    );
  }

  save() async{
    bool userExistence_aux = await doesUserExist(userMap!['username']);
    bool userExistence = userExistence_aux && (userMap!['username'] != loggedUsername);

    if(userMap!['username'] != '' && !userExistence && userMap!['biography'] !=''){
      var data = await FirebaseFirestore.instance.collection('trips').where('author_username', isEqualTo: loggedUsername).get();
    FirebaseFirestore.instance.collection('users').doc(widget.userMapInit['uid']).update({"username": userMap!['username'] });
    UserSecureStorage.setUsername(userMap!['username']);
    FirebaseFirestore.instance.collection('users').doc(widget.userMapInit['uid']).update({"biography": userMap!['biography'] });


    List results=data.docs;
    print(results);
    for(var doc in results) {
      print(userMap!['username']);
      var docData = doc.data() as Map<String, dynamic>;
      print(docData);
     FirebaseFirestore.instance.collection('trips').doc(docData['tid']).update({"author_username": userMap!['username'] });
    }
    setState(() {
      pass=true;
    });
    } else{
      setState(() {
        pass=false;
      });
      if(userMap!['username'] == '' || userMap!['biography'] == ''){
        Fluttertoast.showToast(msg: "Fill all the fields", timeInSecForIosWeb: 4, backgroundColor: Colors.red, textColor: Colors.white);

      } else{
        Fluttertoast.showToast(msg: 'Username already taken', timeInSecForIosWeb: 4, backgroundColor: Colors.red, textColor: Colors.white);

      }
    }

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


}