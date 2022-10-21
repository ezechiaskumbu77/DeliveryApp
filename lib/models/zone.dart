import 'dart:convert';

class ZoneModel {
  String name;
  var listplaces;
  String id;

  ZoneModel(
      this.name,
      this.listplaces, 
      this.id);

  ZoneModel.fromJson(Map<String, dynamic> parsedJson)
      : name = parsedJson['name'],
        listplaces = parsedJson['listplaces'], 
        id = parsedJson['_id'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "name": name,  
      "listplaces": listplaces, 
      "_id": id
    };
  }
}

List<ZoneModel> ZoneModelFromJson(dynamic jsonData) { 
  List<ZoneModel> listAll = List<ZoneModel>.from(jsonData.map((item) { 
    final zone = ZoneModel.fromJson(item); 
    return zone;
  })); 
  return listAll;
}
