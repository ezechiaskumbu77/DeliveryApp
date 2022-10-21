import 'dart:convert';

import '../models/user.dart';
import '../ressources/localeDB.dart';


class UserData {

  UserModel user ;
  LocalDB db = LocalDB();

   isAuth() async {
    return  await  db.check('user');
  }
 void  logOut() async {
     await db.remove('user');
     await db.remove('token');
  }

  getUser() async   {

    var userGet = await db.read('user');
    user = UserModel.fromJson(jsonDecode(userGet));
    print('See see it ${user.name}');

    return user;

  }
  getToken() async   {

    var token = await db.read('token');


    return token;

  }



}
