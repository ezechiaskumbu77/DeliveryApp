
import 'dart:convert';

class Geoloc {

  String lat;
  String long;

  Geoloc({this.lat, this.long});
  Geoloc.fromjson(Map<String,dynamic> parsedJson):
  lat = parsedJson['lat'].toString(),
  long = parsedJson['long'].toString();



}




class ShopModel {
   String name ;
   String shopOnwer;
   String shopManager;
   Geoloc geoLoc;
   String place ;
  String createdBy;
   String capacity;
   String address ;
   bool isDeleted;
   String id ;
   String description;

  ShopModel({this.name, this.shopOnwer, this.place, this.createdBy,
      this.capacity, this.address, this.isDeleted , this.id , this.description , this.shopManager});

  ShopModel.fromJson(Map<String, dynamic> parsedJson):
  name = parsedJson['name'],
  shopOnwer = parsedJson['shopOnwer'],
 // geoLoc = new Geoloc.fromjson(parsedJson['geoLoc']),
  place = parsedJson['place'],
  createdBy = parsedJson['createdBy'],
   capacity = parsedJson['capacity'],
  address = parsedJson['address'],
  isDeleted = parsedJson['isDeleted'],
  description = parsedJson['description'],
  id = parsedJson['_id'],
   shopManager = parsedJson['shopManager'];


  Map<String, dynamic> toMap(){

    return <String,dynamic> {
      'name' : name,
       'shopOnwer' : shopOnwer,
   //   'geoLoc': jsonEncode(geoLoc),
      'place': place,
      'createdBy' : createdBy,
      'capacity' : capacity,
      'address':address,
      'isDeleted' : isDeleted,
      '_id': id,
      'description' :description

    };

  }





}


List<ShopModel> ShopModelFromJson( dynamic jsonData) {
  // print('Strat here ${jsonData}');
  // final data = jsonDecode(jsonData);
  List<ShopModel> listAll = List<ShopModel>.from(jsonData.map( (item){
    //  print('see data $item');
    ShopModel shop = ShopModel.fromJson(item);
    //   print('done ${order.paymentMethode}');
    return shop ;} ) );
//  print('russell voici ${data['data']}');

  print('All are Success');
  return listAll;
}

