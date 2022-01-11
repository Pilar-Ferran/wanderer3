
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_login/dataclasses/spot_data.dart';
import 'package:my_login/dataclasses/spot_trip_pair.dart';
import 'package:my_login/dataclasses/trip_data.dart';

class SpotDetail extends StatefulWidget {
  static const routeName = '/spot_detail';

  const SpotDetail({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SpotDetailState();
}

class _SpotDetailState extends State<SpotDetail> {

  late final SpotTripPair args;
  late final SpotData spotData;
  late final TripData tripData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as SpotTripPair;
    spotData = args.spot;
    tripData = args.trip;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(spotData.name+" - "+tripData.title),),
        body: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(  //main
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tripData.authorUser, textAlign: TextAlign.left, style: const TextStyle(fontSize: 18),),
              const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),

              Column(   //trip title, place, spot name
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text(tripData.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.normal),),
                    Row(children:[  //place, with padding
                      const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),),
                      Text(tripData.place, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)]
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
                    Text(spotData.name, style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
                    const Text("Soundtrack", style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
                    Text(spotData.description, style: const TextStyle(fontSize: 15),),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
                    //ahora vendrian las fotos
                  ]),

            ]        //title, place and pic
          )
    ),
    );
  }

}