import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_login/Screens/logout_screen.dart';

import 'trip_preview.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  //TODO poner titulo?

  @override
  State<StatefulWidget> createState() => _TimelineScreenState();
}


class _TimelineScreenState extends State<TimelineScreen> {
  @override
  Widget build(BuildContext context) {
    //TODO put actual values
    //TODO maybe do outside of build()
    List<TripPreview> trips = [TripPreview(), TripPreview(), TripPreview(), TripPreview(), TripPreview()];  //posts to show in the timeline
    //he quitado el center
    return Column(
        //comments borrados
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: ListView(
                //itemExtent: 50,
                children: trips,
                //shrinkWrap: true,

              )
          )
        ],
      );
  }
}