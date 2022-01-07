import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Function(SharedPreferences)> template(Function(SharedPreferences) callback) async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences storage = await SharedPreferences.getInstance();

  return callback(storage);
}

void saveString(String key, String value) async { await template((storage) => storage.setString(key, value)); }

void saveInt(String key, int value) async { await template((storage) => storage.setInt(key, value)); }

void saveBool(String key, bool value) async { await template((storage) => storage.setBool(key, value)); }

void saveStringList(String key, List<String> value) async { await template((storage) => storage.setStringList(key, value)); }

void saveJSONMap(String key, Map<String, dynamic> value) async { await template((storage) => storage.setString(key, value.toString()));}

void saveIntList(String key, List<int> value) async {
  await template((storage) {
    List<String> result = value.map((e) => e.toString()).toList();

    storage.setStringList(key, result);
    return result;
  });
}

Future<String> getString(String key) async {

  String result = "";

  await template((storage) {
    String? tmp = storage.getString(key);

    result = (tmp == null) ? '' : tmp;
  });

  return result;
}

Future<int> getInt(String key) async {

  int result = 0;

  await template((storage) {
    int? tmp = storage.getInt(key);

    result = (tmp == 0) ? 0 : 1;
  });

  return result;
}

Future<bool> getBool(String key) async {

  bool result = false;

  await template((storage) {
    bool? tmp = storage.getBool(key);

    result = (tmp == true);
  });

  return result;
}

Future<List<String>> getStringList(String key) async {

  List<String> result = [];

  await template((storage) {
    var tmp = storage.getStringList(key);

    result = (tmp == null) ? [] : tmp;
  });

  return result;
}

Future<Map<String, dynamic>> getJSONMap(String key) async {
  Map<String, dynamic> result = {};

  await template((storage) {
    var tmp = storage.getString(key);
    var object = (tmp == null) ? '{}' : storage.getString(key);

    result = jsonDecode(object.toString());
  });

  return result;
}

Future<List<int>> getIntList(String key) async {

  List<int> result = [];

  await template((storage) {
    List<String>? tmp = storage.getStringList(key);

    result = (tmp == null) ? [] : tmp.map((e) => int.parse('$e')).toList();

  });

  return result;
}

Future<bool> isSet(String key) async {
  bool result = false;

  await template((storage) {
    result = (storage.get(key) == null);
  });

  return result;
}
void clearCache() async {
  await template((storage) {
    storage.clear();
    print('[STORAGE] Cache successfully cleared');
  });
}