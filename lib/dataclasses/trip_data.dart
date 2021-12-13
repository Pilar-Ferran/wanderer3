import 'package:flutter/material.dart';

//clase que sirve de dataclass. no hay dataclasses en dart. un dataclass es como una tupla/struct
//por ahora tiene valores hardcoded
class TripData {
  final String authorUser = "Ferran";  //var??
  String title = "Milano historical tour";
  String place = "Milano, Italy";
  String description = "this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip";
  late Image previewPic = Image.asset("images/Duomo.jpg"); ///Image.network("un_url");

  //metodo constructor
  TripData(/*this.authorUser, this.title*/);
}