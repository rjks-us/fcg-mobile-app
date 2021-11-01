import 'package:shared_preferences/shared_preferences.dart';

void save(String key, String value) async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  storage.setString(key, value);
}

Future<String?> getString(String key) async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  return storage.getString(key);
}

Future<bool> isSet(String key) async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  return (storage.getString(key) != null);
}