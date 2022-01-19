import 'package:fcg_app/fcgapp/pages/home/home.dart';
import 'package:fcg_app/fcgapp/pages/notifications/notifications.dart';
import 'package:fcg_app/fcgapp/pages/settings/settings.dart';
import 'package:fcg_app/fcgapp/pages/week/week.dart';
import 'package:fcg_app/fcgapp/components/custom_animated_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DefaultStartApp extends StatefulWidget {
  const DefaultStartApp({Key? key}) : super(key: key);

  @override
  _DefaultStartAppState createState() => _DefaultStartAppState();
}

class _DefaultStartAppState extends State<DefaultStartApp> {
  int _currentIndex = 0;
  final _inactiveColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: _navigationBar(),
        body: getBody()
    );
  }

  Widget _navigationBar(){
    return CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: Colors.grey[900],
      selectedIndex: _currentIndex,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.ease,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icon(Icons.home),
          title: Text('Heute'),
          activeColor: Colors.indigo,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.list_alt),
          title: Text('Woche'),
          activeColor: Colors.indigo,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.notifications_active),
          title: Text("Neues"),
          activeColor: Colors.indigo,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.settings),
          title: Text('Profil'),
          activeColor: Colors.grey,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  Widget getBody() {
    List<Widget> pages = [
      Container(
        alignment: Alignment.center,
        child: MainHomeContentPage(),
      ),
      Container(
        alignment: Alignment.center,
        child: MainWeekPlanContentPage(),
      ),
      Container(
        alignment: Alignment.center,
        child: MainNotificationContentPage(),
      ),
      Container(
        alignment: Alignment.center,
        child: MainSettingContentPage(),
      )
    ];

    return IndexedStack(
      index: _currentIndex,
      children: pages,
    );
  }

}
