import 'package:firebase_messaging/firebase_messaging.dart';

void refreshFCMToken() async {
  String? token = await FirebaseMessaging.instance.getToken();

  print('Token: $token');
}