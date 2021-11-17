import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

void save(String key, String value) async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  storage.setString(key, value);
}

void saveInt(String key, int value) async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  storage.setInt(key, value);
}

void saveBoolean(String key, bool value) async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  storage.setBool(key, value);
}

Future<String> getString(String key) async {
  SharedPreferences storage = await SharedPreferences.getInstance();

  var result = storage.getString(key);
  if(result == null) return 'not-defined';

  return result;
}

Future<int> getInt(String key) async {
  SharedPreferences storage = await SharedPreferences.getInstance();

  var result = storage.getInt(key);
  if(result == null) return 0;

  return result;
}

Future<Map<String, dynamic>> getJSON(String key) async {
  SharedPreferences storage = await SharedPreferences.getInstance();

  var result = storage.getString(key);
  if(result == null) return jsonDecode('{}');

  return jsonDecode(result);
}

Future<bool> isSet(String key) async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  return (storage.get(key) != null);
}

void clearCache() async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  print('Cache successfully cleared');
  await storage.clear();
}