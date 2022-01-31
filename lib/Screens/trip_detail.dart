import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_login/Component/picture_loading_indicator.dart';
import 'package:my_login/Screens/user_detail.dart';
import 'package:my_login/Component/spot_preview.dart';
import 'package:my_login/Screens/search_yourself_screen.dart';
import 'package:my_login/dataclasses/spot_data.dart';
import 'package:my_login/dataclasses/trip_data.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../logged_user_info.dart';
import '../user_secure_storage.dart'; //THIS


class TripDetail extends StatefulWidget {
  static const routeName = '/trip_detail';

  const TripDetail({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TripDetailState();
}

class _TripDetailState extends State<TripDetail> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  late Future<String> futureUrl;
  late String imgUrl;

  late Future<List<SpotData>> futureSpots;

  late final TripData args;
  Map<String, dynamic>? userMap;

  LoggedUserInfo loggedUserInfo = LoggedUserInfo();   //TODO, or not
  String? loggedUsername;
  String? loggedUserEmail;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as TripData;
    futureSpots = getSpots();
    iniLoggedUserInfo();
  }

  Future<void> iniLoggedUserInfo() async {  //TODO problems w async?
    loggedUsername = await UserSecureStorage.getUsername();
    loggedUserEmail = await UserSecureStorage.getUserEmail();
  }

  Future<List<SpotData>> getSpots() async {

    //print("firestorePath = "+args.firestorePath+"\n firestoreId = "+args.firestoreId);

    CollectionReference spotsReference = firestore/*.collection('trips')*/.doc(args.firestorePath).collection('spots');

    QuerySnapshot<Object?> querySnapshot = await spotsReference.get();


    List<SpotData> spotsRealLocal = [];
    //mete en spotsRealLocal los spots de la BD
    for (var doc in querySnapshot.docs) {
      var docData = doc.data() as Map<String, dynamic>;
      //print("doc in querySnapshot.docs. doc.id = "+ doc.id +". doc.data() = "+docData.toString());

      SpotData spot = SpotData.fromJson(docData); //peta

      //print("spot.pictures = "+spot.pictures.toString());

      //we add the image URLs, which are stored in a different Firebase service.
      for (var pic in spot.pictures) {
        spot.picturesFutures.add(getImageUrl(pic));
      }
      //confirmo q el future s'obté i fica.

      spotsRealLocal.add(spot);
    }

    return spotsRealLocal;
  }

  Future<String> getImageUrl(String picPath) async {
    //print("picPath = "+picPath+". downloadURL = "+ storage.ref().child(picPath).getDownloadURL().toString());
    return storage.ref().child(picPath).getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {  //TODO mucho codigo repetido de trip_preview.dart
    //final args = ModalRoute.of(context)!.settings.arguments as TripData;  // may need to be in the dad class?
    final tripData = args;
    //print("in build(): firestorePath = "+args.firestorePath+"\n firestoreId = "+args.firestoreId);

    return Scaffold(
      appBar: AppBar(title: Text(args.title),),
      body: Container(  //TODO: center?
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: ListView(  //main  // may need to be ListView in the future, bc Column isnt scrollable
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              child: Text(tripData.authorUser, textAlign: TextAlign.left, style: const TextStyle(fontSize: 18),),
              onTap: () async {
                if (loggedUsername!=null && tripData.authorUser!=loggedUsername) { //si no soy yo
                  QuerySnapshot<Object?> authorQuery = await firestore
                      .collection('users').where(
                      'username', isEqualTo: tripData.authorUser).get();
                  var authorData = authorQuery.docs[0].data() as Map<String,dynamic>;
                  Navigator.pushNamed(context, UserDetail.routeName, arguments: authorData);
                }
              },
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
            Row(        //title, place and pic
              children: [
                Row(children: [ //title place and padding left
                  const Padding(padding: EdgeInsets.fromLTRB(40, 0, 0, 0),),
                  Column(   //title and place
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        SizedBox(
                            width: 200,
                            child:
                            Text(tripData.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.normal),),
                        ),
                        Row(children:[  //place, with padding
                          const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),),
                          Text(tripData.place, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)])
                        ,
                      ]),
                ],),

                Row(  //pic and padding right
                  children: [
                    tripData.previewPic != null?
                    FutureBuilder( //THIS
                      future: tripData.previewPicFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) { //gets checked many times until its actually received I guess
                          if (snapshot.hasError) {
                            //TODO
                            print("error in snapshot: "+snapshot.error.toString());
                            return const Text("error");
                          }
                          else {
                            return Image.network(snapshot.data as String, width: 50, height: 50,);
                          }
                        }
                        else { //show loading
                          return const PictureLoadingIndicator();
                        }
                      },
                  )
                        :
                    const Padding(padding: EdgeInsets.fromLTRB(25, 25, 25, 25),), //if there is no pic, put padding,
                    const Padding(padding: EdgeInsets.fromLTRB(0, 0, 40, 0),),
                  ],
                )],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),

            //description
            const Padding(padding: EdgeInsets.fromLTRB(0, 25, 0, 0),),
            Text(tripData.description, style: const TextStyle(fontSize: 15),),

            const Padding(padding: EdgeInsets.fromLTRB(0, 25, 0, 0),),

            //blue line
            const Divider(
                thickness: 15,
                color: Colors.cyan
            ),

            //spots
            const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
            const Text("Spots: ", style:TextStyle(fontSize: 15, color: Color.fromRGBO(100, 100, 100, 1), fontWeight: FontWeight.bold)),
            const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
            FutureBuilder(
                future: futureSpots,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      //TODO
                      return Text("error in snapshot: "+snapshot.error.toString());
                    }
                    else {
                      List<SpotPreview> spotWidgets = [];
                      if (snapshot.data != null) {
                        for (var spotData in snapshot.data! as List<SpotData>) {
                          spotWidgets.add(SpotPreview(spotData, tripData));
                        }
                        /*return ListView(
                            children: spotWidgets
                        );*/
                        return Column(children: spotWidgets,crossAxisAlignment: CrossAxisAlignment.start,);
                      }
                      else {
                        return const Text("oopsie, null");
                      }
                    }
                  }
                  else { //show loading
                    return const PictureLoadingIndicator();
                  }
                })
          ],
      ),)
    );
  }

}