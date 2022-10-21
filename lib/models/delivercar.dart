import 'dart:async';
import 'dart:convert';

// import 'order.dart';
import 'package:delivery_template/models/user.dart';

import 'orderPPC.dart';

import 'Shop.dart';

class DeliverCarModel {


  String marque;
  String anneeDefabrication;
  String kilometrage;

  String createdBy; 
  String carteRoseImage;
  var numeroDePlaque;

  String chassis;
  String status;
  bool avaliability;

  String ownerIdImage;
  String ownerPhone;
  String edited; 

 // var historical;
  String id;
  
  

  DeliverCarModel(
      {
      this.marque,
      this.anneeDefabrication,
      this.kilometrage,

      this.createdBy,      
      this.carteRoseImage, 
      this.numeroDePlaque,

      this.chassis, 
      this.status,
      this.avaliability,

      this.ownerIdImage,
      this.ownerPhone, 
      this.edited,

     // this.historical,
      this.id
      });

  factory DeliverCarModel.fromJson(Map<String, dynamic> parsedJson) {
    return DeliverCarModel(
     
        marque: parsedJson['marque'], 
        anneeDefabrication: parsedJson['anneeDefabrication'],
        kilometrage: parsedJson['kilometrage'],

        chassis: parsedJson['chassis'],
        avaliability: parsedJson['avaliability'],
        status: parsedJson['status'],
       
       
        createdBy: parsedJson['createdBy'],
        carteRoseImage: parsedJson['carteRoseImage'],
        numeroDePlaque: parsedJson['numeroDePlaque'],

        ownerIdImage: parsedJson['ownerIdImage'],
        ownerPhone: parsedJson['ownerPhone'],
        edited: parsedJson['edited'],

     //   historical: parsedJson['historical'],
        id: parsedJson['_id']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'marque': marque, 
      'anneeDefabrication': anneeDefabrication,
      'kilometrage': kilometrage,

      'chassis': chassis,
      'avaliability': avaliability,
      'status': status,

      'carteRoseImage': carteRoseImage,
      'numeroDePlaque': numeroDePlaque,
      'createdBy': createdBy,

      'ownerIdImage':ownerIdImage,
      'ownerPhone':ownerPhone,
      //'edited': edited,

     // 'historical': historical,
      //'_id':numeroDePlaque,
    };
  }
}

List<DeliverCarModel> DeliverCarModelFromJson(dynamic jsonData) {
  var listAll = <DeliverCarModel>[];

  for (var item in jsonData) {
    //  print(jsonData[i]);
    listAll.add(DeliverCarModel.fromJson(item)); //}
  }

  // print('All are Success');
  // print('list delivercars :' + listAll.length.toString());
  return listAll;
}

DeliverCarModel OneDeliverCarModelFromJson(dynamic jsonData) {
  final data = json.decode(jsonData);

//  print('russell voici ${data['data']}');
  return DeliverCarModel.fromJson(data['data']);
}
