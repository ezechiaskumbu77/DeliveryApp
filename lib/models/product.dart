
import 'dart:convert';

// class Price {
//   final int usd;
//   final int fc ;
//
//   Price(this.usd, this.fc);
//
//   Price.fronJson(Map<String, dynamic> parsedJson):
//   usd = parsedJson['usd'],
//   fc = parsedJson['fc'];
//
// }



class ProductModel {
  String name ;
  String description;
  String photoUrl ;
  var price ;
   bool isAvailable;
   bool isDeleted;
    String id ;

  ProductModel({this.name, this.description, this.photoUrl, this.price,
      this.isAvailable, this.isDeleted, this.id});


  ProductModel.fromJson(Map<dynamic, dynamic> parsedJson)
      :
    name = parsedJson['name'],
    description = parsedJson['description'],
     photoUrl ='',// parsedJson['photoUrl'],
   price = double.parse(parsedJson['price']),

    isDeleted = parsedJson['isDeleted'],
    isAvailable = parsedJson['isAvailable'],
    id = parsedJson['_id'];


  Map<String,dynamic> toJson() {

    return <String,dynamic> {
     'name' : name,
      'description' : description,
      'photoUrl' : photoUrl,
        'price' : price,
       'isDeleted' : isDeleted,
      'isAvailable': isAvailable,
      '_id' : id

    };
  }



}


List<ProductModel> ProductModelFromJson( dynamic jsonData) {
  // print('Strat here ${jsonData}');
  // final data = jsonDecode(jsonData);
  List<ProductModel> listAll = List<ProductModel>.from(jsonData.map( (item){
    print('see data ${item}');
    ProductModel prod = ProductModel.fromJson(item);
     print('see data '+ prod.description);
    //   print('done ${order.paymentMethode}');
    return prod;

    } ) );
//  print('russell voici ${data['data']}');

  print('All are Success');
  return listAll;
}

ProductModel OneProductModelFromJson( dynamic jsonData) {
  final data = json.decode(jsonData);

//  print('russell voici ${data['data']}');
  return  ProductModel.fromJson(data['data']) ;
}