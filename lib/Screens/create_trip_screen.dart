import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_login/Component/create_spot_dialog.dart';
import 'package:my_login/Component/create_spot_preview.dart';
import 'package:my_login/Screens/home_screen.dart';
import 'package:my_login/Screens/timeline_screen.dart';
import 'package:my_login/dataclasses/create_spot_data.dart';
import 'package:my_login/dataclasses/spot_data.dart';
import 'package:my_login/user_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image/image.dart' as img;
import 'dart:math' as math;

import '../logged_user_info.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({Key? key}) : super(key: key);

  final String title = "Create a trip";

  @override
  State<StatefulWidget> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  //FirebaseFirestore firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();

  late String tripTitle;
  late String tripLocation;
  String tripDescription ="";
  List<CreateSpotData> spotDatas = [];
  List<CreateSpotPreview> spotPreviews = [];
  File? previewPicFile;
  Image? previewPicImage;

  String? loggedUsername;
  String? loggedUserEmail;
  bool isloading = false;

  final ImagePicker imagePicker = ImagePicker();

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
    //LoggedUserInfo userInfo = LoggedUserInfo();
    loggedUsername =  /*userInfo.loggedUsername;*/ await UserSecureStorage.getUsername();
    loggedUserEmail = /*userInfo.loggedUserEmail;*/ await UserSecureStorage.getUserEmail();
    //print("persistent username = " +loggedUsername!+", persistent email = "+loggedUserEmail!);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child:
      Container(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child:
        isloading? const Center(
          child: CircularProgressIndicator(),
        )
            :
        ListView(
            //mainAxisAlignment: MainAxisAlignment.start, //doesnt work? its still centered, idk why
          children: [
            TextFormField(
              decoration:
              const InputDecoration(
                hintText: 'Trip title',
                labelText: 'Title *',
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
                labelText: 'Location *',
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

            const Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0),),
            Row(children: [
              const Text("Select a preview picture:"),
              IconButton(
                icon: const Icon(Icons.info),
                onPressed: () {
                  showPreviewPicInfoDialog();
                },
              ),
            ],),

            Container( //preview pic selection
              alignment: Alignment.centerLeft,
              child:
              IconButton(
                icon:previewPicImage==null ? const Icon(Icons.image): previewPicImage!,
                onPressed: () {
                  pickImage();
                  },
                iconSize: 50,
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
                    setState(() {
                      isloading = true;
                      print("isloading = "+isloading.toString());
                    });

                    createTrip();
                  }
                  else {  //if something's missing
                    showToastFormInvalid();
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
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var batch = firestore.batch();

    // Create the trip
    //first, the preview pic
    String? previewPicPathInFirebase;

    if (previewPicFile == null && spotDatas[0].pictureFiles.isNotEmpty) {
      previewPicFile = spotDatas[0].pictureFiles[0];
    }

    String timestampString = DateTime.now().millisecondsSinceEpoch.toString();  //makes sure that no two trips have the same path

    if (previewPicFile != null) {
      previewPicPathInFirebase = "users/"+loggedUserEmail!+"/" + tripTitle + timestampString + "/preview"; //TODO hope I dont need a file extension lol
      await firebase_storage.FirebaseStorage.instance.ref(previewPicPathInFirebase)
          .putFile(previewPicFile!);
    }

    //then create the trip, referencing the preview pic
    var newTrip = firestore.collection('trips').doc();
    batch.set(newTrip, {
      'author_username': loggedUsername,
      'title': tripTitle,
      'location': tripLocation,
      'description':tripDescription,
      'preview_pic': previewPicPathInFirebase,
      'tid': newTrip.id //_auth.currentUser!.uid
    });

    // Create the new "spots" subcollection. //anava a ferho com a l'altre metode (createTestTrip) pero aqui ho he fet millor.

    //create the spots.
    for (var spotData in spotDatas) { //for each spot

      //first we upload the spot's pics, and keep their path strings
      List<String> allPicPathsInFirebase = [];
      for (int i = 0; i < spotData.pictureFiles.length; ++i) {
        File picFile = spotData.pictureFiles[i];
        String picPathInFirebase ="users/"+loggedUserEmail!+"/"+ tripTitle + timestampString +"/"+ spotData.name +"/"+ i.toString();  //TODO hope I dont need a file extension lol
        //print("picPathInFirebase = "+picPathInFirebase);
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
    //vamos a la pantalla de perfil
    Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (_) => false, arguments: 3); //esto hace que se vacie el stack y asi el user no puede volver hacia esta pantalla

  }

  void informAddTripError(onError) {
    print("error adding to firestore. error = "+onError.toString());
    Fluttertoast.showToast(msg: "There was an error creating the trip. Please contact a developer");
  }

  Future<void> setPreviewPic(File imageFile) async {
    previewPicImage = Image.file(imageFile, width: 50, height: 50/*, fit: BoxFit.none*/);//TODO better fit?
    previewPicFile = imageFile;
  }

  Future<void> pickImage() async {
    try {
      final imageThing = await imagePicker.pickImage(
          source: ImageSource.gallery,
      );
      if (imageThing == null) {
        return;
      }

      final File imageFile = File(/*[],*/ imageThing.path);
      setState(() => {
        setPreviewPic(imageFile)
      }); //idk
    }

    on PlatformException catch (e) {
      print("permission to gallery rejected. error = "+e.toString());
      Fluttertoast.showToast(msg: "permission to gallery rejected.");
    }
  }

  void showPreviewPicInfoDialog() {
    // set up the button
    Widget okButton = ElevatedButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Preview Picture"),
      content: const Text('Picture that will be displayed in a small size (50x50 pixels) next to the trip title.'),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showToastFormInvalid() {
    Fluttertoast.showToast(msg: "Please fill all the required fields");
  }
}
