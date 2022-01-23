import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_login/Component/create_spot_dialog.dart';
import 'package:my_login/Component/create_spot_preview.dart';
import 'package:my_login/dataclasses/create_spot_data.dart';
import 'package:my_login/dataclasses/spot_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image/image.dart' as img;

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
  List<CreateSpotData> spotDatas = [];
  List<CreateSpotPreview> spotPreviews = [];

  //we use spotData but pictures is device paths instead of online stuff //not anymore!!

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

      Container(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: ListView(
            //mainAxisAlignment: MainAxisAlignment.start, //doesnt work? its still centered, idk why
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

            const Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0),),

            const Text("Spots: "),
            spotPreviews.isEmpty?  //if there are no spots, show text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
                  Text("Add at least one spot."),
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
                ])
            :
            Column(children: spotPreviews,),
            Container(
              alignment: Alignment.centerLeft,
              child:
                  ElevatedButton.icon(
                    label: const Text("Add spot"),
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      showDialog(context: context, builder: (context)=>CreateSpotDialog(
                        parentSpotPreviews: spotPreviews,
                        parentSpotDatas: spotDatas,
                        refreshParent:() {refresh();},
                        isEdit: false,
                        spotIndex: spotPreviews.length,
                      ));
                      },
                  ),
            ),

            Container(
              alignment: Alignment.centerRight,
              child:
              ElevatedButton(
                child: const Text("Create trip", style: TextStyle(fontWeight: FontWeight.bold),),
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: spotDatas.isNotEmpty? ()  async {  //if there's at least one spot, button enabled
                  if (formKey.currentState!.validate()) {
                    //TODO could do the isLoading thing that Pilar did
                    createTrip();
                    //TODO: exit screen, so you cant add the same trip multiple times. also remove it from stack
                  }
                  else {  //if something's missing

                  }

                }:
                null, //else, button disabled
              ),
            ),
            ],
        ),
      ),

    );

    //return ElevatedButton(onPressed: () {createTestTripAndPic();},child: const Text("create test trip"),);
  }

  void refresh() {
    setState(() {});

    //if (isSaving != null) {
      reAssignRefreshFunctions(); //TODO should only do when saving an edit
    //}

    //if (isDeleting != null) {
      reAssignSpotIndexes(); //TODO should do when deleting
    //}
  }

  void reAssignRefreshFunctions () {
    for (CreateSpotPreview preview in spotPreviews) {
      preview.refreshParent = refresh;
    }
  }

  void reAssignSpotIndexes() {
    for (int i = 0; i < spotPreviews.length; ++i) {
      spotPreviews[i].spotIndex = i;
    }
  }

  /*File resizePreviewImage(File original) { //doing
    img.Image? imageTemp = img.decodeImage(original.readAsBytesSync());
    img.Image resizedImg = img.copyResize(imageTemp!, width:50, height:50);

    return img.encodeJpg(resizedImg);
  }*/

  Future <void> createTrip() async {  //should catch exceptions?
    var batch = firestore.batch();

    // Create the trip
    //first, the preview pic
    String? previewPicPathInFirebase;
    if (spotDatas[0].pictureFiles.isNotEmpty) {
      File picFile = spotDatas[0].pictureFiles[0]; //TODO chosen by user
      Image previewImage = Image.file(picFile, width:50, height:50, fit: BoxFit.none); //TODO better fit?
      //picFile = File(previewImage); //TODO: hay q pasar el previewImage a File. quizas será creando un File local?

      //picFile = resizePreviewImage(picFile);  //doing

      previewPicPathInFirebase = "users/ferranib00@gmail.com/" + tripTitle + "/preview"; //TODO hope I dont need a file extension lol //TODO insert user's email adress
      await firebase_storage.FirebaseStorage.instance.ref(previewPicPathInFirebase)
          .putFile(picFile);
    }

    //then create the trip, referencing the preview pic
    var newTrip = firestore.collection('trips').doc();
    batch.set(newTrip, {
      'author_username': "FerranCreating", //TODO insert logged user username
      'title': tripTitle,
      'location': tripLocation,
      'description':tripDescription,
      'preview_pic': previewPicPathInFirebase,
    });

    // Create the new "spots" subcollection. //anava a ferho com a l'altre metode (createTestTrip) pero aqui ho he fet millor.

    //create the spots.
    for (var spotData in spotDatas) { //for each spot

      //first we upload the spot's pics, and keep their path strings
      List<String> allPicPathsInFirebase = [];
      for (int i = 0; i < spotData.pictureFiles.length; ++i) {
        File picFile = spotData.pictureFiles[i];
        String picPathInFirebase ="users/ferranib00@gmail.com/"+ tripTitle +"/"+ spotData.name +"/"+ i.toString();  //TODO hope I dont need a file extension lol //TODO insert user's email adress
        allPicPathsInFirebase.add(picPathInFirebase);
        await firebase_storage.FirebaseStorage.instance.ref(picPathInFirebase).putFile(picFile);
      }

      //then we create the spot, referencing the pics
      var newSpot = newTrip.collection('spots').doc();
      batch.set(newSpot, {
        'spot_name': spotData.name,
        'spot_description': spotData.description,
        'spot_soundtrack': spotData.soundtrack,
        'spot_pictures': allPicPathsInFirebase
      });
    }


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
