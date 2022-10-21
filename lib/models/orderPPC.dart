import 'dart:convert';

import 'orderItemPPC.dart';

class OrderPPCModel {
  String whenMade;
  String customer;
  String status;
  String shop;
  String paymentMethode;
  bool isPayed;
  String deliverycode;
  double totalPrice;
  String details;
  String shippingAdress;
  bool isDeleted;
  String id;
  String deliverBoy;
  bool deliverBoyConfirm;
  String shippingDate;
  String deliveredDate;
   
  OrderPPCModel(
      { this.id,
       this.whenMade,
       this.customer,
       this.status,
       this.shop,
       this.paymentMethode,
       this.isPayed,
       this.totalPrice,
       this.details,
       this.shippingAdress,
       this.isDeleted,
       this.deliverBoy,
       this.deliverBoyConfirm,
       this.shippingDate,
       this.deliverycode,
       this.deliveredDate});

  

  factory OrderPPCModel.fromJson(Map<String, dynamic> parsedJson) {
    return OrderPPCModel(
        id: parsedJson['_id'],
        whenMade: parsedJson['WhenMade'],
        customer: parsedJson['customer'],
        status: parsedJson['status'],
        deliverBoy: parsedJson['deliverBoy'],
        deliverBoyConfirm: parsedJson['deliverBoyConfirm'],
        shippingDate: parsedJson['shippingDate'],
        deliveredDate: parsedJson['deliveredDate'],
        shop: parsedJson['shop'], //
            deliverycode: parsedJson['deliverycode'], 
        paymentMethode: parsedJson['paymentMethode'], //
        isPayed: parsedJson['IsPayed'], //
        totalPrice: double.parse(
            parsedJson['totalPrice']), //.toString().trim()).toString().trim())
        details: parsedJson['details'], //
        shippingAdress: parsedJson['shippingAdress'], //
        isDeleted: parsedJson['isDeleted']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'customer': customer,
      'shop': shop,
      'paymentMethode': paymentMethode,
      'totalPrice': totalPrice,
      'shippingAdress': shippingAdress,
    };
  }
}

List<OrderPPCModel> OrderPPCModelFromJson(dynamic jsonData) {
  
  List<OrderPPCModel> listAll = <OrderPPCModel>[];

  for (var item in jsonData) {
    listAll.add(OrderPPCModel.fromJson(item));
  }
 
  return listAll;
}

 
OrderPPCModel OneOrderPPCModelFromJson(dynamic jsonData) {
  final data = json.decode(jsonData);

 
  return OrderPPCModel.fromJson(data['data']);
}
