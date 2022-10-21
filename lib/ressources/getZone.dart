import 'dart:convert';

import 'package:delivery_template/models/deliveryboy.dart';
import 'package:delivery_template/models/zone.dart';

import '../models/Shop.dart';
import '../models/product.dart';
import '../models/orderItemPPC.dart';
import 'package:http/http.dart' show Client;

import '../models/orderPPC.dart';
import '../service/UserData.dart';
import '../models/user.dart';

// final _root = 'https://secure-sea-91184.herokuapp.com/api/v1';
////final _root = 'http://192.168.43.62:8080/api/v1';
final _root = 'admin.ppc-drc.com/api/v1/'; //http://192.168.1.163:8080/api/v1';

class GetZone {
  UserModel userM = UserModel();
  UserData userD = UserData();
  String token;
  Client client = Client();

   

  getZoneList() async {
    final isAuth = await userD.isAuth();
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

    var response = await client
        .get('https://admin.ppc-drc.com/api/v1/zone', headers: myhead);

    var res = json.decode(response.body);

    final list = ZoneModelFromJson(res['data']);

    list.reversed;

    return list;
  }

  GetZoneID() async {
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

    //print('deliverboy request by userID:${userM.id}');
    final respDeliver = await client.get(
        'https://admin.ppc-drc.com/api/v1/deliverboy?userID=${userM.id}',
        headers: myhead);

    final deliverboy = json.decode(respDeliver.body);

    final deliverBoyId = deliverboy['data'][0]['_id'];

    return deliverBoyId;
  }
 
}
