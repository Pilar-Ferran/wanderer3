import 'package:flutter/material.dart';
import 'package:my_login/dataclasses/trip_data.dart';

class TripDetail extends StatefulWidget {
  static const routeName = '/trip_detail';

  const TripDetail({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TripDetailState();
}

class _TripDetailState extends State<TripDetail> {

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TripData;  //TODO may need to be in the dad class?
    final tripData = args;

    return Scaffold(
      appBar: AppBar(title: Text(/*widget.title*/args.title),),
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
                Center(child: tripData.previewPic, /*alignment: Alignment.center,*/)  //Container?
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0),),
            Text(tripData.description, style: const TextStyle(fontSize: 15),),
          ],
      ),)
      // Center(child: Text("this is the trip's detailed info screen"),),

    );
  }

}