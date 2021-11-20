import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

void save(String key, String value) async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences storage = await SharedPreferences.getInstance();
  storage.setString(key, value);
}

void saveInt(String key, int value) async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences storage = await SharedPreferences.getInstance();
  storage.setInt(key, value);
}

void saveBoolean(String key, bool value) async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences storage = await SharedPreferences.getInstance();
  storage.setBool(key, value);
}

void saveStringList(String key, List<String> value) async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences storage = await SharedPreferences.getInstance();
  storage.setStringList(key, value);
}

Future<String> getString(String key) async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences storage = await SharedPreferences.getInstance();

  var result = storage.getString(key);
  if(result == null) return 'not-defined';

  return result;
}

Future<List<String>> getStringList(String key) async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences storage = await SharedPreferences.getInstance();

  var result = storage.getStringList(key);
  if(result == null) return [];

  return result;
}

Future<List<int>> getIntList(String key) async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences storage = await SharedPreferences.getInstance();

  List<String>? tmp = storage.getStringList(key);

  if(tmp == null) return [];

  List<int> result = tmp.map((e) => int.parse('$e')).toList();

  return result;
}

Future<int> getInt(String key) async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences storage = await SharedPreferences.getInstance();

  var result = storage.getInt(key);
  if(result == null) return 0;

  return result;
}

Future<Map<String, dynamic>> getJSON(String key) async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences storage = await SharedPreferences.getInstance();

  var result = storage.getString(key);
  if(result == null) return jsonDecode('{}');

  return jsonDecode(result);
}

Future<bool> isSet(String key) async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences storage = await SharedPreferences.getInstance();
  return (storage.get(key) != null);
}

void clearCache() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences storage = await SharedPreferences.getInstance();
  print('Cache successfully cleared');
  await storage.clear();
}