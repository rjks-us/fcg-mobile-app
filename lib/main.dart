import 'package:fcg_app/modal/modal_bottom_sheet.dart';
import 'package:fcg_app/pages/home.dart';
import 'package:fcg_app/pages/tmp/custom_animated_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'api/helper.dart';
import 'api/device.dart';
import 'api/utils.dart';

void main() async {
  Map<String, dynamic> version = await getVersion();
  print(version);

  getDeviceInformation();
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCG App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
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
          icon: Icon(Icons.calendar_today),
          title: Text('Kalender'),
          activeColor: Colors.purpleAccent,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.backpack),
          title: Text("ToDo's"),
          activeColor: Colors.pink,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
  Widget getBody() {
    List<Widget> pages = [
      Container(
        alignment: Alignment.center,
        child: HomeScreen(username: 'Tom'),
      ),
      Container(
        alignment: Alignment.center,
        child: Text("Woche",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
      ),
      Container(
        alignment: Alignment.center,
        child: Text("Kalender",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
      ),
      Container(
        alignment: Alignment.center,
        child: Text("ToDo",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
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

class TimetableElement extends StatefulWidget {
  const TimetableElement({Key? key, required this.time, required this.hour, required this.title, required this.subtitle, required this.status, required this.color}) : super(key: key);

  //final Map<String, dynamic> timetableObjects;

  final int status;
  final String time, hour, title, subtitle;

  final Color color;

  @override
  _TimetableElementState createState() => _TimetableElementState();
}

class _TimetableElementState extends State<TimetableElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(children: <Widget>[
        Row(children: <Widget>[
          Expanded(
            child: new Container(
                margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
                  color: Colors.grey.shade600,
                  height: 36,
                )),
          ),
          Text(
            widget.time,
            style: TextStyle(
                color: Colors.white
            ),
          ),
          Expanded(
            child: new Container(
                margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                child: Divider(
                  color: Colors.grey.shade600,
                  height: 36,
                )),
          ),
        ]),
        InkWell(
          child: TimetableElementBox(hour: widget.hour, title: widget.title, subtitle: widget.subtitle, color: widget.color),
          onTap: () => {showTimeTable(context, {"id": "1231", "message": "eigenverantwortliches Arbeitens"})},
        )
      ]),
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
        borderRadius: BorderRadius.circular(13.0),
        color: Color.fromRGBO(255, 255, 255, 0.13),
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
                  child: Text(
                    widget.title + '\n' + widget.subtitle,
                    style: TextStyle(fontSize: 19.0, fontFamily: 'Nunito-SemiBold', color: Colors.grey.shade300),
                  ),
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
  AlertBox({Key? key, required this.text, required this.label}) : super(key: key);

  final String text, label;

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
              color: Color.fromRGBO(156, 99, 255, 1),
            ),
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(fontSize: 27.0, fontFamily: 'Nunito-SemiBold', color: Colors.white),
              ),
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