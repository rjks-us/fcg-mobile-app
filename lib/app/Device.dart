import 'dart:io';

import 'package:fcg_app/app/Account.dart';
import 'package:fcg_app/app/Storage.dart';
import 'package:fcg_app/app/structure/DeviceInfoState.dart';
import 'package:fcg_app/app/utils/DeviceInfo.dart';
import 'package:fcg_app/device/device.dart';
import 'package:fcg_app/firebase/Notification.dart';
import 'package:fcg_app/network/RequestHandler.dart' as RequestHandler;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class Device {

  Account account = new Account();

  late AppInfo appInfo;
  late AppSetting appSetting;

  late DeviceInfoState deviceInfoState;

  Device() {
    this.appInfo = new AppInfo();
    this.appSetting = new AppSetting();
  }

  ///Must me called before any action is performed
  Future<void> loadAssets() async {
    this.appInfo = new AppInfo();
    this.appSetting = new AppSetting();

    await this.appInfo.load();
    await this.appSetting.load();
  }

  Future<bool> isRegistered() async {
    String token = await getDeviceAPIToken();
    String refreshToken = await getDeviceAPIToken();

    return (token.toString().isNotEmpty && refreshToken.toString().isNotEmpty);
  }

  AppInfo getAppInfo() {
    return this.appInfo;
  }

  Account getAccount() {
    return this.account;
  }

  Future<AccountState> getAccountState() async {
    return account.hasAdminAccountRegistered();
  }

  AppSetting getAppSetting() {
    return this.appSetting;
  }

  Future<bool> hasAdminAccount() async {
    String account = await getString('var-admin-token');

    return (account != "");
  }

  Future<bool> validateSession() async {
    String token = await getDeviceAPIToken();

    RequestHandler.Request request = RequestHandler.Request('GET', 'v1/devices/me');
    
    request.setHeader(request.buildAccessHeader(token));

    var response = request.send();

    await response.processResponse();

    return (response.getStatusCode() != 401 && response.getStatusCode() != 500);
  }

  Future<bool> refreshSession() async {
    String token = await getDeviceAPIToken();
    String refreshToken = await getDeviceAPIRefreshToken();

    RequestHandler.Request request = RequestHandler.Request('POST', 'v1/devices/refresh');

    request.setBody({
      "token": token,
      "refresh": refreshToken
    });

    var response = request.send(), state = false;

    await response.processResponse();

    response.onSuccess((data) {
      state = true;

      updateDeviceAPIToken(data['token']);
      updateDeviceAPIRefreshToken(data['reset']);

      print('[DEVICE] A new token family was created');
    });

    response.onError((httpResponse) {
      print('[DEVICE] Could not refresh current session:');
      print('[DEVICE] ' + httpResponse.reasonPhrase);
    });

    response.registerListeners();

    return state;
  }

  Future<List<NotificationElement>> getDeviceNotifications() async {
    if(!await validateSession()) await refreshSession();

    String token = await getDeviceAPIToken();

    var request = RequestHandler.Request('GET', 'v1/devices/notifications');

    request.setHeader(request.buildAccessHeader(token));
    
    var response = request.send();
    
    await response.processResponse();

    List<NotificationElement> notificationCollection = [];

    response.onSuccess((data) {

      data.forEach((notification) {
        Map<String, dynamic> actionField = notification['actionid'];

        try {
          notificationCollection.add(new NotificationElement(
              notification['title'],
              notification['message'],
              notification['sender'],
              notification['iat'],
              new NotificationAction(actionField['id'], actionField['description'])
          ));
        } catch (_) {
          print(_);
        }
      });

    });

    response.onError((httpResponse) {
      print('[DEVICE] Could not load device notification');
    });

    response.registerListeners();

    return notificationCollection;
  }

  void setStudienzeitLastChangeDate(bool state) {
    DateTime now = DateTime.now();

    saveBool('var-st-swap', state);
    saveString('var-st-swap-date', '${now.year}-${now.month}-${now.day}');
  }

  Future<bool> isStudienzeitSwapped() async {
    bool token = await getBool('var-st-swap');
    return token;
  }

  Future<bool> studienzeitQuestionBoxHasToBeShown() async {
    String data = await getString('var-st-swap-date');

    if(data.isNotEmpty) {
      List<String> date = data.toString().split(' ');
      DateTime datum = new DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]));

      bool state = (DateTime.now().difference(datum).inDays >= 25); ///After 25 Days, the app will ask again

      return state;
    }
    return true;
  }

  Future<String> getDeviceAPIToken() async {
    String token = await getString('global-access-token');
    return token;
  }

  Future<bool> hasNotificationsEnabled() async {
    bool token = await getBool('var-notifications-enabled');
    return token;
  }

  Future<String> getDeviceAPIRefreshToken() async {
    String refreshToken = await getString('global-access-refresh-token');
    return refreshToken;
  }

  Future<String> getDeviceUsername() async {
    String username = await getString('var-username');
    return username;
  }

  Future<int> getDeviceClassId() async {
    int classId = await getInt('var-class-id');
    return classId;
  }

  Future<String> getDeviceClassName() async {
    String className = await getString('var-class-name');
    return className;
  }

  Future<List<int>> getDeviceCourseList() async {
    List<int> courseList = await getIntList('var-courses');
    return courseList;
  }

  void updateDeviceNotificationState(bool state) { saveBool('var-notifications-enabled', state); }

  void updateDeviceAPIToken(String token) { saveString('global-access-toke', token); }

  void updateDeviceAPIRefreshToken(String refreshToken) { saveString('global-access-refresh-token', refreshToken); }

  void updateDeviceClassName(String className) {saveString('var-class-name', className);}

  Future<bool> updatePushNotificationKey(String newToken) async {
    if(!await validateSession()) await refreshSession();

    RequestHandler.Request request = RequestHandler.Request('POST', 'v1/devices/update/token');

    String accessToken = await getDeviceAPIToken();
    request.setHeader(request.buildAccessHeader(accessToken));

    request.setBody({
      "token": newToken
    });

    var response = request.send(), state = false;

    await response.processResponse();

    response.onSuccess((data) {
      state = true;
      print('[DEVICE] The new FCM Device Token has been saved to database');
      print('[DEVICE] ' + data['token']);
    });

    response.onError((httpResponse) {
      print('[DEVICE] Could not save FCM Device Token');
      print('[DEVICE] ' + httpResponse.reasonPhrase);
    });

    response.registerListeners();

    return state;
  }

  Future<bool> updateDeviceUsername(String username) async {
    if(!await validateSession()) await refreshSession();

    RequestHandler.Request request = RequestHandler.Request('POST', 'v1/devices/update/name');

    String accessToken = await getDeviceAPIToken();
    request.setHeader(request.buildAccessHeader(accessToken));

    request.setBody({
      "name": username
    });

    var response = request.send(), state = false;

    await response.processResponse();

    response.onSuccess((data) {
      state = true;

      saveString('var-username', username);

      print('[DEVICE] The new username has been saved to database: ${data['name']}');
    });

    response.onError((httpResponse) {
      print('[DEVICE] Could not save new username');
      print('[DEVICE] ' + httpResponse.reasonPhrase);
    });

    response.registerListeners();

    return state;
  }

  Future<bool> updateDeviceClassId(int classId) async {
    if(!await validateSession()) await refreshSession();

    RequestHandler.Request request = RequestHandler.Request('POST', 'v1/devices/update/class');

    String accessToken = await getDeviceAPIToken();
    request.setHeader(request.buildAccessHeader(accessToken));

    request.setBody({
      "class": classId
    });

    var response = request.send(), state = false;

    await response.processResponse();

    response.onSuccess((data) {
      state = true;

      saveInt('var-class-id', classId);

      print('[DEVICE] The new classId has been saved to database');
    });

    response.onError((httpResponse) {
      print('[DEVICE] Could not save new classId');
      print('[DEVICE] ' + httpResponse.reasonPhrase);
    });

    response.registerListeners();

    return state;
  }

  Future<bool> updateDeviceCourseList(List<int> courseList) async {
    if(!await validateSession()) await refreshSession();

    RequestHandler.Request request = RequestHandler.Request('POST', 'v1/devices/update/course');

    String accessToken = await getDeviceAPIToken();
    request.setHeader(request.buildAccessHeader(accessToken));

    request.setBody({
      "courses": courseList
    });

    var response = request.send(), state = false;

    await response.processResponse();

    response.onSuccess((data) {
      state = true;

      saveIntList('var-courses', courseList);

      print('[DEVICE] The new course list has been saved to database');
    });

    response.onError((httpResponse) {
      print('[DEVICE] Could not save new course list');
      print('[DEVICE] ' + httpResponse.reasonPhrase);
    });

    response.registerListeners();

    return state;
  }

  Future<bool> deleteDevice() async {
    if(!await validateSession()) await refreshSession();

    RequestHandler.Request request = RequestHandler.Request('POST', 'v1/devices/delete');

    String accessToken = await getDeviceAPIToken();
    request.setHeader(request.buildAccessHeader(accessToken));

    var response = request.send(), state = false;

    AccountState accountState = await this.getAccountState();

    await response.processResponse();

    response.onSuccess((data) {
      state = true;
      clearCache();

      if(accountState == AccountState.LOGGED_IN) {
        getAccount().signOut();
      }

      print('[DEVICE] The Device has been deleted');
    });

    response.onError((httpResponse) {
      print('[DEVICE] Unable to delete the current device');
      print('[DEVICE] ' + httpResponse.reasonPhrase);
    });

    response.registerListeners();

    return state;

  }

}

class PreRegisteredDevice {

  late String _deviceInfo, fcmToken, username, platform, className;
  late int classId;
  late List<int> courseList;

  late bool pushNotification = false;

  PreRegisteredDevice();

  void setFCMToken(String token) {
    this.fcmToken = token;
  }

  void setClassName(String name) {
    this.className = name;
  }

  void setUsername(String name) {
    this.username = name;
  }

  void setPlatform(String type) {
    this.platform = platform;
  }

  void setClassId(int id) {
    this.classId = id;
  }

  void setCourseList(List<int> list) {
    this.courseList = list;
  }

  void setPushNotifications(bool state) {
    this.pushNotification = state;
  }

  Future<bool> checkout() async {

    print('a');

    bool success = false;
    DeviceInfo deviceInfo = new DeviceInfo();
    print('b');

    await deviceInfo.load();
    print('c');

    this.platform = deviceInfo.platform;
    print('d');

    String? tmpFcmToken;
    String finalFcmToken = '-';
    print('e');

    if(this.pushNotification) {
      ///FCM getToken not returning any result, please check later
      FirebaseMessaging.instance.getToken().then((value) {
        if(value == null) {
          tmpFcmToken = 'FCM-DID-NOT-RETURN-ANY-RESULT';
        } else {
          tmpFcmToken = value;
        }
      });

      await Future.delayed(new Duration(seconds: 3));
    } else {
      print('g');
      setPushNotifications(false);
      tmpFcmToken = 'PERMISSION-NOT-GRANTED';
    }
    print('f');

    if(tmpFcmToken != null) finalFcmToken = tmpFcmToken!;

    print('h');


    this._deviceInfo = jsonEncode({
      'model': deviceInfo.model,
      'version': deviceInfo.version,
      'identifier': deviceInfo.identifier,
    });

    print('i');


    RequestHandler.Request request = RequestHandler.Request('POST', 'v1/devices/create-device');
    print('j');

    request.setBody({
      'name': this.username,
      'platform': this.platform,
      'device': jsonDecode(_deviceInfo),
      'settings': {
        'notifications': this.pushNotification,
      },
      'courses': this.courseList,
      'class': this.classId,
      'push': finalFcmToken
    });
    print('k');

    print(request.httpRequest.body);

    request.setHeader(request.buildAccessHeader(''));
    print('l');

    var response = request.send();
    print('m');

    await response.processResponse();
    print('n');

    response.onSuccess((data) {

      saveString('var-username', this.username);
      saveIntList('var-courses', this.courseList);
      saveInt('var-class-id', this.classId);
      saveString('var-class-name', this.className);

      saveBool('var-notifications-enabled', this.pushNotification);

      saveString('global-access-token', data['token']);
      saveString('global-access-refresh-token', data['refresh']);

      saveString('var-creation-date', '${DateTime.now().millisecondsSinceEpoch}');

      success = true;

      print('[DEVICE] The Device has been registered');
    });
    print('o');

    response.onError((httpResponse) {
      print('[DEVICE] Unable to register the current device');
    });

    print('p');

    response.registerListeners();
    print('q');

    return success;
  }

}

class AppSetting {

  late Map<String, dynamic> appSettingData;

  AppSetting();

  load() async {
    final String response = await rootBundle.loadString('app_config.json');
    appSettingData = await json.decode(response);
  }

  String getHost() {
    return (getAPIProtocol() + '://' + getAPIHost());
  }

  String getAPIHost() {
    return appSettingData['host'];
  }

  String getAPIProtocol() {
    return appSettingData['protocol'];
  }
}

class AppInfo {

  late Map<String, dynamic> appInfoData;

  AppInfo();

  load() async {
    final String response = await rootBundle.loadString('fcg_manifest.json');
    appInfoData = await json.decode(response);
  }

  String getAppAuthor() {
    return appInfoData['author'];
  }

  String getAppVersion() {
    return appInfoData['version'];
  }

  String getWebsite() {
    return appInfoData['website'];
  }

  String getContact() {
    return appInfoData['contact'];
  }

  String getProvider() {
    return appInfoData['provider'];
  }
}

Future<String> _awaitFCMToken() async {
  String token = 'TOKEN';
  String? preLoadedToken;

  preLoadedToken = await FirebaseMessaging.instance.getToken();

  if(preLoadedToken != null) token = preLoadedToken;

  return token;
}