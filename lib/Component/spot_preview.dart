
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, SpotDetail.routeName, arguments: SpotTripPair(spotData, tripData));
          },
          child: Ink(
            child: Text(spotData.name),
          ),
        )
    );
  }
}