

import 'package:flutter/material.dart';

class UserModel {

   String role ;
   bool isShopmanager ;
  bool isDeliverCorp ;
   bool hasShop ;
   String  id ;
  String name ;
  String email ;
   String phone ;
   String sexe;
   String address;
   String birthday;

    UserModel({
      this.role,
        this.isShopmanager,
      this.isDeliverCorp,
        this.hasShop,
          this.id,
        this.name,
        this.email,
      this.phone,
      this.sexe,
      this.address,
      this.birthday


    }
);

 UserModel.fromJson(Map<String, dynamic> parsedJson):

  id = parsedJson['_id'],
  role = parsedJson['role'],
  isShopmanager = parsedJson['isShopmanager'],
  isDeliverCorp = parsedJson['isDeliverCorp'],
  hasShop = parsedJson['hasShop'],
  name = parsedJson['name'],
  email = parsedJson['email'],
  sexe = parsedJson['sexe'],
  phone = parsedJson['phone'],
 address = parsedJson['address'],
   birthday = parsedJson['birthday'];

Map<String,dynamic>  toJson(){


  return <String,dynamic> {
  '_id' : id,
  'role' : role,
  'isShopmanager' : isShopmanager,
  'isDeliverCorp' : isDeliverCorp,
  'hasShop' : hasShop,
  'name' : name,
  'email': email,
  'phone' : phone,
  'sexe' : sexe,
    'address' : address,
    'birthday' : birthday
  };
}



}