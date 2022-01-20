
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_login/Component/spot_preview.dart';
import 'package:my_login/Screens/spot_detail.dart';
import 'package:my_login/dataclasses/spot_data.dart';
import 'package:my_login/dataclasses/spot_trip_pair.dart';
import 'package:my_login/dataclasses/trip_data.dart';

class CreateSpotPreview extends StatelessWidget {
  late List<Future<String>> list = [];
  late SpotData spotData = SpotData("spot 1", "this is a description", "soundtrack", list);
  late TripData tripData = TripData("authorUser", "title", "place", "description", "previewPic");
  late String spotTitle;
  String? spotDescription;
  String? spotSoundtrack;

  CreateSpotPreview(/*this.spotData, this.tripData,*/ {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: [
          const Text("this is a name"/*spotData.name*/),
          ElevatedButton(
              onPressed: () {
                showDialog(context: context, builder: (context) => Dialog(
                  child: Column(  //this could be in a different class
                    children: [
                      const Text("Edit spot"),
                      Form(
                        child: Column(children: [
                          TextFormField(
                            decoration:
                            const InputDecoration(
                              hintText: 'Spot title',
                              labelText: 'Title',
                            ),
                            onChanged: (value) {
                              spotTitle = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter a title";
                              } //else return null?
                            },
                          ),
                          TextFormField(
                            decoration:
                            const InputDecoration(
                              hintText: 'Spot description',
                              labelText: 'Description',
                            ),
                            onChanged: (value) {
                              spotDescription = value;
                            },
                          ),
                          TextFormField(
                            decoration:
                            const InputDecoration(
                              hintText: 'Spot soundtrack - Spotify song URL',
                              labelText: 'Soundtrack',
                            ),
                            onChanged: (value) {
                              spotSoundtrack = value;
                            },
                          ),
                        ],),
                      ),

                    ],
                  ),
                )
                );
              },
              child: const Icon(Icons.edit)),
          const ElevatedButton(
              onPressed: null,
              child: Icon(Icons.delete)),
        ],
      )
    );
  }
}