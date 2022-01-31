//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:my_login/Component/picture_loading_indicator.dart';
import 'package:my_login/dataclasses/trip_data.dart';
import 'package:my_login/Screens/trip_detail.dart';

import '../Screens/trip_detail.dart';


class TripPreview extends StatelessWidget{
  final TripData tripData;// = TripData();

  const TripPreview(this.tripData, {Key? key}) : super(key: key);

  //@override
  Widget build2(BuildContext context) {
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
          decoration: BoxDecoration(color: Theme.of(context).cardColor,/*border: Border.all()*/),
          child: Column(  //main
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tripData.authorUser, textAlign: TextAlign.left, style: const TextStyle(fontSize: 18),),
              Row(        //title, place and pic
                children: [
                  Row(children: [ //title place and padding left
                    const Padding(padding: EdgeInsets.fromLTRB(40, 0, 0, 0),),
                    Column(   //title and place
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        //Container(child:
                        SizedBox(
                          width: 200, //could be done better, could be device dependent. but it works and looks good. makes sure the title doesnt overflow to the right
                          child:
                          Text(tripData.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.normal),),
                        ),
                        //color: Colors.pink,),
                        Row(children:[  //place, with padding
                          const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),),
                          Text(tripData.place, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)]),
                      ],
                    ),
                  ],),

                  Row(  //pic and padding right
                    children: [
                      tripData.previewPic != null?
                      FutureBuilder( //if there is pic, draw pic
                          future: tripData.previewPicFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasError) {
                                //TODO
                                print("error in snapshot: "+snapshot.error.toString());
                                return const Text("error");
                              }
                              else {
                                return Image.network(snapshot.data as String, width: 80, height: 80, fit: BoxFit.cover,);
                              }
                            }
                            else { //show loading
                              return const PictureLoadingIndicator();
                            }
                          },
                      )
                          :
                      const Padding(padding: EdgeInsets.fromLTRB(25, 25, 25, 25),), //if there is no pic, put padding

                      const Padding(padding: EdgeInsets.fromLTRB(0, 0, 40, 0),),
                    ],)
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Card(
      shape: const ContinuousRectangleBorder(),
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),  //OJO
      child: InkWell(
        splashColor: Theme.of(context).primaryColor,
        onTap: () {
          Navigator.pushNamed(context, TripDetail.routeName, arguments: tripData);
          },
        child: Container(
            child: Column(  //main
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tripData.authorUser, textAlign: TextAlign.left, style: const TextStyle(fontSize: 18),),
                const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
                Row(  //pic, title, place
                children: [
                  //pic:
                  tripData.previewPic != null?
                  FutureBuilder( //if there is pic, draw pic
                    future: tripData.previewPicFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          print("error in snapshot: "+snapshot.error.toString());
                          return const Text("error");
                        }
                        else {
                          return Image.network(snapshot.data as String, width: 80, height: 80, fit: BoxFit.cover,);
                        }
                      }
                      else { //show loading
                        return const PictureLoadingIndicator();
                      }
                    },
                  )
                      :
                  const Padding(padding: EdgeInsets.fromLTRB(40, 40, 40, 40),), //if there is no pic, put padding
                  //end pic
                  const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),),
                  //Container(child:
                  SizedBox(
                    width: (MediaQuery.of(context).orientation == Orientation.portrait)?200:400,
                    child: Column(
                      children: [
                        Text(tripData.title, style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),),
                        Text(tripData.place, style: const TextStyle(color: Color.fromRGBO(120, 120, 120, 1)),),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  ),
                    //color: Colors.pink,),
                ],
              ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
              Text(tripData.description, style: const TextStyle(fontSize: 15),),

            ],),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          ),
      ),
    );
  }
}