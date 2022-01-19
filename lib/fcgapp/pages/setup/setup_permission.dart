import 'package:fcg_app/fcgapp/components/buttons.dart';
import 'package:fcg_app/fcgapp/components/default_background_design.dart';
import 'package:fcg_app/fcgapp/components/title_section.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetPermissionPage extends StatefulWidget {
  const SetPermissionPage({Key? key, required this.username, required this.onFinishEvent}) : super(key: key);

  final String username;
  final Function(BuildContext, bool) onFinishEvent;

  @override
  _SetPermissionPageState createState() => _SetPermissionPageState();
}

class _SetPermissionPageState extends State<SetPermissionPage> {

  bool _hasAllowedPushNotifications = false;

  void _onFinishPress() {
    widget.onFinishEvent(context, _hasAllowedPushNotifications);
  }

  void _onSettingsPress() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _hasAllowedPushNotifications = true;

    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      _hasAllowedPushNotifications = true;

    } else {
      _hasAllowedPushNotifications = false;
    }

    _onFinishPress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(54, 66, 106, 1),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          controller: ScrollController(),
          child: DefaultBackgroundDesign(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 80),
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.indigo,
                              ),
                              height: 150,
                              width: 150,
                              child: Center(
                                child: Icon(Icons.notifications_active_outlined, size: 40, color: Colors.white,),
                              ),
                            ),
                          )
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 20.0, top: 30.0, bottom: 5.0, right: 20.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                            child: Text('Hallo ${widget.username}', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 29),),
                          )
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
                        child: Center(
                          child: Text('Wir möchten dir Benachrichtigungen schicken, um dich über Updates zu informieren', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 18),),
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: PrimaryButton(
                            active: true,
                            title: 'Öffne Einstellungen',
                            onClickEvent: _onSettingsPress,
                          )
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: SecondaryButton(
                            title: 'Weiter',
                            onClickEvent: _onFinishPress,
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        )
    );
  }
}