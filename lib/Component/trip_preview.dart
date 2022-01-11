//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:my_login/Component/picture_loading_indicator.dart';
import 'package:my_login/dataclasses/trip_data.dart';
import 'package:my_login/Screens/trip_detail.dart';

import '../Screens/trip_detail.dart';


class TripPreview extends StatelessWidget{
  late TripData tripData;// = TripData();

  TripPreview(this.tripData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child:
      //const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
      InkWell( //so its clickable and it shows the ripple effect
        onTap: () {
          Navigator.pushNamed(context, TripDetail.routeName, arguments: tripData);
        },
        child:
        Ink(  //like Container but the ripple effect shows
          //width: 50,
          //height: 50,
          decoration: const BoxDecoration(color: Color.fromRGBO(255, 170, 0, 0.5),/*border: Border.all()*/),
          child: Column(  //main
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tripData.authorUser, textAlign: TextAlign.left, style: const TextStyle(fontSize: 18),),
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
                Center(child:
                FutureBuilder(
                    future: tripData.previewPicFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
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
                        return const PictureLoadingIndicator();
                      }
                    }) /*alignment: Alignment.center,*/ )  //Container?
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
              Text(tripData.description, style: const TextStyle(fontSize: 15),),
            ],
          ),
          ),
        //borderRadius: BorderRadius.all(Radious.),
      ),
      //const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),),
    );
  }
}