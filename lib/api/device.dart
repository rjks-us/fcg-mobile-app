import 'dart:io' show Platform;

import 'package:device_info/device_info.dart';

void getDeviceInformation() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  try {
    if(Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print(iosInfo);
    } else if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print(androidInfo);
    }
  } catch (_) {
    print(_);
  }
}