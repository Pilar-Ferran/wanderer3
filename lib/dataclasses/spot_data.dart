

class SpotData {

  late String name;
  late String description;
  late String soundtrack; //TODO type?
  late List<dynamic> pictures;
  List<Future<String>> picturesFutures = [];

  //metodo constructor
  SpotData(this.name, this.description, this.soundtrack, this.pictures);

  //nos permite crear uno a partir de json
  factory SpotData.fromJson(dynamic json) { //could be Map<String, dynamic> instead of dynamic
    return SpotData(json['spot_name'] as String, json['spot_description'] as String,
      json['spot_soundtrack'] as String, json['spot_pictures'] as List<dynamic>);
  }
}