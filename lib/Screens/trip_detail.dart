import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_login/dataclasses/trip_data.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage; //THIS


class TripDetail extends StatefulWidget {
  static const routeName = '/trip_detail';

  const TripDetail({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TripDetailState();
}

class _TripDetailState extends State<TripDetail> {

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance; //THIS
  late Future<String> futureUrl; //THIS
  late String imgUrl; //THIS

  @override
  void initState() { //THIS
    super.initState();
    //getFileExample2();
  }

  /*void getFileExample2() async {  //THIS
    final ref = storage.ref().child('macbasmol.png');
    futureUrl = ref.getDownloadURL();
    /*var url = await ref.getDownloadURL();
    print(url);
    imgUrl = url;*/
  }*/

  @override
  Widget build(BuildContext context) {  //TODO mucho codigo repetido de trip_preview.dart
    final args = ModalRoute.of(context)!.settings.arguments as TripData;  // may need to be in the dad class?
    final tripData = args;

    return Scaffold(
      appBar: AppBar(title: Text(args.title),),
      body: Container(  //TODO: center?
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(  //main
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tripData.authorUser, textAlign: TextAlign.left, style: const TextStyle(fontSize: 18),),
            const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
            Row(        //title, place and pic
              children: [
                Column(   //title and place
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text(tripData.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.normal),),
                      Row(children:[  //place, with padding
                        const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),),
                        Text(tripData.place, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)])
                      ,
                    ]),
                Center(child:  //Container?
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
                            return Image.network(snapshot.data as String);
                          }
                        }
                        else { //show loading
                          return Column( children: const [
                            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
                            CircularProgressIndicator()],
                          );
                        }
                      },
                  ) /*alignment: Alignment.center,*/
    )],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0),),
            Text(tripData.description, style: const TextStyle(fontSize: 15),),
          ],
      ),)
    );
  }

}