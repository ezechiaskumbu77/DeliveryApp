import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../model/notification.dart';
import '../service/UserData.dart';
import '../models/user.dart';

//final _root = 'https://secure-sea-91184.herokuapp.com/api/v1';
final _root = 'https://admin.ppc-drc.com/api/v1';

class GetNotification {
  UserModel userM = UserModel();
  UserData userD = UserData();
  String token;
  Client client = Client();

  updateReadState(unreadNotifs) async {

    bool isAuth = await userD.isAuth();

    if (!isAuth) {
      return null;
    } else {
      userM = await userD.getUser();
      token = await userD.getToken();
      // print('authorization : ' + token);
    }

    final myhead = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': 'Bearer ' + token
    };

    
    for (var item in unreadNotifs) {

      final response = await client.get('$_root/notification/'+item['_id'],  headers: myhead);
      
    }


  
  }
  getUnreadNotifations() async {
    bool isAuth = await userD.isAuth();

    if (!isAuth) {
      return null;
    } else {
      userM = await userD.getUser();
      token = await userD.getToken();
      // print('authorization : ' + token);
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

    final response = await client.get(
        '$_root/notification?DeliverdBy=${deliverBoyId}&viewed=false',  headers: myhead);

    var count = 0;
    final res = json.decode(response.body);
    final notifs = res['data'];
    for (var item in notifs) {


      if (item['viewed'] == false || item['viewed'] == "false") {
        count++;
      }
    }


    return notifs;
  }

  fetchAll() async {
    bool isAuth = await userD.isAuth();

    if (!isAuth) {
      return null;
    } else {
      userM = await userD.getUser();
      token = await userD.getToken();
      // print('authorization : ' + token);
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

    final response = await client.get(
        '$_root/notification?DeliverdBy=${deliverBoyId}',
        headers: myhead);

    final res = json.decode(response.body);

    var listnotifications = NotificationModelFromJson(res['data']);

    listnotifications.reversed;

    return listnotifications;
  }
}
