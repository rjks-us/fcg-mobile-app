import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DeviceInfo {

  DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  String model = 'UNABLE-TO-LOCATE-DEVICE-MODEL',
      version = 'UNABLE-TO-LOCATE-DEVICE-VERSION',
      identifier = 'UNABLE-TO-LOCATE-DEVICE-ID',
      platform = 'UNABLE-TO-LOCATE-DEVICE-PLATFORM';

  DeviceInfo();

  load() async {

    print('aaa');

    try {
      if(Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        print('bbbb');

        this.model = build.model;
        this.version = build.version.toString();
        this.identifier = build.androidId;
        this.platform = 'android';


      } else if(Platform.isIOS) {
        var build = await deviceInfoPlugin.iosInfo;
        print('ccc');

        this.model = build.model;
        this.version = build.systemVersion;
        this.identifier = build.identifierForVendor;
        this.platform = 'ios';

      }
    } catch (_) {
        print('ddd');
    }
  }

  String getPlatformName() {
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
}