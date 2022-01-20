
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_login/Component/spot_preview.dart';
import 'package:my_login/Screens/spot_detail.dart';
import 'package:my_login/dataclasses/spot_data.dart';
import 'package:my_login/dataclasses/spot_trip_pair.dart';
import 'package:my_login/dataclasses/trip_data.dart';

class CreateSpotPreview extends StatefulWidget {
  const CreateSpotPreview({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateSpotPreviewState();
}

class _CreateSpotPreviewState extends State<CreateSpotPreview> {
  final formKey = GlobalKey<FormState>();

  late List<Future<String>> list = [];
  //late SpotData spotData = SpotData("spot 1", "this is a description", "soundtrack", list);
  //late TripData tripData = TripData("authorUser", "title", "place", "description", "previewPic");
  late String spotTitle = "this be a name"; //TODO stub
  String spotDescription ="";
  String? spotSoundtrack;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: [
          Text(spotTitle),
          ElevatedButton(
              onPressed: () {
                showDialog(context: context, builder: (context) => Dialog(
                  child: Column(  //this could be in a different class
                    children: [
                      const Text("Edit spot"),
                      Form(
                        key: formKey,
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
                          ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  //Navigator.pop(context);
                                  Navigator.of(context, rootNavigator: true).pop('dialog');
                                  //TODO rebuild the other screen
                                }
                                else {

                                }
                              },
                              child: const Text("OK"))
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