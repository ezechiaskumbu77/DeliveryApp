import 'dart:convert';
 
import 'package:delivery_template/models/delivercar.dart';
import 'package:http/http.dart' show Client;

import '../service/UserData.dart';
import '../models/user.dart';

//final _root = 'https://secure-sea-91184.herokuapp.com/api/v1';
//final _root = "https://secure-sea-91184.herokuapp.com/api/v1";
// final _root = 'http://192.168.1.163:8080/api/v1';
final root = 'https://admin.ppc-drc.com/api/v1';
//final _root = 'http://192.168.43.62:8080/api/v1';

class GetDeliverCar {
  UserModel userM = UserModel();
  UserData userD = UserData();
  String token;
  Client client = Client();

  fetchAll() async {
    // print('get all delivercar');
    final bool isAuth = await userD.isAuth();
    // print('is auth $isAuth');
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

    final response =
        await client.get('$root/delivercar/?createdBy=${userM.id}', headers: myhead);
    // print('see the delivercars ${response.body}');
    final res = json.decode(response.body);

    if (res['success']) {
         return DeliverCarModel.fromJson(res.data);
    } else {
         return null;
    }
    /*var listdelivercars = <DeliverCarModel>[];

    if (res['success'] && (res['count'] >= 1)) {
      //return DeliverCarModelFromJson(res['data']);
      final delivercarListjson = res['data'];
      // print(delivercarListjson);
      //  for (var shop in respShopJson['data']) {
      for (var j = delivercarListjson.length - 1; j >= 0; j--) {
        //  print(delivercarListjson[j]);

        var qualificationBody;
        
        //   print(delivercarListjson[j]['delivercar']['evaluation']);
        var item = DeliverCarModel(
          edited: delivercarListjson[j]['edited'],
          createdBy: userM
              .id, //  (delivercarListjson[j]['createdBy']!=null)? delivercarListjson[j]['createdBy'] : 'nothing',
          orderId: (delivercarListjson[j]['orderId'] != null)
              ? delivercarListjson[j]['orderId']
              : 'nothing',
          id: delivercarListjson[j]['_id'],
          qualificationId: delivercarListjson[j]['qualificationId'],
          qualificationBody: qualificationBody,
          whenMade: delivercarListjson[j]['whenMade'],
          status: delivercarListjson[j]['status'],
          messages: null, //delivercarListjson[j]['messages']
        );
        listdelivercars.add(item);
      }
    }
    return listdelivercars;*/
  }

  fetchHistoryByDeliverCar(delivercar) async {
    // print('get all start');
    final bool isAuth = await userD.isAuth();
    // print('is auth $isAuth');

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

    final response = await client.get('$root/delivercar/' + delivercar.id, headers: myhead);
    // print('see the delivercars ${response.body}');

    final res = json.decode(response.body);
    //  print(res);

    final messageList = res['data']['historical'];
    print(messageList);
    //if (messageList!=null) {
    return messageList; //delivercarModelFromJson(res['data']);
    //}
    //return null;
  }

  postDeliverCar(DeliverCarModel delivercarP) async {
    // print('get start post');
    final bool isAuth = await userD.isAuth();
    // print('is auth $isAuth');

    if (!isAuth) {
      return null;
      // token =
      //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwMjViYzVmODM2YjU0MDAxNzAyNDI5MSIsImlhdCI6MTYxNTIxNDM4MSwiZXhwIjoxNjE3ODA2MzgxfQ.HQBLyysXF_FRYq2ECkg8CKKLoh5utL_ohPYal7BZ2mI';
    } else {
      userM = await userD.getUser();

      token = await userD.getToken();
    }

    final myhead = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': 'Bearer ${token}'
    };
    delivercarP.createdBy = userM.id;

    //  print(delivercarP.qualificationBody.evaluation);

    final response = await client.post('$root/delivercar/', headers: myhead, body: jsonEncode(delivercarP.toJson()));

    // print('see the delivercars ${response.body}');

    final res = json.decode(response.body);

    if (res['success']) {

      historical('opened', res['data']['_id'].toString());
      return true;

    }

    return false;
  }

  historical(deliveryID,  feetID) async {
    final bool isAuth = await userD.isAuth();
    // print('is auth $isAuth');
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

    // orderppcP.createdBy = userM.id;

    var response = await client.get('$root/delivercar/' + feetID, headers: myhead);
   
    var res = json.decode(response.body);
    
    final historicalList = res['data']['historical'];
    // print(historicalList);

    if (historicalList != null) {

      var _data = [
        {'delivery':deliveryID, 'created': DateTime.now().toString()}
      ];

      for (var item in historicalList) {
        _data.add({'status': item['status'], 'created': item['created']});
      }

      
      final _datatojson = jsonEncode({'historical': _data});

      // print('delivercar ID : ' + id);

      response =
          await client.put('$root/delivercar/' + feetID, headers: myhead, body: _datatojson);

      // print('see the orderppcs ${response.body}');

      res = json.decode(response.body);

      if (res['success'] == true || res['success'] == 'true') {
        return true;
      }
      return false;
    } else {
      var _data = [
        {'delivery': deliveryID.toString(), 'created': DateTime.now().toString()}
      ];

      final _datatojson = jsonEncode({'historical': _data});

      // print('id : ' + id);

      response =
          await client.put('$root/delivercar/' + feetID, headers: myhead, body: _datatojson);

      // print('see the orderppcs ${response.body}');

      res = json.decode(response.body);

      if (res['success'] == true || res['success'] == 'true') {
        return true;
      }
      return false;
    }
  }

  delivercarAttributeToDeliverboy(DeliverCarModel delivercarP, message) async {
    final bool isAuth = await userD.isAuth();
    // print('is auth $isAuth');
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

    delivercarP.createdBy = userM.id;

    var response = await client.get('$root/delivercar/' + delivercarP.id, headers: myhead);
    // print('see the delivercars ${response.body}');

    var res = json.decode(response.body);
    //  print(res);

    final messageList = res['data']['historical'];
    print(messageList);

    if (messageList != null) {
      var _data = [
        {
          'body': message.toString(),
          'by': 'Moi',
          'created': DateTime.now().toString()
        }
      ];

      for (var item in messageList) {
        _data.add({
          'body': item['body'],
          'by': item['by'],
          'created': item['created']
        });
      }
 

      final _datatojson = jsonEncode({'historical': _data});

      // print('delivercar ID : ' + delivercarP.id);

      response = await client.put('$root/delivercar/' + delivercarP.id,
          headers: myhead, body: _datatojson);

      // print('see the delivercars ${response.body}');

      res = json.decode(response.body);

      if (res['success'] == true || res['success'] == 'true') {
        return true;
      }
      return false;
    } else {
      var _data = [
        {
          'body': message.toString(),
          'by': 'Moi',
          'created': DateTime.now().toString()
        }
      ];

      final _datatojson = jsonEncode({'historical': _data});

      // print('delivercar ID : ' + delivercarP.id);

      response = await client.put('$root/delivercar/' + delivercarP.id,
          headers: myhead, body: _datatojson);

      // print('see the delivercars ${response.body}');

      res = json.decode(response.body);

      if (res['success'] == true || res['success'] == 'true') {
        return true;
      }
      return false;
    }
  }

  fetchOne(String id, String token) async {
    final myhead = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': 'Bearer $token'
    };

    final response = await client.get('$root/delivercar/$id', headers: myhead);
    final res = json.decode(response.body);

    if (res['success']) {
      return DeliverCarModel.fromJson(res.data);
    } else {
      return null;
    }
  }
}
