import 'dart:convert';
import '../models/Shop.dart';
import '../models/delivery.dart';
import '../models/product.dart';
import '../models/orderItemPPC.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' show Client;

import '../models/orderPPC.dart';
import '../service/UserData.dart';
import '../models/user.dart';

//final _root = 'https://secure-sea-91184.herokuapp.com/api/v1';
final _root = 'https://admin.ppc-drc.com/api/v1/';//http://192.168.43.62:8080/api/v1';

class GetGeoloc {
  UserModel userM = UserModel();
  UserData userD = UserData();
  String token;
  Client client = Client();

  

  updateMyLocation(Position geoloc) async {
    print('get start location update');

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

    final respDeliver = await client.get(
        'https://admin.ppc-drc.com/api/v1/deliverboy?userID=${userM.id}',
        headers: myhead);
   
    final deliverboy = json.decode(respDeliver.body);
   
     final deliverBoyId = deliverboy['data'][0]['_id'];
 
    final _data = jsonEncode({
      'locationHistorical': [
        {
          'longitude': geoloc.longitude,
          'latitude': geoloc.latitude,
          'created': DateTime.now()
        }
      ]
    });

    var response = await client.put(
        'https://admin.ppc-drc.com/api/v1/deliverboy/$deliverBoyId',
        headers: myhead,
        body: _data);

    final res = json.decode(response.body);
 
    if (res['success'].toString() == 'true') {
      return true;
    } else {
      return false;
    }
  }

 

   
  
}
