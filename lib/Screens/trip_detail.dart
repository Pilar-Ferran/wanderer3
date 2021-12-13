import 'package:flutter/material.dart';
import 'package:my_login/dataclasses/trip_data.dart';

class TripDetail extends StatelessWidget {
  static const routeName = '/trip_detail';  //de que sirve?

  const TripDetail({Key? key}) : super(key: key);

  //might want to have a state. (and therefore inherit statefulWidget)
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TripData;

    return Center(child: Text("this is the trip's detailed info screen"),);
    //poner como titulo del scaffolding el titulo del trip
  }
}
