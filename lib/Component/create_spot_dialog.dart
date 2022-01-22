
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
  const CreateSpotDialog({Key? key, required this.parentSpotPreviews, required this.parentSpotDatas, required this.refreshParent}) : super(key: key);

  final List<CreateSpotPreview> parentSpotPreviews;
  final  List<CreateSpotData> parentSpotDatas;
  //final Widget myParent;
  final Function() refreshParent;

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



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child:
      ListView(children: [
      Column(  //this could be in a different class
        children: [
          const Text("Create spot"),
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
              ElevatedButton(
                child: const Text("Create"),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      //Navigator.pop(context);
                      widget.parentSpotDatas.add(CreateSpotData(spotName, spotDescription, spotSoundtrack, imageFiles));  //TODO ahora: pasar los files.
                      widget.parentSpotPreviews.add(CreateSpotPreview(spotName: spotName,
                        parentSpotDatas: widget.parentSpotDatas,
                        parentSpotPreviews: widget.parentSpotPreviews,
                        refreshParent: () { widget.refreshParent(); },
                      ));

                      widget.refreshParent();

                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      //TODO rebuild the other screen?
                    }
                    else {

                    }
                  },
              )
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