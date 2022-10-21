import 'geolocator.dart';
import 'orderdetails.dart';

class Order {
  String id;
  String date;
  String currency;
  double summa;
  String method; // cache on delivery
  int distance; // in meters
  String address1;
  String address2;
  int status; // 0 receiver, 1 preparing, 2 ready, 3 on the way, 4 delivered
  double address1Latitude;
  double address1Longitude;
  double address2Latitude;
  double address2Longitude;
  String customerName;
  String phone;
  double fee;
  double tax;
  double total;
  List<OrderDetails> orderDetails;
  String driverId;

  Order({this.id, this.date, this.currency, this.summa, this.method, this.distance,
    this.address1, this.address2, this.status = 0,
    this.address1Latitude, this.address1Longitude,
    this.address2Latitude, this.address2Longitude,
    this.phone, this.customerName, this.orderDetails, this.fee, this.tax, this.total,
    this.driverId = ''
  });
}

ordersSetDistance() async {
  var location = Location();
  for (var item in orders){
    double distance = await location.distanceBetween(item.address1Latitude, item.address1Longitude,
        item.address2Latitude, item.address2Longitude);
    item.distance = distance.toInt();
  }
}

var orders = [
  Order(id: '212', date: '2020-07-08 12:35', currency: '\$', summa: 212.23, method: 'Payement à la livraison', distance: 0,
    address1: 'Parc virunga 16 , Righini lemba Kinshasa, RDC',
    address1Latitude: 48.895605, address1Longitude: 2.087823,
    address2: 'Beni 29 , Righini lemba Kinshasa, RDC',
    address2Latitude: 48.897379, address2Longitude: 2.094781,
    status: 1,
    phone: '+243811960037', customerName: 'Jbsy Bonsuka',
    fee: 2.35, tax: 2.35, total: 23.55-4.7,
    orderDetails: [
      OrderDetails(id: '118',
          date: '2020-09-26 12:38:06',
          foodName: 'Surecast',
          count : 1,
          foodPrice : 8.89,
          extras: '',
          extrasCount: 0,
          extrasPrice: 0.0,
          image: 'https://store.ppc.co.zw/wp-content/uploads/2020/07/328221-324x474.png'),
      OrderDetails(id: '119',
          date: '2020-09-26 12:38:06',
          foodName: 'Surecem',
          count : 2,
          foodPrice : 7.33,
          extras: '',
          extrasCount: 0,
          extrasPrice: 0.0,
          image: 'https://ppc-jhb-web.azureedge.net/website/attachments/cjp2enumr019u0fqtwjfr3amx-surecem.full.png'),
    ],
  ),
  Order(id: '213', date: '2020-07-08 13:33', currency: '\$', summa: 156.08, method: 'Cache on Delivery', distance: 0,
    address1: '15 kwilu , C/Ngaba , Kinshasa , RDC',
    address1Latitude: 48.851332, address1Longitude: 2.636826,
    address2: '15 kwilu , C/Ngaba , Kinshasa , RDC',
    address2Latitude: 48.850905, address2Longitude: 2.344964,
    status: 2,
    phone: '+24381897647738', customerName: 'Ikoli bombeli',
    fee: 2.35, tax: 2.35, total: 23.55-4.7,
    orderDetails: [
      OrderDetails(id: '118',
          date: '2020-09-26 12:38:06',
          foodName: 'Surecast',
          count : 1,
          foodPrice : 8.89,
          extras: '',
          extrasCount: 0,
          extrasPrice: 0.0,
          image: 'https://store.ppc.co.zw/wp-content/uploads/2020/07/328221-324x474.png'),
      OrderDetails(id: '119',
          date: '2020-09-26 12:38:06',
          foodName: 'Surecem',
          count : 2,
          foodPrice : 7.33,
          extras: '',
          extrasCount: 0,
          extrasPrice: 0.0,
          image: 'https://ppc-jhb-web.azureedge.net/website/attachments/cjp2enumr019u0fqtwjfr3amx-surecem.full.png'),
    ],
  ),
  Order(id: '214', date: '2020-07-08 13:33', currency: '\$', summa: 156.08, method: 'Cache on Delivery', distance: 0,
    address1: 'Justice 24 , Gombe , Kinshasa , RDC',
    address1Latitude: 48.895605, address1Longitude: 2.087823,
    address2: '',
    address2Latitude: 48.897379, address2Longitude: 2.094781,
    status: 3,
    phone: '+243974007720', customerName: 'Laurent kasongo',
    fee: 2.35, tax: 2.35, total: 23.55-4.7,
    orderDetails: [
      OrderDetails(id: '118',
          date: '2020-09-26 12:38:06',
          foodName: 'Surecast',
          count : 1,
          foodPrice : 8.89,
          extras: '',
          extrasCount: 0,
          extrasPrice: 0.0,
          image: 'https://store.ppc.co.zw/wp-content/uploads/2020/07/328221-324x474.png'),
      OrderDetails(id: '119',
          date: '2020-09-26 12:38:06',
          foodName: 'Surecem',
          count : 2,
          foodPrice : 7.33,
          extras: '',
          extrasCount: 0,
          extrasPrice: 0.0,
          image: 'https://ppc-jhb-web.azureedge.net/website/attachments/cjp2enumr019u0fqtwjfr3amx-surecem.full.png'),
    ],
  ),
  Order(id: '215', date: '2020-07-08 15:06', currency: '\$', summa: 246.19, method: 'Cache on Delivery', distance: 0,
    address1: 'luvu 13 , super lemba , kinshasa RDC',
    address1Latitude: 48.87641, address1Longitude: 2.514941,
    address2: '',
    address2Latitude: 48.83981, address2Longitude:  2.519061,
    status: 4,
    phone: '+243974607630', customerName: 'Marthe Miaka',
    fee: 2.35, tax: 2.35, total: 23.55-4.7,
    orderDetails: [
      OrderDetails(id: '118',
          date: '2020-09-26 12:38:06',
          foodName: 'Surecast',
          count : 1,
          foodPrice : 8.89,
          extras: '',
          extrasCount: 0,
          extrasPrice: 0.0,
          image: 'https://store.ppc.co.zw/wp-content/uploads/2020/07/328221-324x474.png'),
      OrderDetails(id: '119',
          date: '2020-09-26 12:38:06',
          foodName: 'Surecem',
          count : 2,
          foodPrice : 7.33,
          extras: '',
          extrasCount: 0,
          extrasPrice: 0.0,
          image: 'https://ppc-jhb-web.azureedge.net/website/attachments/cjp2enumr019u0fqtwjfr3amx-surecem.full.png'),
    ],
  ),
  Order(id: '216', date: '2020-07-08 16:56', currency: '\$', summa: 187.19, method: 'Cache on Delivery', distance: 0,
    address1: '1 rue 30, Limete kinshasa, RDC',
    address1Latitude: 48.834559, address1Longitude: 2.362763,
    address2: 'Avenue de la République 30 , Gombe kinshasa, RDC',
    address2Latitude: 48.865071, address2Longitude: 2.375525,
    status: 0,
    phone: '+243907049834', customerName: 'Gauis Mulombo',
    fee: 2.35, tax: 2.35, total: 23.55-4.7,
    orderDetails: [
      OrderDetails(id: '118',
          date: '2020-09-26 12:38:06',
          foodName: 'Surecast',
          count : 1,
          foodPrice : 8.89,
          extras: '',
          extrasCount: 0,
          extrasPrice: 0.0,
          image: 'https://store.ppc.co.zw/wp-content/uploads/2020/07/328221-324x474.png'),
      OrderDetails(id: '119',
          date: '2020-09-26 12:38:06',
          foodName: 'Surecem',
          count : 2,
          foodPrice : 7.33,
          extras: '',
          extrasCount: 0,
          extrasPrice: 0.0,
          image: 'https://ppc-jhb-web.azureedge.net/website/attachments/cjp2enumr019u0fqtwjfr3amx-surecem.full.png'),
    ],
  ),
];

