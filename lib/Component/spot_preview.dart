
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:my_login/Screens/spot_detail.dart';
import 'package:my_login/dataclasses/spot_data.dart';
import 'package:my_login/dataclasses/spot_trip_pair.dart';
import 'package:my_login/dataclasses/trip_data.dart';

class SpotPreview extends StatelessWidget {
  final SpotData spotData;
  final TripData tripData;

  const SpotPreview(this.spotData, this.tripData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return Container(
    return Card(
        //margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, SpotDetail.routeName, arguments: SpotTripPair(spotData, tripData));
          },
          //child: Ink(
          child: Container(
            child: Column(children: [
              Row(  //title and padding
                children: [
                /*child:*/ Text(spotData.name, style: const TextStyle(fontSize: 22, /*fontWeight: FontWeight.bold*/),),
                ],
              ),
              Text(spotData.description, style: const TextStyle(fontSize: 15),),
            ],),
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          ),
        ),
    );
  }
}