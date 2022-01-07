import 'package:fcg_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

bool status = false;

bool isActive() => status;

void init() async {

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen(firebaseMessagingReceiveMessage);

  FirebaseMessaging.instance.onTokenRefresh.listen(firebaseMessagingTokenRefresh);

  await setupInteractedMessage();

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('[FCM] User granted permission');
    status = true;
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('[FCM] User granted provisional permission');
    status = true;
  } else {
    print('[FCM] User declined or has not accepted permission');
    status = false;
  }
}

Future<String> requestFMCDeviceToken() async {
  if(!status) return '';

  String? tmp = await FirebaseMessaging.instance.getToken();
  String token = (tmp == null) ? '' : tmp;

  return token;
}

Future<void> setupInteractedMessage() async {
  // Get any messages which caused the application to open from
  // a terminated state.
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  // If the message also contains a data property with a "type" of "chat",
  // navigate to a chat screen
  if (initialMessage != null) firebaseMessagingReceiveMessage(initialMessage);

  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen(firebaseMessagingReceiveMessage);
}

Future<void> firebaseMessagingReceiveMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  print(message.data);
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("[FCM] Handling a background message: ${message.messageId}");
}

Future<void> firebaseMessagingTokenRefresh(String token) async {
  await Firebase.initializeApp();

  print('[FCM] A new token was generated: ' + token);
}