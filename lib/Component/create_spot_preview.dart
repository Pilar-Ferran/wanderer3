
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_login/Component/create_spot_dialog.dart';
import 'package:my_login/dataclasses/create_spot_data.dart';
import 'package:my_login/dataclasses/spot_data.dart';

class CreateSpotPreview extends StatefulWidget {
  const CreateSpotPreview({Key? key, required this.spotName, required this.parentSpotPreviews, required this.parentSpotDatas, required this.refreshParent}) : super(key: key);

  final String spotName;
  final List<CreateSpotPreview> parentSpotPreviews;
  final List<CreateSpotData> parentSpotDatas;
  final Function() refreshParent;

  @override
  State<StatefulWidget> createState() => _CreateSpotPreviewState();
}

class _CreateSpotPreviewState extends State<CreateSpotPreview> {

  //late List<Future<String>> list = [];
  //late SpotData spotData = SpotData("spot 1", "this is a description", "soundtrack", list);
  //late TripData tripData = TripData("authorUser", "title", "place", "description", "previewPic");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: [
          Text(widget.spotName),
          ElevatedButton(
              onPressed: () {
                showDialog(context: context, builder: (context) => CreateSpotDialog(
                  parentSpotPreviews: widget.parentSpotPreviews,
                  parentSpotDatas: widget.parentSpotDatas,
                  refreshParent: () {  },
                ));
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