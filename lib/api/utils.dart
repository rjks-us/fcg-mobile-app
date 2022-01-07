import 'dart:io';
import 'dart:math';
import 'helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

Future<bool> apiIsOnline() async {
  try {
    await getVersion();
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> hasConnection() async {
  try {
    var request = http.Request('GET', Uri.parse('https://www.google.com'));
    var response = await request.send();

    print('http-request: $request');

    return true;
  } catch(_) {return false;}
}

Future<bool> appOnNewestVersion() async {
  return true;
}

String randomKey() {
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(Random().nextInt(_chars.length))));

  return(getRandomString(100));
}

String getPlatform() {
  if (kIsWeb) {
    return "web";
  } else {
    if(Platform.isAndroid) return "android";
    if(Platform.isFuchsia) return "fuchsia";
    if(Platform.isIOS) return "ios";
    if(Platform.isLinux) return "linux";
    if(Platform.isMacOS) return "macos";
    if(Platform.isWindows) return "windows";
  }
  return "-";
}