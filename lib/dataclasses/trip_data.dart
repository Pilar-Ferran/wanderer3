import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:my_login/dataclasses/spot_data.dart';

//clase que sirve de dataclass. no hay dataclasses en dart. un dataclass es como una tupla/struct
// tiene valores hardcoded por si a caso
class TripData {
  late String firestorePath;
  //late String firestoreId;
  String authorUser = "Ferran";  //var??
  String title = "Milano historical tour";
  String place = "Milano, Italy";
  String description = "this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip this is a description of my trip";
  late String? previewPic;// = Image.asset("images/Duomo.jpg"); //TODO is useless now?   no. this one is the path and future is the url creo
  late Future<String?> previewPicFuture;
  late List<SpotData> spots;

  //metodo constructor
  TripData(this.authorUser, this.title, this.place, this.description, this.previewPic);

  //nos permite crear uno a partir de json
  factory TripData.fromJson(dynamic json) { //could be Map<String, dynamic> instead of dynamic
    return TripData(json['author_username'] as String, json['title'] as String, json['location'] as String,
        json['description'] as String, json['preview_pic'] as String?);
  }
}