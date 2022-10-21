

import 'dart:convert';

class OrderPPCModel {
   String WhenMade ;
   String customer;
  String status;
   String shop ;
   String paymentMethode;
   bool IsPayed;
   double totalPrice;
  String details;
   String shippingAdress;
  bool isDeleted;
  String id ;
   String deliverBoy ;
   bool deliverBoyConfirm ;
   String shippingDate ;
  String deliveredDate ;


   OrderPPCModel(
     { this.WhenMade,
      this.customer,
      this.status,
      this.shop,
      this.paymentMethode,
      this.IsPayed,
      this.totalPrice,
      this.details,
      this.shippingAdress,
      this.isDeleted,
      this.id,
      this.deliverBoy,
      this.deliverBoyConfirm,
      this.shippingDate,
      this.deliveredDate});

  OrderPPCModel.fromJson(Map<String, dynamic> parsedJson):
      id = parsedJson['_id'],
      WhenMade = parsedJson['WhenMade'],
      customer = parsedJson['customer'],
        status = parsedJson['status'],
        deliverBoy = parsedJson['deliverBoy'],
        deliverBoyConfirm = parsedJson['deliverBoyConfirm'],
        shippingDate = parsedJson['shippingDate'],
        deliveredDate = parsedJson['deliveredDate'],
        shop = parsedJson['shop'], //
        paymentMethode = parsedJson['paymentMethode'], //
        IsPayed = parsedJson['IsPayed'], //
        totalPrice = parsedJson['totalPrice'].toDouble(), //
        details = parsedJson['details'], //
        shippingAdress = parsedJson['shippingAdress'], //
        isDeleted = parsedJson['isDeleted'];



  Map<String,dynamic> toJson() {

    return <String,dynamic> {


      "customer" : customer ,

      "shop" : shop ,
      "paymentMethode" : paymentMethode ,

      "totalPrice" : totalPrice ,

      "shippingAdress" : shippingAdress ,


    };
  }



}


List<OrderPPCModel> OrderPPCModelFromJson( dynamic jsonData) {
 // print("Strat here ${jsonData}");
 // final data = jsonDecode(jsonData);
  List<OrderPPCModel> listAll = List<OrderPPCModel>.from(jsonData.map( (item){
  //  print("see data $item");
    OrderPPCModel order = OrderPPCModel.fromJson(item);
 //   print("done ${order.paymentMethode}");
    return order ;} ) );
//  print("russell voici ${data['data']}");

  print("All are Success");
  return listAll;
}

OrderPPCModel OneOrderPPCModelFromJson( dynamic jsonData) {
  final data = json.decode(jsonData);

//  print("russell voici ${data['data']}");
  return  OrderPPCModel.fromJson(data['data']) ;
}