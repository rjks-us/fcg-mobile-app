import 'package:fcg_app/app/DateConverter.dart';
import 'package:fcg_app/fcgapp/components/default_background_design.dart';
import 'package:fcg_app/fcgapp/components/notification_card.dart';
import 'package:fcg_app/fcgapp/components/title_card.dart';
import 'package:fcg_app/fcgapp/components/title_section.dart';
import 'package:fcg_app/fcgapp/main.dart';
import 'package:fcg_app/firebase/Notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainNotificationContentPage extends StatefulWidget {
  const MainNotificationContentPage({Key? key}) : super(key: key);

  @override
  _MainNotificationContentPageState createState() => _MainNotificationContentPageState();
}

class _MainNotificationContentPageState extends State<MainNotificationContentPage> {

  DateTime _lastRefresh = new DateTime.now();

  String _currentDate = '${DateTime.now().day}. ${new DateConverter(DateTime.now()).getMonthName()} ${DateTime.now().year}';

  List<Widget> _notificationElementsWidgets = [];

  void _refresh() {
    if(this.mounted) setState(() {});
  }

  Future<void> _onRefresh() async {

    print('Home refresh pressed');
    _lastRefresh = new DateTime.now();

    _refresh();
  }

  Future<void> _fetchNotifications() async {

    List<NotificationElement> _notifications = await device.getDeviceNotifications();

    _notifications.forEach((element) {
      _notificationElementsWidgets.add(
          NotificationCard(title: element.message, subtitle: element.title, description: element.sender, color: Colors.indigo, iat: element.getDateTime())
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: RefreshIndicator(
          backgroundColor: Color.fromRGBO(29, 29, 29, 1),
          color: Colors.indigo,
          onRefresh: _onRefresh,
          child: DefaultBackgroundDesign(
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 20.0, top: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              'Benachrichtigungen',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: 'Nunito-Regular',
                                  fontSize: 29.0,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  TitleContentCard(
                      title: _currentDate,
                      icon: Icons.notifications_active,
                      color: Colors.indigo
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              'Letzte Aktivität',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: 'Nunito-Regular',
                                  fontSize: 22.0,
                                  color: Colors.white
                              ),
                            ),
                          ),
                          Container(
                              child: IconButton(
                                icon: Icon(Icons.refresh),
                                color: Colors.white,
                                onPressed: () => _onRefresh(),
                              )
                          ),
                        ],
                      )
                  ),
                  Container(
                      child: FutureBuilder(
                        future: _fetchNotifications(),
                        builder: (context, AsyncSnapshot snapshot) {

                          if(snapshot.connectionState == ConnectionState.waiting) {
                            ///preview loading animation

                            return new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                NotificationPreLoadingCard(),
                                NotificationPreLoadingCard(),
                                NotificationPreLoadingCard(),
                                NotificationPreLoadingCard(),
                                NotificationPreLoadingCard(),
                                NotificationPreLoadingCard(),
                              ],
                            );
                          } else {
                            ///Release data

                            return new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: _notificationElementsWidgets.reversed.toList(),
                            );
                          }

                        },
                      )
                  ),
                  SmallSubInformationTextText(
                      title: 'Letztes Update ${_lastRefresh.hour}:${_lastRefresh.minute}\nAlle Angaben ohne Gewähr'
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
