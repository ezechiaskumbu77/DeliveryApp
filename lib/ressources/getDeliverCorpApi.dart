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

class GetDeliverCorp {
  UserModel userM = UserModel();
  UserData userD = UserData();
  String token;
  Client client = Client();

 
 
  getDeliverCorpID() async {
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

    //print('delivercorp request by userID:${userM.id}');
    final respDeliver = await client.get(
        'https://admin.ppc-drc.com/api/v1/delivercorp?userID=${userM.id}',
        headers: myhead);

    final delivercorp = json.decode(respDeliver.body);

    final delivercorpId = delivercorp['data'][0]['_id'];

    return delivercorpId;
  }

  getZoneList(id) async {
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
      'authorization': 'Bearer $token'
    };

    var response = await client.get('https://admin.ppc-drc.com/api/v1/delivercorp/' + id,  headers: myhead);

    var res = json.decode(response.body);

    final zoneListJson = res['data']['zone'];

    print(zoneListJson);

    if (zoneListJson != null) {
       
       var zoneList= <ZoneModel>[];
      for (var i = 0; i < zoneListJson.length; i++) {

          if(zoneListJson[i]['_id']!=null)
          {
            response = await client.get('https://admin.ppc-drc.com/api/v1/zone/' + zoneListJson[i]['_id'],  headers: myhead);


            res = json.decode(response.body); 
            final zone=  res['data']['zone'];
            zoneList.add(ZoneModel(zone['name'], null,zone['_id']));


          
              }

          
        }

        
    }
    return ;
  }
  suppressZone(zone, id) async {
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
      'authorization': 'Bearer $token'
    };

    var response = await client.get(
        'https://admin.ppc-drc.com/api/v1/delivercorp/' + id,
        headers: myhead);

    var res = json.decode(response.body);
    final zoneList = res['data']['zone'];

    print(zoneList);

    if (zoneList != null) {
      var _data = [];

      for (var item in zoneList) {
        _data.add(item['_id']);
      }
      _data.remove(zone);

      final _datatojson = jsonEncode({'zone': _data});

      response = await client.put(
          'https://admin.ppc-drc.com/api/v1/delivercorp/' + id,
          headers: myhead,
          body: _datatojson);

      print('see the zones ${response.body}');

      res = json.decode(response.body);

      if (res['success'] == true || res['success'] == 'true') {
        return true;
      }
      return false;
    } else {
      var _data = [zone];

      final _datatojson = jsonEncode({'zone': _data});

      print('_datatojson : ' + _datatojson);

      response = await client.put(
          'https://admin.ppc-drc.com/api/v1/delivercorp/' + id,
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

  addZone(zone, id) async {
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
      'authorization': 'Bearer $token'
    };

    var response = await client.get(
        'https://admin.ppc-drc.com/api/v1/delivercorp/' + id,
        headers: myhead);

    var res = json.decode(response.body);
    final zoneList = res['data']['zone'];

    print(zoneList);

    if (zoneList != null) {
      var _data = [zone];

      for (var item in zoneList) {

        if(zone!=item['_id'])
        _data.add(item['_id']);

      }

      final _datatojson = jsonEncode({'zone': _data});

      response = await client.put(
          'https://admin.ppc-drc.com/api/v1/delivercorp/' + id,
          headers: myhead,
          body: _datatojson);

      print('see the zones ${response.body}');

      res = json.decode(response.body);

      if (res['success'] == true || res['success'] == 'true') {
        return true;
      }
      return false;
    } else {
      var _data = [zone];

      final _datatojson = jsonEncode({'zone': _data});

      print('orderID : ' + id);

      response = await client.put(
          'https://admin.ppc-drc.com/api/v1/delivercorp/' + id,
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
}
