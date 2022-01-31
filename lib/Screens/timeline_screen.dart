import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_login/Component/picture_loading_indicator.dart';
import 'package:my_login/dataclasses/trip_data.dart';
import '../Component/trip_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../user_secure_storage.dart';

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

  String? loggedUsername;
  String? loggedUserEmail;

  @override
  initState() {
    super.initState();
    futureTrips = getTrips();
  }

  Future<void> iniLoggedUserInfo() async {
    print("timeline: iniLoggedUserInfo()");
    loggedUsername = await UserSecureStorage.getUsername();
    loggedUserEmail = await UserSecureStorage.getUserEmail();
    print("timeline: loggedUsername = "+loggedUsername!);
  }

  //hace el get de trips para la timeline
  Future<List<TripData>> getTrips() async {
    List<TripData> tripsRealLocal = [];
    CollectionReference trips = firestore.collection('trips');

    await iniLoggedUserInfo();

    QuerySnapshot<Object?> myUserQuery = await firestore.collection('users').where('username', isEqualTo: loggedUsername).get();
    var myUserData = myUserQuery.docs[0].data() as Map<String, dynamic>;

    for (String followedEmail in myUserData['list_following']) {
      QuerySnapshot<Object?> followedUserQuery = await firestore.collection('users').where('email', isEqualTo:followedEmail).get();
      var followedUserData = followedUserQuery.docs[0].data() as Map<String, dynamic>;
      String followedUsername = followedUserData['username'];
      QuerySnapshot<Object?> followedUserPostsQuery = await firestore.collection('trips').where('author_username', isEqualTo:followedUsername).get();

      for (var followedUserPost in followedUserPostsQuery.docs) {
        var post = followedUserPost.data() as Map<String, dynamic>;
        TripData trip = TripData.fromJson(post);
        trip.firestorePath = followedUserPost.reference.path;
        trip.previewPicFuture = getTripPreviewImage(trip.previewPic);
        tripsRealLocal.add(trip);
      }
    }

    //final Map<String,dynamic> userCharact=args;
    //userMapUid!['username'];

    /*QuerySnapshot<Object?> coolTrips = await firestore.collection('trips').where('author_username', isEqualTo: loggedUsername).get();
    //List coolTripsList = coolTrips.docs;

    QuerySnapshot<Object?> querySnapshot = await trips.get();

    //mete en tripsRealLocal todos los trips de la BD
    for (var doc in coolTrips.docs) {
      var docData = doc.data() as Map<String, dynamic>;
      TripData trip = TripData.fromJson(docData);

      //we add the firebase path, to find more info about it later
      trip.firestorePath = doc.reference.path;
      //trip.firestoreId = doc.reference.id;

      //we add the preview image, which is stored in a different Firebase service.
      trip.previewPicFuture = getTripPreviewImage(trip.previewPic);

      tripsRealLocal.add(trip);
    }*/
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
    return Container(
      child:
      Column(
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
                            children: [
                              ...tripWidgets,
                              const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),)
                            ],
                        );
                  }
                }
                else { //show loading
                  return Row( //hey, as long as it works
                    children: [PictureLoadingIndicator()],
                    mainAxisAlignment: MainAxisAlignment.center,
                  );
                }
              },
            ),

          )

        ],
      ),


      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/cyan.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}