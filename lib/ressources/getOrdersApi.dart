import 'dart:convert';

import '../models/Shop.dart';
import '../models/delivery.dart';
import '../models/product.dart';
import '../models/orderItemPPC.dart';
import 'package:http/http.dart' show Client;

import '../models/orderPPC.dart';
import '../service/UserData.dart';
import '../models/user.dart';

final _root = 'https://admin.ppc-drc.com/api/v1';
//final _root = 'http://192.168.43.62:8080/api/v1';

class GetOrder {
  UserModel userM = UserModel();
  UserData userD = UserData();
  String token;
  Client client = Client();

  fetchAll() async {
    bool isAuth = await userD.isAuth();

    if (!isAuth) {
      return null;
      // print('auth status: '+isAuth  );
    } else {
      userM = await userD.getUser();

      token = await userD.getToken();
      //print('authorization : ' + token);
    }

    final myhead = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': 'Bearer ' + token
    };

    final respDeliver = await client.get(
        '$_root/deliverboy?userID=${userM.id}',
        headers: myhead);

    final deliverboy = json.decode(respDeliver.body);
    final deliverBoyId = deliverboy['data'][0]['_id'];

    var response = await client.get(
        '$_root/delivery?DeliverdBy=${deliverBoyId}',
        headers: myhead);

    var res = json.decode(response.body);
    
    var listdeliveries = DeliveryModelFromJson(res['data']);

    for (var i = listdeliveries.length - 1; i >= 0; i--) {
        
        if(listdeliveries[i].orderId!=null)
        {

          response = await client.get('$_root/orderppc/'+listdeliveries[i].orderId, headers: myhead);

          var res = json.decode(response.body);

          listdeliveries[i].order = OrderPPCModel(
              id: res['data']['_id'],
              whenMade: res['data']['WhenMade'],
              customer: res['data']['customer'],
              status: res['data']['status'],
              deliverycode: res['data']['deliverCode'].toString(),
              deliverBoy: res['data']['deliverBoy'],
              deliverBoyConfirm: res['data']['deliverBoyConfirm'],
              shippingDate: res['data']['shippingDate'],
              deliveredDate: res['data']['deliveredDate'],
              shop: res['data']['shop'], //
              paymentMethode: res['data']['paymentMethode'], //
              isPayed: res['data']['IsPayed'], //
              totalPrice: double.parse(res['data']['totalPrice']
                  .toString()), //.toString().trim()).toString().trim())
              details: res['data']['details'], //
              shippingAdress: res['data']['shippingAdress'], //
              isDeleted: res['data']['isDeleted']);

          response = await client.get(
              '$_root/shop/' + listdeliveries[i].shopId,
              headers:
                  myhead); // 602a51ec331e900017b5db2d ${item.orderId} //602a51ec331e900017b5db2d

          res = json.decode(response.body);

          listdeliveries[i].shop = ShopModel(
              res['data']['name'],
              res['data']['shopOnwer'],
              res['data']['place'],
              res['data']['createdBy'],
              res['data']['capacity'],
              res['data']['address'],
              res['data']['isDeleted'],
              res['data']['id'],
              res['data']['description'],
              res['data']['shopManager'],
              res['data']['geoLoc']);
        }
    }

    listdeliveries.reversed;

    return listdeliveries;
  }

  fetchAllOrderPPCItem(orderId) async {
    // print('get all start orderitems ppc');
    bool isAuth = await userD.isAuth();

    if (!isAuth) {
      return null;
    } else {
      userM = await userD.getUser();

      token = await userD.getToken();
    }

    final myhead = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': 'Bearer ' + token
    };

    var response = await client.get(
        '$_root/orderitemppc/?orderID=${orderId}',
        headers: myhead);
    var res = json.decode(response.body);

    var listorderppcitems = OrderItemPPCodelFromJson(res['data']);

    /*for (var i = 0; i < listorderppcitems.length; i++) {
      response = await client.get(
          '$_root/product/' +
              listorderppcitems[i].productId,
          headers: myhead);

      var res = json.decode(response.body);

      listorderppcitems[i].product = res['data']['name'];
    }*/

    return listorderppcitems;
  }

  postOrder(OrderPPCModel orderP) async {
    bool isAuth = await userD.isAuth();

    if (!isAuth) {
      return null;
    } else {
      userM = await userD.getUser();

      token = await userD.getToken();
    }

    final myhead = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': 'Bearer ${token}'
    };
    orderP.customer = userM.id;
    final response = await client.post(
        '$_root/orderppc',
        headers: myhead,
        body: jsonEncode(orderP.toJson()));
    // print('see the orders ${response.body}');
    final res = json.decode(response.body);

    if (res['success']) {
      return OrderPPCModel.fromJson(res['data']);
    }
    return null;
  }

  decision(DeliveryModel _data, bool dec) async {
    print('get all start');
    bool isAuth = await userD.isAuth();
    print('is auth $isAuth');
    if (!isAuth) {
      return null;
    } else {
      userM = await userD.getUser();

      token = await userD.getToken();
    }

    final myhead = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': 'Bearer $token'
    };

    final response = await client.put(
        '$_root/delivery/${_data.id}',
        headers: myhead,
        body: jsonEncode({'accepted': dec}));

    final res = json.decode(response.body);

    if (res['success']) {
      var status = (dec == false) ? 'refused' : 'accepted';
      historical(status, _data.order.id);
      return true;
      /*response = await client.put(
          '$_root/orderppc/${_data.order.id}',
          headers: myhead,
          body: jsonEncode({'status': 'shiped'}));
      final res = json.decode(response.body);

      if (res['success']) {
        return true;
      } else {
        return false;
      }*/
    } else {
      return false;
    }
  }

  shiped(DeliveryModel _data) async {
    print('get all start');
    bool isAuth = await userD.isAuth();
    print('is auth $isAuth');
    if (!isAuth) {
      return null;
    } else {
      userM = await userD.getUser();

      token = await userD.getToken();
    }

    final myhead = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': 'Bearer $token'
    };

    final response = await client.put(
        '$_root/orderppc/${_data.order.id}',
        headers: myhead,
        body: jsonEncode({'status': 'shiped'}));
    final res = json.decode(response.body);

    if (res['success']) {
      historical('shiped', _data.order.id);
      return true;

      /*response = await client.put(
          '$_root/orderppc/${_data.order.id}',
          headers: myhead,
          body: jsonEncode({'status': 'shiped'}));
      final res = json.decode(response.body);

      if (res['success']) {
        return true;
      } else {
        return false;
      }*/
    } else {
      return false;
    }
  }

/*
     
     var _data = [
        {
          'status': 'shiped',
          'by': userM.id.toString(),
          'created': DateTime.now().toString()
        }
      ];

      final _datatojson = jsonEncode({'historical': _data});
     response = await client.put(
          '$_root/orderppc/${_data.order.id}',
          headers: myhead,
          body: jsonEncode({'status': 'shiped'}));
          
      final res = json.decode(response.body);

      if (res['success']) {
        return true;
      } else {
        return false;
      }
      
      */
  deliverede(String id, String delivercode) async {
    bool isAuth = await userD.isAuth();
    if (!isAuth) {
      return null;
    } else {
      userM = await userD.getUser();

      token = await userD.getToken();
    }

    final myhead = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': 'Bearer $token'
    };
    final response = await client.put(
        '$_root/orderppc/${id}',
        headers: myhead,
        body: jsonEncode({'status': 'delivered', 'delivercode': delivercode}));

    final res = json.decode(response.body);

    if (res['success']) {
      return true;
    } else {
      return false;
    }
  }

  historical(status, orderID) async {
    final bool isAuth = await userD.isAuth();
    print('is auth $isAuth');
    if (!isAuth) {
      return null;
    } else {
      userM = await userD.getUser();

      token = await userD.getToken();
    }

    final myhead = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': 'Bearer ${token}'
    };

    // orderppcP.byUser = userM.id;

    var response = await client.get(
        '$_root/orderppc/' + orderID,
        headers: myhead);
    // print('see the orderppcs ${response.body}');

    var res = json.decode(response.body);
    //  print(res);

    final historicalList = res['data']['historical'];
    print(historicalList);

    if (historicalList != null) {
      var _data = [
        {
          'status': status.toString(),
          'by': userM.id,
          'created': DateTime.now().toString()
        }
      ];

      for (var item in historicalList) {
        _data.add({
          'body': item['status'],
          'by': item['by'],
          'created': item['created']
        });
      }

      //historicalList.add({'body': message.toString(), 'by': 'Moi'});

      //     _data = jsonEncode({'messages': _data});

      final _datatojson = jsonEncode({'historical': _data});

      print('order ID : ' + orderID);

      response = await client.put(
          '$_root/orderppc/' + orderID,
          headers: myhead,
          body: _datatojson);

      print('see the orderppcs ${response.body}');

      res = json.decode(response.body);

      if (res['success'] == true || res['success'] == 'true') {
        return true;
      }
      return false;
    } else {
      var _data = [
        {
          'status': status.toString(),
          'by': userM.id,
          'created': DateTime.now().toString()
        }
      ];

      final _datatojson = jsonEncode({'messages': _data});

      print('orderID : ' + orderID);

      response = await client.put(
          '$_root/orderppc/' + orderID,
          headers: myhead,
          body: _datatojson);

      print('see the orderppcs ${response.body}');

      res = json.decode(response.body);

      if (res['success'] == true || res['success'] == 'true') {
        return true;
      }
      return false;
    }
  }

  issue(DeliveryModel _data) async {
    bool isAuth = await userD.isAuth();

    if (!isAuth) {
      return null;
    } else {
      userM = await userD.getUser();

      token = await userD.getToken();
    }

    final myhead = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': 'Bearer $token'
    };

    var response = await client.put(
        '$_root/delivery/${_data.id}',
        headers: myhead,
        body: jsonEncode({
          'delivery': {'isIssue': true}
        }));
    var res = json.decode(response.body);
    if (res['success']) {
      response = await client.put(
          '$_root/orderppc/${_data.order.id}',
          headers: myhead,
          body: jsonEncode({'status': 'issue'}));

      res = json.decode(response.body);

      if (res['success']) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  delivered(String id) async {
    bool isAuth = await userD.isAuth();

    if (!isAuth) {
      return null;
    } else {
      userM = await userD.getUser();

      token = await userD.getToken();
    }

    final myhead = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': 'Bearer $token'
    };

    final response = await client.put(
        '$_root/orderppc/${id}',
        headers: myhead,
        body: jsonEncode({'deliverBoyConfirm': true, 'isDelivered': true}));

    final res = json.decode(response.body);

    if (res['success']) {
      historical('delivered', id);
      return true;
    } else {
      return false;
    }
  }

  confirm(String id, String code) async {
    bool isAuth = await userD.isAuth();

    if (!isAuth) {
      return null;
    } else {
      userM = await userD.getUser();

      token = await userD.getToken();
    }

    final myhead = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': 'Bearer $token'
    };

    final response = await client.put(
        '$_root/orderppc/${id}',
        headers: myhead,
        body: jsonEncode({'deliverCode': code}));

    final res = json.decode(response.body);

    if (res['success']) {
      historical('veirfying code', id);
      return true;
    } else {
      return false;
    }
  }

  fetchOne(String id, String token) async {
    final myhead = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': 'Bearer $token'
    };

    final response = await client
        .get('$_root/shop/$id', headers: myhead);
    final res = json.decode(response.body);

    if (res['success']) {
      return OrderPPCModel.fromJson(res.data);
    } else {
      return null;
    }
  }
}
