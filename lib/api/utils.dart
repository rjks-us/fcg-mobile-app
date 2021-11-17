import 'dart:io';
import 'dart:math';
import 'helper.dart';

Future<bool> apiIsOnline() async {
  try {
    await getVersion();
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> appOnNewestVersion() async {
  return true;
}

String randomKey() {
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(Random().nextInt(_chars.length))));

  return(getRandomString(100));
}