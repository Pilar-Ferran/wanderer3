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
import 'package:my_login/user_secure_storage.dart';
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

  String? loggedUsername;
  String? loggedUserEmail;

  @override
  void initState() {
    super.initState();
    getLoggedUsernameAndEmail();
  }


  @override
  void didChangeDependencies() {  //TODO inecesario?
    super.didChangeDependencies();
    getLoggedUsernameAndEmail();
  }

  Future<void> getLoggedUsernameAndEmail () async {
    loggedUsername = await UserSecureStorage.getUsername();
    loggedUserEmail = await UserSecureStorage.getUserEmail();
    print("persistent username = " +loggedUsername!+", persistent email = "+loggedUserEmail!);
  }

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
        child:
        ListView(
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
                onPressed: (spotDatas.isNotEmpty && loggedUsername!=null && loggedUserEmail!=null)? ()  async {  //if there's at least one spot and the username is not null (has been obtained), button enabled
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

      previewPicPathInFirebase = "users/"+loggedUserEmail!+"/" + tripTitle + "/preview"; //TODO hope I dont need a file extension lol
      await firebase_storage.FirebaseStorage.instance.ref(previewPicPathInFirebase)
          .putFile(picFile);
    }

    //then create the trip, referencing the preview pic
    var newTrip = firestore.collection('trips').doc();
    batch.set(newTrip, {
      'author_username': loggedUsername,
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
        String picPathInFirebase ="users/"+loggedUserEmail!+"/"+ tripTitle +"/"+ spotData.name +"/"+ i.toString();  //TODO hope I dont need a file extension lol
        allPicPathsInFirebase.add(picPathInFirebase);
        await firebase_storage.FirebaseStorage.instance.ref(picPathInFirebase).putFile(picFile);
      }

      //then we create the spot, referencing the pics
      var newSpot = newTrip.collection('spots').doc();
      batch.set(newSpot, {
        'spot_name': spotData.name,
        'spot_description': spotData.description,
        'spot_soundtrack': parseSoundtrackID(spotData.soundtrack),
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

  String? parseSoundtrackID(String? url) {
    if (url == null) {
      return url;
    }
    else {
      String songID = "";

      for (int i = 0; i < url.length; ++i) {
      }

      int j = 0;
      while (j<url.length && url[j]!= 'k') {
        j++;
      }
      //now url[j] == 'k'
      j += 2;
      //now url[j] is the first char of the ID
      while (j<url.length && url[j]!= '?') {
        songID += url[j];
        j++;
      }
      return songID;
    }
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
