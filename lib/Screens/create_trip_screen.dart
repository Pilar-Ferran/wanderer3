import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_login/Component/create_spot_preview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CreateTripScreen extends StatefulWidget { //TODO stateless?
  const CreateTripScreen({Key? key}) : super(key: key);

  final String title = "Create a trip";

  @override
  State<StatefulWidget> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();

  late String tripTitle;
  late String tripLocation;
  String tripDescription ="";

  List<CreateSpotPreview> spotPreviews = [  //TODO stub
    CreateSpotPreview(),
    CreateSpotPreview(),
    CreateSpotPreview(),
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child:
        /*AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Stack(
              children: [],
            )
        ),*/

      SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        //padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 120),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start, //doesnt work? its still centered, idk why
            children: [
              TextFormField(
                decoration:
                const InputDecoration(
                  hintText: 'Trip title',
                  labelText: 'Title',
                ),
                onChanged: (value) {
                  tripTitle = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a title";
                  } //else return null?
                },
              ),
              TextFormField(
                decoration:
                const InputDecoration(
                  hintText: 'Trip location',
                  labelText: 'Location',
                ),
                onChanged: (value) {
                  tripLocation = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a location";
                  } //else return null?
                },

              ),
              TextFormField(
                decoration:
                const InputDecoration(
                  hintText: 'Trip description',
                  labelText: 'Description',
                ),
                minLines: 4,
                maxLines: 20,
                onChanged: (value) {
                  tripDescription = value;
                },
              ),

              const Text("Spots:"),
              Column(
                children: spotPreviews,
              ),

              ElevatedButton(
                child: const Text("+ Add spot"),
                onPressed: (

                  ) {  },
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      //TODO could do the isLoading thing that Pilar did
                      createTrip();
                    }
                    else {  //if something's missing

                    }

                  },
                  child: const Text("Create trip"))
            ],
        ),
      ),

    );

    //return ElevatedButton(onPressed: () {createTestTripAndPic();},child: const Text("create test trip"),);
  }

  Future <void> createTrip() async {  //should catch exceptions?
    var batch = firestore.batch();

    // Create the trip
    var newTrip = firestore.collection('trips').doc();
    batch.set(newTrip, {
      'author_username': "FerranCreating", //TODO insert logged user username
      'title': tripTitle,
      'location': tripLocation,
      'description':tripDescription,
      'preview_pic': "tripPreviewPicFirebasePath", //TODO
    });

    // Create the new "spots" subcollection. //TODO: copy here

    // Commit the batch edits
    batch.commit()
        .then((value) => confirmTripAdded())
        .catchError((err) {
          print(err);
          informAddTripError(err);
    });
  }

  Future<void> createTestTripAndPic() async{
    String tripPreviewPicFilePathInDevice ="";  //TODO lo obtendremos por image_picker (ya tenemos la dependencia)
    String tripPreviewPicFilePathInFirebase = "users/ferranib00@gmail.com/trip1/macbasmol.png";

                                                  //Directory appDocDir = await getApplicationDocumentsDirectory();
                                                  //tripPreviewPicFilePathInDevice = '${appDocDir.absolute}/file-to-upload.png'; //  r'D:\Ferran\Documents\1.Documents\1.Universitat\Q7 coses a BCN\Apps'

    //TODO: do not remove
    //we find the picture in the device
    //File file = File(tripPreviewPicFilePathInDevice);
    //and upload it
    //await firebase_storage.FirebaseStorage.instance.ref(tripPreviewPicFilePathInFirebase).putFile(file);

    //we create the rest of the trip with a reference to the pic

    //but first we add the local paths to the spot pics, lol
    List<List<String>> spotPicsLocalPaths = [];
    createTestTrip(tripPreviewPicFilePathInFirebase, spotPicsLocalPaths);
  }

  void createTestTrip(String tripPreviewPicFirebasePath, List<List<String>> spotPicsLocalPaths) {
    var batch = firestore.batch();

    // Create the trip
    var newTrip = firestore.collection('trips').doc();
    batch.set(newTrip, {
      'author_username': "FerranChiese2",
      'title': "Visit with cool spots",
      'location': "El Raval, Barcelona, Spain",
      'description':"this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval ",
      'preview_pic': tripPreviewPicFirebasePath,
    });

    // Create the new "spots" subcollection.
    // we start with the pictures: we upload them and save their firebase paths in spotPicsFirebasePaths
    List<List<String>> spotPicsFirebasePaths = [];
    for (int i = 0; i < spotPicsLocalPaths.length; ++i/*var spotPics in spotPicsLocalPaths*/) { //for each spot
      spotPicsFirebasePaths[i] = [];  //create the list so its not null
      for (int j = 0; j < spotPicsLocalPaths[i].length; ++j/*var pic in spotPics*/) { //for each pic in the spot
        //upload pic to storage
        //save firebase path in spotPicsFirebasePaths
        //spotPicsFirebasePaths[i][j] =
      }
    }

    //then we create the spots.
    //should be for each (in a list). this is just one spot, an example
    var newSpot = newTrip.collection('spots').doc();
    batch.set(newSpot, {
      'spot_name': "MACBA Plaza",
      'spot_description': "aaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa ",
      'spot_soundtrack': "469rBLYJUZHMJLtq2Wch3h",
      'spot_pictures': [
        "land1.jpg",
        "land2.jpg",
        "land1.jpg",
        "land2.jpg"
      ]
    });

    // Commit the batch edits
    batch.commit()
        .then((value) => confirmTripAdded())
        .catchError((err) {
          print(err);
          informAddTripError(err);
        });
  }

  //TODO does this go in this class? i think so
  Future<void> createTestTripOld(String previewPicFirebasePath) {
    //and we create the trip
    CollectionReference trips = firestore.collection('trips');

    /*return*/Future<void> tripAddFuture = trips.add({
      'author_username': "FerranChiese",
      'title': "Visiting El Raval",
      'location': "El Raval, Barcelona, Spain",
      'description':"this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval this is a description about a trip to El Raval ",
      'preview_pic': previewPicFirebasePath,
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
