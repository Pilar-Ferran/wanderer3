
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_login/dataclasses/create_spot_data.dart';
import 'package:my_login/dataclasses/spot_data.dart';

import 'create_spot_preview.dart';
import 'dart:async';
import 'dart:io' as dart_io;

//is used to create and to edit a spot. indicated by the boolean isEdit
class CreateSpotDialog extends StatefulWidget {
  const CreateSpotDialog({Key? key, required this.parentSpotPreviews, required this.parentSpotDatas, required this.refreshParent, required this.isEdit, this.spotIndex}) : super(key: key);

  final int? spotIndex;
  final List<CreateSpotPreview> parentSpotPreviews;
  final  List<CreateSpotData> parentSpotDatas;
  //final Widget myParent;
  final Function() refreshParent;
  final bool isEdit;

  @override
  State<StatefulWidget> createState() => _CreateSpotDialogState(/*parentSpotDatas, parentSpotPreviews*/);
}

class _CreateSpotDialogState extends State<CreateSpotDialog> {

  //final List<CreateSpotPreview> parentSpotPreviews;
  //final  List<SpotData> parentSpotDatas;

  //_CreateSpotDialogState(this.parentSpotDatas, this.parentSpotPreviews);

  final formKey = GlobalKey<FormState>();

  late String spotName = "";
  String spotDescription ="";
  String? spotSoundtrack;
  List<dart_io.File> imageFiles = [];

  List<Image> imageImages = [];

  //late List<dynamic> spotPictures = []; //ya no
  final ImagePicker imagePicker = ImagePicker();

  late final String dialogTitle;

  @override
  void initState() {
    super.initState();
    if (!widget.isEdit) {
      dialogTitle = "Create spot";
    }
    else {
      spotName = widget.parentSpotDatas[widget.spotIndex!].name;
      spotDescription = widget.parentSpotDatas[widget.spotIndex!].description;
      spotSoundtrack = widget.parentSpotDatas[widget.spotIndex!].soundtrack;
      imageFiles = widget.parentSpotDatas[widget.spotIndex!].pictureFiles;

      for (var imageFile in imageFiles) {
        imageImages.add(Image.file(imageFile));
      }

      dialogTitle = "Edit spot " + spotName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ListView(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(  //this could be in a different class
            children: [
              const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
              Text(dialogTitle, style: const TextStyle(fontSize: 18)),
              Form(
                key: formKey,
                child: Column(children: [
                  TextFormField(
                    initialValue: spotName,
                    decoration:
                    const InputDecoration(
                      hintText: 'Spot name',
                      labelText: 'Name',
                    ),
                    onChanged: (value) {
                      spotName = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a title";
                      } //else return null?
                    },
                  ),
                  TextFormField(
                    initialValue: spotDescription,
                    decoration:
                    const InputDecoration(
                      hintText: 'Spot description',
                      labelText: 'Description',
                    ),
                    minLines: 4,
                    maxLines: 20,
                    onChanged: (value) {
                      spotDescription = value;
                    },
                  ),
                  Row(
                      children: [
                        Expanded( //limits the InputDecoration's width, so it doesnt explode
                            child: TextFormField(
                              initialValue: spotSoundtrack,
                              decoration:
                              const InputDecoration(
                                hintText: 'Spotify song URL',
                                labelText: 'Spot Soundtrack',
                              ),
                              onChanged: (value) {
                                spotSoundtrack = value;
                              },
                            ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.info),
                          onPressed: () {
                            showSoundtrackInfoDialog();
                          },
                        ),
                      ],
                  ),
                  const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Pictures: "),
                  ),
                  const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),
                  Column(
                    children: //addPaddingBetweenImages(imageImages),
                    imagesWithPaddingAndDeleteButton(imageImages),
                  ),

                  Container(  //add pic button
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      label: const Text("Add picture"),
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        pickImage();
                      },
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        child: const Text("Cancel"),
                        onPressed: () async {
                          widget.refreshParent(); //unnecesary?
                          Navigator.of(context, rootNavigator: true).pop('dialog');
                        },
                      ),
                      const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),),

                      ElevatedButton( //create/save button
                        child: !widget.isEdit? const Text("Create"):const Text("Save"),
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {

                            if (!widget.isEdit) { //if is create
                              createSpotButtonFunc();
                            }
                            else { //if is edit
                              editSpotButtonFunc();
                            }

                            //common code
                            widget.refreshParent();
                            Navigator.of(context, rootNavigator: true).pop('dialog');
                          }
                          else {
                          }
                        },
                      ),
                    ],
                  ),
                ],),
              ),
            ],
          ),
        )
      ],)
    );
  }

  void addImage(dart_io.File imageFile) {
    imageFiles.add(imageFile);
    imageImages.add(Image.file(imageFile));
  }

  Future<void> pickImage() async {
    try {
      final imageThing = await imagePicker.pickImage(
          source: ImageSource.gallery);
      if (imageThing == null) {
        return;
      }

      final dart_io.File imageFile = dart_io.File(/*[],*/ imageThing.path);
      setState(() => {
        addImage(imageFile)
      }); //idk
    }

    on PlatformException catch (e) {
      print("permission to gallery rejected. error = "+e.toString());
      Fluttertoast.showToast(msg: "permission to gallery rejected.");
    }

  }

  List<Widget> addPaddingBetweenImages(List<Image> imageList) {
    List<Widget> widgets = [];
    for (var image in imageList) {
      widgets.add(image);
      widgets.add(const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),));
    }
    return widgets;
  }

  void deletePic(int index) {
    setState(() {
      imageImages.removeAt(index);
      imageFiles.removeAt(index);
    });
  }

  showDeletePicConfirmationDialog(BuildContext context, int index) {
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
        deletePic(index);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete picture?"),
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

  List<Widget> imagesWithPaddingAndDeleteButton(List<Widget> imageList) {
    List<Widget> widgets = [];

    for(int i = 0; i < imageList.length; ++i) {
      Stack stack = Stack(children: [

        imageList[i],

        Container(  //delete button
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red,),
          child: IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.black,
            iconSize: 30,
            onPressed: () {
              showDeletePicConfirmationDialog(context, i);
              Fluttertoast.showToast(msg: "delete");
            },
          ),
        )
      ],
        alignment: AlignmentDirectional.bottomEnd,
      );

      widgets.add(stack);
      widgets.add(const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),));
    }

    return widgets;
  }

  void createSpotButtonFunc() {
    widget.parentSpotDatas.add(CreateSpotData(spotName, spotDescription, spotSoundtrack, imageFiles));
    widget.parentSpotPreviews.add(CreateSpotPreview(spotName: spotName,
      parentSpotDatas: widget.parentSpotDatas,
      parentSpotPreviews: widget.parentSpotPreviews,
      refreshParent: () { widget.refreshParent(); },
      spotIndex: widget.parentSpotPreviews.length, //ojo, length
    ));
  }

  void editSpotButtonFunc() {
      //we update the data and widget
      widget.parentSpotDatas[widget.spotIndex!] = CreateSpotData(spotName, spotDescription, spotSoundtrack, imageFiles);
      //widget.parentSpotPreviews[widget.spotIndex!].spotName = spotName ;  //aixi no es notifica als spotPreviews q facin refresh.
      widget.parentSpotPreviews[widget.spotIndex!] = CreateSpotPreview(spotName: spotName,  // per tant, remaking the entire object instead of just changing the name. also flutter likes it bc aparently its immutable.
        parentSpotDatas: widget.parentSpotDatas,
        parentSpotPreviews: widget.parentSpotPreviews,
        refreshParent: () { widget.refreshParent(); },
        spotIndex: widget.spotIndex!,
      );
  }

  void showSoundtrackInfoDialog() {
    // set up the button
    Widget okButton = ElevatedButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("How to add a Spot Soundtrack"),
      content: const Text('To add a Spotify song as the soundtrack for this spot, open Spotify, tap "Share" on the song you want, and choose the "Copy link" option.\n'
          'Then paste the link here.'),
      actions: [
        okButton,
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