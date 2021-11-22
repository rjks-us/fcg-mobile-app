import 'package:fcg_app/api/helper.dart';
import 'package:fcg_app/api/timetable.dart';
import 'package:fcg_app/api/utils.dart';
import 'package:fcg_app/device/device.dart' as device;
import 'package:fcg_app/modal/modal_bottom_sheet.dart';
import 'package:fcg_app/pages/components/comp.dart';
import 'package:fcg_app/pages/event/event.dart';
import 'package:fcg_app/pages/home.dart';
import 'package:fcg_app/pages/settings/settings.dart';
import 'package:fcg_app/pages/setup/app_setup.dart';
import 'package:fcg_app/pages/splash/splashscreen.dart';
import 'package:fcg_app/pages/tmp/custom_animated_bottom_bar.dart';
import 'package:fcg_app/pages/tmp/week.dart';
import 'package:fcg_app/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///Global Variables

bool splashScreen = false;

String version = '1.0.0', author = 'Robert J. Kratz', provider = 'rjks.us';

bool connection = false;
bool apiOnline = false;
bool dev = true;
bool setUp = false;

initApp(Function(bool) callback) async {
  // var request = await getVersion();
  //
  // if(request != null) {
  //   var version = request['data'];
  //
  //   apiOnline = true;
  //
  //   author = version['author'];
  //   version = version['version'];
  // } else {
  //   var connected = await hasConnection(); ///Check if general a connection is possible, pinged google.com
  //   if(connected) connection = true;
  // }

  try {

    if(await device.isDeviceSetUp() && await device.deviceRegistered()) {
      setUp = true;
      if(!await device.isSessionValid()) device.refreshSession();
      callback(true);
    }
  } catch(_) {
    callback(false);
  }
}

void main() async {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FCG App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class Home extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {

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
          activeColor: Colors.green,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.list_alt),
          title: Text('Woche'),
          activeColor: Colors.blue,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.article_outlined),
          title: Text("Events"),
          activeColor: Colors.pink,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.settings),
          title: Text('Sonstiges'),
          activeColor: Colors.purpleAccent,
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
        child: HomeScreen(),
      ),
      Container(
        alignment: Alignment.center,
        child: WeekScreen(),
      ),
      Container(
        alignment: Alignment.center,
        child: EventScreen(),
      ),
      Container(
        alignment: Alignment.center,
        child: SettingsOverviewPage(),
      )
    ];

    return IndexedStack(
      index: _currentIndex,
      children: pages,
    );
  }
}

/*
* Timetable element
* */

class TimeTableFreeElement extends StatefulWidget {
  const TimeTableFreeElement({Key? key, required this.hour, required this.time, required this.isOver}) : super(key: key);

  final bool isOver;
  final String hour, time;

  @override
  _TimeTableFreeElementState createState() => _TimeTableFreeElementState();
}

class _TimeTableFreeElementState extends State<TimeTableFreeElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Opacity(
        opacity: widget.isOver ? 0.6 : 1,
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(children: <Widget>[
            Line(title: widget.time),
            InkWell(
              child: TimeTableFreeElementBox(hour: widget.hour),
              onTap: () => {},
            )
          ]),
        ),
      ),
    );
  }
}


class TimeTableFreeElementBox extends StatefulWidget {
  const TimeTableFreeElementBox({Key? key, required this.hour}) : super(key: key);

  final String hour;

  @override
  _TimeTableFreeElementBoxState createState() => _TimeTableFreeElementBoxState();
}

class _TimeTableFreeElementBoxState extends State<TimeTableFreeElementBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100.0,
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 5, spreadRadius: 3)],
          borderRadius: BorderRadius.circular(13.0),
          color: Color.fromRGBO(255, 255, 255, 0.13),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(43, 42, 47, 1),
                Color.fromRGBO(41, 40, 43, 1.0),
              ]
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15)),
                  ),
                  child: Center(
                    child: Text(
                      widget.hour,
                      style: TextStyle(fontSize: 40.0, fontFamily: 'Nunito-SemiBold', color: Colors.white),
                    ),
                  ),
                ),
                Container(
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 180,
                          child: Text(
                            'Freistunde',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 19.0, fontFamily: 'Nunito-SemiBold', color: Colors.grey.shade300),
                          ),
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: 20,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: Colors.indigo
            ),
          ),
        ],
      ),
    );
  }
}


class TimetableElement extends StatefulWidget {
  const TimetableElement({Key? key, required this.time, required this.hour, required this.title, required this.subtitle, required this.status,required this.data, required this.isOver}) : super(key: key);

  //final Map<String, dynamic> timetableObjects;

  final bool isOver;
  final Map<String, dynamic> data;
  final int status;
  final String time, hour, title, subtitle;

  @override
  _TimetableElementState createState() => _TimetableElementState();
}

class _TimetableElementState extends State<TimetableElement> {

  getColor(int state) {
    if(state == 0) {
      return Colors.green;
    }
    if(state == 1) {
      return Colors.red;
    }
    if(state == 2) {
      return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Opacity(
        opacity: widget.isOver ? 0.6 : 1,
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(children: <Widget>[
            Line(title: widget.time),
            InkWell(
              child: TimetableElementBox(hour: widget.hour, title: widget.title, subtitle: widget.subtitle, color: getColor(widget.status),),
              onTap: () => showTimeTable(context, {"data": widget.data}),
            )
          ]),
        ),
      ),
    );
  }
}

class TimetableElementBox extends StatefulWidget {
  const TimetableElementBox({Key? key, required this.hour, required this.title, required this.subtitle, required this.color}) : super(key: key);

  final String hour, title, subtitle;
  final Color color;

  @override
  _TimetableElementBoxState createState() => _TimetableElementBoxState();
}

class _TimetableElementBoxState extends State<TimetableElementBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100.0,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 5, spreadRadius: 3)],
        borderRadius: BorderRadius.circular(13.0),
        color: Color.fromRGBO(255, 255, 255, 0.13),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(43, 42, 47, 1),
              Color.fromRGBO(41, 40, 43, 1.0),
            ]
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15)),
                  ),
                  child: Center(
                    child: Text(
                      widget.hour,
                      style: TextStyle(fontSize: 40.0, fontFamily: 'Nunito-SemiBold', color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 180,
                        child: Text(
                          widget.title,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 19.0, fontFamily: 'Nunito-SemiBold', color: Colors.grey.shade300),
                        ),
                      ),
                      Container(
                        width: 180,
                        child: Text(
                          widget.subtitle,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 19.0, fontFamily: 'Nunito-SemiBold', color: Colors.grey.shade400),
                        ),
                      )
                    ],
                  )
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: 20,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
              color: widget.color
            ),
          ),
        ],
      ),
    );
  }
}


/*
* Alert Boxes
* */

class AlertBox extends StatefulWidget {
  AlertBox({Key? key, required this.text, required this.label, required this.color}) : super(key: key);

  final String text;
  final Color color;
  final Widget label;

  @override
  _AlertBoxState createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100.0,
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: Color.fromRGBO(255, 255, 255, 0.13),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
              color: widget.color,
            ),
            child: Center(
              child: widget.label,
              /*child: Text(
                widget.label,
                style: TextStyle(fontSize: 27.0, fontFamily: 'Nunito-SemiBold', color: Colors.white),
              ),*/
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 20.0, left: 20.0),
            child: Text(
              widget.text,
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 21.0, fontFamily: 'Nunito-SemiBold', color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}