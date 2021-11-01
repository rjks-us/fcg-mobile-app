import 'dart:io';
import 'helper.dart';

Future<bool> hasConnection() async {
  Map<String, dynamic> req = await getVersion();
  return (req != "{}");
}