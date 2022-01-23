

import 'dart:io';

class CreateSpotData {

  late String name;
  late String description;
  late String? soundtrack;
  late List<File> pictureFiles;

  //metodo constructor
  CreateSpotData(this.name, this.description, this.soundtrack, this.pictureFiles);

  //nos permite crear uno a partir de json
  /*factory CreateSpotData.fromJson(dynamic json) { //could be Map<String, dynamic> instead of dynamic
    return CreateSpotData(json['spot_name'] as String, json['spot_description'] as String,
        json['spot_soundtrack'] as String?, json['spot_pictures'] as List<File>);
  }*/
}