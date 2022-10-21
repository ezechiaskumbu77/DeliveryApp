import 'dart:async';
import 'dart:convert';

// import 'order.dart';
import 'package:delivery_template/models/user.dart';

import 'orderPPC.dart';

import 'Shop.dart';

class DeliverBoyModel {
  String id;

  String permis;
  String status;
  bool avaliability;
  bool isValid;

  var zones;

  bool independant;
  UserModel user;
  String edited;
  var horairedeservice;
  var historical;
  var ratings;
  var folder;
 

  DeliverBoyModel(
      {this.id,
      this.permis,
      this.status,
      this.avaliability,
      this.isValid,
      this.zones,
      this.independant,
      this.user,
      this.edited,
      this.horairedeservice,
      this.historical,
      this.ratings,
      this.folder});

  /*DeliverBoyModel.fromJson(Map<String, dynamic> parsedJson):
      id = parsedJson['_id'],
      whenMade = parsedJson['WhenMade'],
      customer = parsedJson['customer'],
        status = parsedJson['status'],
        deliverBoy = parsedJson['deliverBoy'],
        deliverBoyConfirm = parsedJson['deliverBoyConfirm'],
        shippingDate = parsedJson['shippingDate'],
        deliveredDate = parsedJson['deliveredDate'],
        shop = parsedJson['shop'], //
        paymentMethode = parsedJson['paymentMethode'], //
        isPayed = parsedJson['IsPayed'], //
        totalPrice = parsedJson['totalPrice'].toDouble(), //
        details = parsedJson['details'], //
        shippingAdress = parsedJson['shippingAdress'], //
        isDeleted = parsedJson['isDeleted'];*/

  factory DeliverBoyModel.fromJson(Map<String, dynamic> parsedJson) {

    return DeliverBoyModel(
        id: parsedJson['_id'],
        status: parsedJson['status'],
        permis: '',// parsedJson['permis']['validity'],
        avaliability: parsedJson['avaliability'],  
        isValid: parsedJson['isValid'],
        zones: parsedJson['zones'],
        independant: parsedJson['independant'], 
        edited: parsedJson['edited'],
         horairedeservice: parsedJson['horairedeservice'],
        historical: parsedJson['historical'],
        ratings: parsedJson['ratings'],
        folder: parsedJson['folder'],
        user: UserModel(
          id: '',// parsedJson['userID']['_id'],
          isShopmanager: false,// parsedJson['userID']['isShopmanager'],
          role:parsedJson['userID']['role'],
          isDeliverCorp:false,//  parsedJson['user']['isDeliverCorp'],
          hasShop:false,//  parsedJson['user']['hasShop'],
          name: parsedJson['userID']['name'],
          email:'',// parsedJson['user']['email'],
          phone:'',// parsedJson['user']['phone'], //   .toString().trim()).toString().trim())
          sexe:'',// parsedJson['user']['sexe'], //
          address:'',// parsedJson['user']['address'], //
          birthday:'',// parsedJson['user']['birthday'])
        ),
         );
  
  }
/*
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "customer": customer,
      "shop": shop,
      "paymentMethode": paymentMethode,
      "totalPrice": totalPrice,
      "shippingAdress": shippingAdress,
    };
  }*/
}

List<DeliverBoyModel> DeliverBoyModelFromJson(dynamic jsonData) {
 
  List<DeliverBoyModel> listAll = <DeliverBoyModel>[];

    for (var i = jsonData.length - 1; i >= 0; i--) {
    //  print(jsonData[i]);
      listAll.add(DeliverBoyModel.fromJson(jsonData[i]));//}
    }

  // print("All are Success");
  // print("list deliverboys :" + listAll.length.toString());
  return listAll;

}

DeliverBoyModel OneDeliverBoyModelFromJson(dynamic jsonData) {
  final data = json.decode(jsonData);

//  print("russell voici ${data['data']}");
  return DeliverBoyModel.fromJson(data['data']);
}
