import 'dart:convert';

class EntrepriseInfo {
  final String name ;
  final String address ;
  final String idna ;
  final String numeroImpot;
  final String rccm ;

  EntrepriseInfo(
      this.name, this.address, this.idna, this.numeroImpot, this.rccm);

  EntrepriseInfo.fromJson(Map<String,dynamic> parsedJson):
      name = parsedJson['name'],
      address = parsedJson['address'],
      idna = parsedJson['idna'],
      numeroImpot = parsedJson['numeroImpot'],
      rccm = parsedJson['rccm'];

}







class ShopOwnerModel {
  final String ownerUser ;
  final bool isDeleted ;
  final bool isValid ;
  final String ownerIdImage ;
  final EntrepriseInfo entrepriseInfo ;
  final String id;

  ShopOwnerModel({this.ownerUser, this.isDeleted, this.isValid, this.ownerIdImage,
      this.entrepriseInfo , this.id});

  ShopOwnerModel.fromJson(Map<String, dynamic> parsedJson):
      id = parsedJson['_id'],
      ownerUser = parsedJson['ownerUser'],
      isDeleted = parsedJson['isDeleted'],
      isValid = parsedJson['isValid'],
      ownerIdImage = parsedJson['ownerIdImage'],
      entrepriseInfo =  new EntrepriseInfo.fromJson(parsedJson['entrepriseInfo']);

  Map<String,dynamic> toMap() {
    return <String, dynamic> {
      '_id' : id ,
      'ownerUser' : ownerUser,
      'isDeleted' : isDeleted,
       'isValid' : isValid,
       'ownerIdImage' : ownerIdImage,
       'entrepriseInfo' : jsonEncode(entrepriseInfo),
    };
  }



}