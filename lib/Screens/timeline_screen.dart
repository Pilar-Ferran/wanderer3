import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_login/dataclasses/trip_data.dart';
import '../Component/trip_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  //TODO poner titulo?

  @override
  State<StatefulWidget> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late Future<List<TripData>> futureTrips;
  List<TripData> tripsReal = [];  //TODO useless?

  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
      //print("doc.data be like: ");
      //print(doc.data());
      tripsRealLocal.add(TripData.fromJson(docData));
    }
    return tripsRealLocal;
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
                  return Column( children: const [
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
                    CircularProgressIndicator()],
                  );
                }
              },
            ),

          )
        ],
      );
  }
}