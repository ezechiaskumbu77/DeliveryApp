import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../ressources/localeDB.dart';
import '../models/user.dart';

final String BASE_URL = 'https://admin.ppc-drc.com/api/v1/';
//final _root = 'https://secure-sea-91184.herokuapp.com/api/v1';
final _root = 'https://admin.ppc-drc.com/api/v1';
final String LOGIN_URL = 'auth/login';

class AuthService {
  LocalDB db = LocalDB();
  Dio dio = new Dio();

  login(email, password) async {
    try {
      final response = await dio.post(
          'https://admin.ppc-drc.com/api/v1/auth/login',
          data: {'email': email, 'password': password});
      if (response.data['success']) {
        print(response.data['user']);
        await db.save('token', response.data['token']);
        await db.saveJson('user', response.data['user']);
        var lol = await db.read('user');

        print('see the data $lol');
        UserModel uu = UserModel.fromJson(jsonDecode(lol));

        print('Seee the name ${uu.name}');

        return true;
      }

      return false;
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: e.response == null
              ? 'Activer votre connexion'
              : e.response.data['error'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  create(UserModel userMM) async {
    try {
      final response = await dio.post(
          'https://admin.ppc-drc.com/api/v1/authm/register',
          data: {
            'name': userMM.name,
            'birthday': userMM.birthday,
            'sexe': userMM.sexe,
            'address': userMM.address,
            'phone': userMM.phone,
            'hasShop': false,
            'isShopmanager': false,
            'isDeliverCorp': false,
            'isDeliverBoy': true
          });
      if (response.data['success']) {

        print('see the data ${response.data}');
        var isDeliverCorp = (response.data['user']['isDeliverCorp'] == false || response.data['user']['isDeliverCorp'] == 'false') ? false  : true;
        await db.save('isDeliverCorp', isDeliverCorp.toString());
        await db.save('id', response.data['user']['_id']);

        print(response.data['user']);
        await db.save('token', response.data['token']);
        await db.saveJson('user', response.data['user']);
        var lol = await db.read('user');

        print('see the data $lol');
        UserModel uu = UserModel.fromJson(jsonDecode(lol));

        print('Seee the name ${uu.name}');

        return true;
      }

      return false;
    } on DioError catch (e) {
      print('see the data ${e.response.data}');
      Fluttertoast.showToast(
          msg: e.response == null
              ? 'Activer votre connexion'
              : e.response.data['error'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  createPhone(phone) async {
    try {
      final response = await dio.post(
          'https://admin.ppc-drc.com/api/v1/authm/find/',
          data: {
            'phone': phone,
          });

      if (response.data['success']) {
        //    print( response.data['success']) ;
        var isDeliverCorp = (response.data['user']['isDeliverCorp'] == false || response.data['user']['isDeliverCorp'] == 'false') ? false  : true;
        await db.save('isDeliverCorp', isDeliverCorp.toString());
        await db.save('id', response.data['user']['_id']);

        Fluttertoast.showToast(
            msg: 'Le numéro entré est déjà enregistré ',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return {'success': true, 'find': true, 'error': false};

        // return true ;

      }

      return {'success': false, 'find': false, 'error': false};
    } on DioError catch (e) {
      if (e.response.statusCode != 404) {
        Fluttertoast.showToast(
            msg: e.response == null
                ? 'Activer votre connexion'
                : e.response.data['error'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        return {'success': false, 'find': false, 'error': false};
      } else {
        Fluttertoast.showToast(
            msg: 'Le numéro n\'est pas enregistré',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return {'success': true, 'find': false, 'error': false};
      }

      // if(e.response.statusCode == 404)

    }
  }

  sendSms(phone) async {
    try {
      final response = await dio.post(
          'https://admin.ppc-drc.com/api/v1/authm/find/',
          data: {
            'phone': phone,
          });

      if (response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: 'Le numéro n\'est pas enregistré',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return false;
      }

      if (response.data['success'] &&
          (response.data['user']['isDeliverCorp'] ||
              response.data['user']['isDeliverBoy'])) {
        //    print( response.data['success']) ;
        var isDeliverCorp = (response.data['user']['isDeliverCorp'] == false || response.data['user']['isDeliverCorp'] == 'false') ? false  : true;

        await db.save('isDeliverCorp', isDeliverCorp.toString());

        await db.save('id', response.data['user']['_id']);
        Fluttertoast.showToast(
            msg: 'Connexion reussie',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        return true;
      } else if (response.data['success'] &&
          !(response.data['user']['isDeliverCorp'] ||
              response.data['user']['isDeliverBoy'])) {
        Fluttertoast.showToast(
            msg:
                'L\'utilisateur entree n\'est pas un Delivercorp ni un Deliverboy',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return false;
      }

      return false;
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: e.response == null
              ? 'Activer votre connexion'
              : e.response.data['error'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  authPhone(code) async {
    try {
      var id = await db.read('id');
      print('see your id ${id}');

      final response = await dio.post(
          'https://admin.ppc-drc.com/api/v1/authm/verify/${id}',
          data: {'pinCode': int.parse(code)});
      if (response.statusCode == 400) {
        Fluttertoast.showToast(
            msg: 'Le code est incorrect',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        return false;
      }

      if (response.data['success']) {
        Fluttertoast.showToast(
            msg: 'Connexion reussie',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        print(response.data['success']);
        await db.save('token', response.data['token']);
        await db.saveJson('user', response.data['user']);
        var lol = await db.read('user');

        //print('see the data $lol');
        UserModel uu = UserModel.fromJson(jsonDecode(lol));

        print('Seee the name ${uu.name}');

        return true;
      }

      return false;
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: e.response == null
              ? 'Activer votre connexion'
              : e.response.data['error'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  addUser(email, password, sexe, phone, name, adress) async {
    try {
      return await dio.post(
          'https://admin.ppc-drc.com/api/v1/auth/register',
          data: {
            'email': email,
            'password': password,
            'name': name,
            'phone': phone,
            'sexe': sexe == 1 ? 'M' : 'F',
            'adress': adress,
            'isDeliverBoy': true,
            'isShopmanager': false,
            'hasShop': false,
            'isDeliverCorp': false,
          });
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: e.response.data['error'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  getInfo(token) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      return await dio
          .get('https://admin.ppc-drc.com/api/v1/auth/me');
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: e.response.data['error'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
