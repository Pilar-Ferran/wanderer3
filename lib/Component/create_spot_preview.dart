
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_login/Component/create_spot_dialog.dart';
import 'package:my_login/dataclasses/create_spot_data.dart';
import 'package:my_login/dataclasses/spot_data.dart';

class CreateSpotPreview extends StatefulWidget {
  CreateSpotPreview({Key? key, required this.spotName, required this.parentSpotPreviews, required this.parentSpotDatas, required this.refreshParent, required this.spotIndex}) : super(key: key);

  final int spotIndex;
  late String spotName;
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
          Text(/*widget.spotName*/widget.parentSpotDatas[widget.spotIndex].name),
          ElevatedButton(
              onPressed: () {
                showDialog(context: context, builder: (context) => CreateSpotDialog(
                  parentSpotPreviews: widget.parentSpotPreviews,
                  parentSpotDatas: widget.parentSpotDatas,
                  refreshParent: () { widget.refreshParent(); }, //potser funciona passantlo talcuan com a widget.refreshParent
                  isEdit: true,
                  spotIndex: widget.spotIndex,
                ));
              },
              child: const Icon(Icons.edit)),
          ElevatedButton(
              onPressed: () {
                showDeleteConfirmationDialog(context);
              },
              child: const Icon(Icons.delete)),
        ],
      )
    );
  }

  showDeleteConfirmationDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: const Text("Delete"),
      onPressed:  () {
        widget.parentSpotDatas.removeAt(widget.spotIndex);
        widget.parentSpotPreviews.removeAt(widget.spotIndex);
        widget.refreshParent();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete spot"),
      content: Text("Delete spot "+/*widget.spotName*/widget.parentSpotDatas[widget.spotIndex].name+"?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}