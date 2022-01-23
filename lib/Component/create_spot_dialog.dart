
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

  late final Text dialogTitle;

  @override
  void initState() {
    super.initState();
    if (!widget.isEdit) {
      dialogTitle = const Text("Create spot");
    }
    else {
      spotName = widget.parentSpotDatas[widget.spotIndex!].name;
      spotDescription = widget.parentSpotDatas[widget.spotIndex!].description;
      spotSoundtrack = widget.parentSpotDatas[widget.spotIndex!].soundtrack;
      imageFiles = widget.parentSpotDatas[widget.spotIndex!].pictureFiles;

      for (var imageFile in imageFiles) {
        imageImages.add(Image.file(imageFile));
      }

      dialogTitle = Text("Edit spot " + spotName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child:
      ListView(children: [
      Column(  //this could be in a different class
        children: [
          dialogTitle,
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
                onChanged: (value) {
                  spotDescription = value;
                },
              ),
              TextFormField(
                initialValue: spotSoundtrack,
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
                  child: const Text("Add picture"),
                  onPressed: () {
                    pickImage();

                    //we find the picture in the device
                    //File file = File(tripPreviewPicFilePathInDevice);
                    //and upload it
                    //await firebase_storage.FirebaseStorage.instance.ref(tripPreviewPicFilePathInFirebase).putFile(file);
                  },
              ),
              Column(
                children: addPaddingBetweenImages(imageImages),
              ),

              !widget.isEdit? //if is create
              ElevatedButton(
                child: const Text("Create"),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      //Navigator.pop(context);
                      widget.parentSpotDatas.add(CreateSpotData(spotName, spotDescription, spotSoundtrack, imageFiles));
                      widget.parentSpotPreviews.add(CreateSpotPreview(spotName: spotName,
                        parentSpotDatas: widget.parentSpotDatas,
                        parentSpotPreviews: widget.parentSpotPreviews,
                        refreshParent: () { widget.refreshParent(); },
                        spotIndex: widget.parentSpotPreviews.length, //ojo, length
                      ));

                      widget.refreshParent();

                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    }
                    else {
                    }
                  },
              ):
                  //if is edit
              ElevatedButton(
                child: const Text("Save"),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    //we update the data and widget
                    widget.parentSpotDatas[widget.spotIndex!] = CreateSpotData(spotName, spotDescription, spotSoundtrack, imageFiles);
                    widget.parentSpotPreviews[widget.spotIndex!].spotName = spotName ;/*= CreateSpotPreview(spotName: spotName,  //remaking the entire object instead of just changing the name, bc aparently its immutable. and also bc I'd have to
                      parentSpotDatas: widget.parentSpotDatas,
                      parentSpotPreviews: widget.parentSpotPreviews,
                      refreshParent: () { widget.refreshParent(); },
                      spotIndex: widget.spotIndex!,
                    );*/

                    widget.refreshParent();

                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  }
                  else {
                  }
                },
              ),
            ],),
          ),

        ],
      ),
    ],
      )
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

}