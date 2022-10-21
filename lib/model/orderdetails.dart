class OrderDetails {
  String id;
  String date;
  String foodName;
  int count;
  double foodPrice;
  String extras;
  int extrasCount;
  double extrasPrice;
  String image;

  OrderDetails({this.id, this.date, this.foodName, this.count,
    this.foodPrice, this.extras,
    this.extrasCount, this.extrasPrice, this.image,
  });
}