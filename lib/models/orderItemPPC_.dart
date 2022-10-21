
import 'dart:convert';

import 'product.dart';
class OrderItemPPC {

 String orderID ;
 String productId;
 ProductModel product ;
 int quantity;
 double price;
 String id ;


OrderItemPPC({this.orderID, this.product, this.quantity, this.price, this.id});


OrderItemPPC.fromJson(Map<String, dynamic> parsedJson):
    id = parsedJson['_id'],
    orderID = parsedJson['orderID'],
      product = ProductModel.fromJson(parsedJson['product']),
      quantity = parsedJson['quantity'],
      price = parsedJson['price'].toDouble();




Map<String,dynamic> toJson() {

  return <String,dynamic> {

    "orderID": orderID,
    "product": productId ,
    "quantity": quantity,
    "price": price

  };
}

}


List<OrderItemPPC> OrderItemPPCodelFromJson( dynamic jsonData) {
  // print("Strat here ${jsonData}");
  // final data = jsonDecode(jsonData);
  print("Here we start");
  List<OrderItemPPC> listAll = List<OrderItemPPC>.from(jsonData.map( (item){
     print("see data $item");
    OrderItemPPC order = OrderItemPPC.fromJson(item);
    print("after see ");
    //   print("done ${order.paymentMethode}");
    return order ;
  }
    ) );
//  print("russell voici ${data['data']}");

  print("All are item is ok and  Success");
  print("See it ${listAll[0].price}");
  return listAll;
}

OrderItemPPC OneOrderItemPPCModelFromJson( dynamic jsonData) {
  final data = json.decode(jsonData);

//  print("russell voici ${data['data']}");
  return  OrderItemPPC.fromJson(data['data']) ;
}