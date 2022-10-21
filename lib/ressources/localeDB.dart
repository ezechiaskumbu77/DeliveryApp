import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:delivery_template/model/notification.dart';
import 'package:delivery_template/ressources/localeDB.dart';

import '../models/user.dart';

class LocalDB {

  readJson(String key) async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString(key));
    return json.decode(prefs.getString(key));

  }

  saveJson(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }




  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    print('see your $value');
  }



  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
  check(String key ) async {
    final prefs = await SharedPreferences.getInstance();
    bool CheckValue = prefs.containsKey(key);

    return CheckValue;
  }


}