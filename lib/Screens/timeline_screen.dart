import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_login/Component/picture_loading_indicator.dart';
import 'package:my_login/dataclasses/trip_data.dart';
import '../Component/trip_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  //TODO poner titulo?

  @override
  State<StatefulWidget> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late Future<List<TripData>> futureTrips;
  //List<TripData> tripsReal = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    futureTrips = getTrips();
  }

  //hace el get de trips para la timeline
  Future<List<TripData>> getTrips() async {
    List<TripData> tripsRealLocal = [];
    CollectionReference trips = firestore.collection('trips');

    QuerySnapshot<Object?> querySnapshot = await trips.get();

    //mete en tripsRealLocal todos los trips de la BD
    for (var doc in querySnapshot.docs) {
      var docData = doc.data() as Map<String, dynamic>;
      //print("doc.data be like: " + doc.data().toString());
      TripData trip = TripData.fromJson(docData);

      //we add the firebase path, to find more info about it later
      trip.firestorePath = doc.reference.path;
      //trip.firestoreId = doc.reference.id;

      //we add the preview image, which is stored in a different Firebase service.
      /*if (trip.previewPic == null ) {
        print("entra1. trip.previewPic = null");
      }
      else {
        print("entra1. trip.previewPic = "+trip.previewPic!+"\ntrip.title = "+trip.title);
      }*/
      /*if (trip.previewPic == null || trip.previewPic == "") {
        print("entra2");
        trip.previewPic ??= 'macbasmol.png'; //TODO no hace falta?
      }*/
      trip.previewPicFuture = getTripPreviewImage(trip.previewPic);
      //print("trip.previewPicFuture = "+trip.previewPicFuture.toString());

      tripsRealLocal.add(trip);
    }
    return tripsRealLocal;
  }

  Future<String?> getTripPreviewImage(String? previewPicPath) async {
    if (previewPicPath == null) {
      return null;
    }
    return storage.ref().child(previewPicPath).getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    //he quitado el center
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            //I guess it makes sense to do this in build()
            child: FutureBuilder(
              future: futureTrips,
              builder: (context, snapshot) { //snapshot is something like the future kinda
                if (snapshot.connectionState == ConnectionState.done) { //gets checked many times until its actually received I guess
                  if (snapshot.hasError) {
                    //TODO
                    return Text("error in snapshot: "+snapshot.error.toString());
                  }
                  else {
                    //we convert the data into widgets. TODO is there a better way to do this?
                    List<TripPreview> tripWidgets = [];

                    if (snapshot.data != null) {
                      for (var tripData in snapshot.data! as List<TripData>) {
                        tripWidgets.add(TripPreview(tripData));
                      }
                    }
                    return ListView(
                            children: tripWidgets
                        );
                  }
                }
                else { //show loading
                  return const PictureLoadingIndicator();
                }
              },
            ),

          )
        ],
      );
  }
}