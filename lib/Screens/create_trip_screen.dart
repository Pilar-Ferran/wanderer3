import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateTripScreen extends StatefulWidget { //TODO stateless?
  const CreateTripScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {createTestTrip();}, child: const Text("create test trip"),);
  }

  //TODO does this go in this class? i think so
  Future<void> createTestTrip() {
    CollectionReference trips = firestore.collection('trips');

    return trips.add({
      'title': "Visiting El Raval",
      'preview_pic:':"lol",
      'location': "El Raval, Barcelona, Spain",
      'description':"this is a description about a trip to El Raval",
      'author_username': "FerranChiese"
    })  .then((value) => print("trip added to firestore"))
        .catchError((onError) => print("error adding to firestore. error = "+onError.toString()));
  }


}
