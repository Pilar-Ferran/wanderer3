import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CreateTripScreen extends StatefulWidget { //TODO stateless?
  const CreateTripScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {createTestTripAndPic();},child: const Text("create test trip"),);
  }

  Future<void> createTestTripAndPic() async{
    String filePathInDevice ="";  //TODO lo obtendremos por image_picker (ya tenemos la dependencia)
    String filePathInFirebase = "users/ferranib00@gmail.com/trip1/macbasmol.png";

                                                  //Directory appDocDir = await getApplicationDocumentsDirectory();
                                                  //filePathInDevice = '${appDocDir.absolute}/file-to-upload.png'; //  r'D:\Ferran\Documents\1.Documents\1.Universitat\Q7 coses a BCN\Apps'

    //TODO do not remove
    //we find the picture in the device
    //File file = File(filePathInDevice);
    //and upload it
    //await firebase_storage.FirebaseStorage.instance.ref(filePathInFirebase).putFile(file);

    //we create the rest of the trip with a reference to the pic
    createTestTrip(filePathInFirebase);
  }

  //TODO does this go in this class? i think so
  Future<void> createTestTrip(String previewPicFirebasePath) {
    //and we create the trip
    CollectionReference trips = firestore.collection('trips');

    /*return*/Future<void> tripAddFuture = trips.add({
      'author_username': "FerranChiese",
      'title': "Visiting El Raval",
      'location': "El Raval, Barcelona, Spain",
      'description':"this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval ",
      'preview_pic': previewPicFirebasePath,
      /*'spots': [  //TODO así no funciona. asi lo crea como objeto json (aka map en Firebase) dentro del documento. hay q crear otro doc
        {
          'spot_name': "MACBA Plaza",
          'spot_description': "aaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa ",
          'spot_soundtrack': "469rBLYJUZHMJLtq2Wch3h",
          'pictures': [
            "land1.jpg",
            "land2.jpg",
            "land1.jpg",
            "land2.jpg"
          ]
        }
        ]*/

    })
        .then((value) => confirmTripAdded())
        .catchError((onError) => informAddTripError(onError));

    return tripAddFuture;
  }

  void confirmTripAdded() {
    print("trip added to firestore");
    Fluttertoast.showToast(msg: "Trip posted successfully!");
  }

  void informAddTripError(onError) {
    print("error adding to firestore. error = "+onError.toString());
    Fluttertoast.showToast(msg: "There was an error creating the trip.");
  }
}
