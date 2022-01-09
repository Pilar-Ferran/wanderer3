import 'package:flutter/material.dart';
import 'dart:convert';

//clase que sirve de dataclass. no hay dataclasses en dart. un dataclass es como una tupla/struct
// tiene valores hardcoded por si a caso
class TripData {
  String authorUser = "Ferran";  //var??
  String title = "Milano historical tour";
  String place = "Milano, Italy";
  String description = "this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip";
  late Image previewPic = Image.asset("images/Duomo.jpg"); ///Image.network("un_url");

  //metodo constructor
  TripData(this.authorUser, this.title, this.place, this.description);

  //nos permite crear uno a partir de json
  factory TripData.fromJson(dynamic json) { //could be Map<String, dynamic> instead of dynamic
    return TripData(json['author_username'] as String, json['title'] as String, json['location'] as String, json['description'] as String);
  }
}