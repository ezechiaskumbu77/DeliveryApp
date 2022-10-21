
import 'dart:convert';

import 'package:delivery_template/models/user.dart';

import 'product.dart';
class ManagerModel {
  String id ;
 bool isDeleted ;
 UserModel userID ;
 String shopOwner ;


ManagerModel({this.isDeleted, this.userID, this.shopOwner , this.id});


ManagerModel.fromJson(Map<String, dynamic> parsedJson):
    id = parsedJson['_id'],
      isDeleted = parsedJson['isDeleted'],
      userID = UserModel.fromJson(parsedJson['userID']),
      shopOwner = parsedJson['shopOwner'];





Map<String,dynamic> toJson() {

  return <String,dynamic> {

    "isDeleted": isDeleted,


  };
}

}


List<ManagerModel> ManagerModelFromJson( dynamic jsonData) {
  // print("Strat here ${jsonData}");
  // final data = jsonDecode(jsonData);
  print("Here we start");
  List<ManagerModel> listAll = List<ManagerModel>.from(jsonData.map( (item){
     print("see data $item");
    ManagerModel manager = ManagerModel.fromJson(item);
    print("after see ");
    //   print("done ${order.paymentMethode}");
    return manager ;
  }
    ) );
//  print("russell voici ${data['data']}");

  return listAll;
}

ManagerModel OneManagerModelFromJson( dynamic jsonData) {
  final data = json.decode(jsonData);

//  print("russell voici ${data['data']}");
  return  ManagerModel.fromJson(data['data']) ;
}