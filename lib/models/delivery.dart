import 'dart:convert';

// import 'order.dart';
import 'orderPPC.dart';

import 'Shop.dart';

class DeliveryModel {
  String id;

  bool isIssue;
  bool isDelivered;
  bool accepted;
  String shopId;
  String orderId;

  String deliveryBy;
  String edited;
  OrderPPCModel order;
    ShopModel shop;

  String whenAssigned;

  DeliveryModel(
      { this.id,
       this.isIssue,
       this.isDelivered,
       this.accepted,
       this.orderId,
       this.shopId,
       this.deliveryBy,
       this.edited,
       this.whenAssigned,
       this.order,
       this.shop});

  /*DeliveryModel.fromJson(Map<String, dynamic> parsedJson):
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

  factory DeliveryModel.fromJson(Map<String, dynamic> parsedJson) {
    return DeliveryModel(
        id: parsedJson['_id'],
        isDelivered: parsedJson['isDelivered'],
        isIssue: parsedJson['isIssue'],
        accepted: parsedJson['accepted'],//==null && parsedJson['accepted']==false)?false:true
        deliveryBy: parsedJson['deliveryBy'],
        orderId: parsedJson['OrderId'],
        shopId: parsedJson['shopId'],
        edited: parsedJson['edited'],
        whenAssigned: parsedJson['whenAssigned'],
        order: OrderPPCModel(
            customer: '',
            deliverBoy: '',
            whenMade: '',
            totalPrice: 0,
            deliveredDate: '',
            shippingDate: '',
            deliverBoyConfirm: false,
            status: '',
              deliverycode: '', 
            shippingAdress: '',
            isDeleted: false,
            id: '',
            isPayed: true,
            shop: '',
            paymentMethode: '',
            details: ''),
            shop: ShopModel('','','','','','',false,'','','',Geoloc('0','0')));
  }
/*
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'customer': customer,
      'shop': shop,
      'paymentMethode': paymentMethode,
      'totalPrice': totalPrice,
      'shippingAdress': shippingAdress,
    };
  }*/
}

List<DeliveryModel> DeliveryModelFromJson(dynamic jsonData) {
  
  List<DeliveryModel> listAll = <DeliveryModel>[];


  // for (var item in jsonData) {
  for (var i = jsonData.length-1; i >=0; i--) {
   // print(jsonData[i]);
    listAll.add(DeliveryModel.fromJson(jsonData[i]));
  }
 
  return listAll;
}

DeliveryModel OneDeliveryModelFromJson(dynamic jsonData) {

  final data = json.decode(jsonData);

//  print('russell voici ${data['data']}');
  return DeliveryModel.fromJson(data['data']);

}
