import 'dart:async';

import 'package:fcg_app/api/helper.dart';
import 'package:fcg_app/api/httpBuilder.dart' as httpBuilder;
import 'package:fcg_app/main.dart';
import 'package:fcg_app/pages/components/comp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

  List<String> days = ['Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag'];
  List<String> month = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];

  List<Widget> events = [
    EventPreLoadingBox(),
    EventPreLoadingBox(),
    EventPreLoadingBox(),
  ];

  DateTime date = DateTime.now();

  refresh() {
    if(this.mounted) setState(() {});
  }

  onRefreshPress() async {
    await load(true);
  }

  load(bool newRequest) async {
    httpBuilder.Request request = new httpBuilder.Request('GET', 'v1/today', true, newRequest, !newRequest);
    httpBuilder.Response response = await request.flush();
    await response.checkCache();

    events.clear();

    response.onSuccess((data) { ///200
      List<dynamic>? messages = data['messages'];
      if(messages == null || messages.length == 0) { ///Check if messages do exists
        events.add(NoResultFoundScreen(error: 'Es wurde kein Ergebnis\ngefunden', refresh: () {
          onRefreshPress();
        }));
      }
    });

    response.onNoResult((data) { ///No connection
      events.add(NoInternetConnectionScreen(refresh: () {
        onRefreshPress();
      }));
    });

    response.onError((data) { ///Server Error
      events.add(AnErrorOccurred(refresh: () {
        onRefreshPress();
      }));
    });

    await response.process();

    Timer(Duration(milliseconds: 5), () {
      if(this.mounted) {
        refresh();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    load(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Color.fromRGBO(54, 66, 106, 1),
                    Color.fromRGBO(29, 29, 29, 1)
                  ]
              )
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            '${date.day}. ${month[date.month - 1]} ${date.year}',
                            style: TextStyle(
                                fontFamily: 'Nunito-Regular',
                                fontSize: 29.0,
                                color: Colors.white
                            ),
                          ),
                        ),
                        Container(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.settings,
                                color: Colors.white,
                              ),
                              onPressed: () => onRefreshPress(), ///TODO: Settings for events
                            )
                        )
                      ],
                    )
                ),
                Container(
                  child: AlertBox(
                    color: Colors.red,
                    text: 'Nachrichten des Tages',
                    label: Icon(Icons.notifications_active, size: 30, color: Colors.white,),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    children: events,
                  ),
                )
              ],
            ),
          ),
        )
      )
    );
  }
}

class EventSection extends StatefulWidget {
  const EventSection({Key? key, required this.dateName, required this.date}) : super(key: key);

  final String dateName;
  final DateTime date;

  @override
  _EventSectionState createState() => _EventSectionState();
}

class _EventSectionState extends State<EventSection> {

  List<Widget> events = [
    EventPreLoadingBox(),
    EventPreLoadingBox(),
    EventPreLoadingBox(),
  ];

  List<Widget> tmp = [
    EventContentBox(
      color: Colors.orange,
      title: 'Bestellt euch jetzt ein Jahrbuch',
      subtitle: 'An die Q2',
      author: 'Nachricht der SV',
      icon: Icons.escalator_warning_rounded,
      content: 'Bestellt euch jetzt ein buch ihr hunde',
    ),
    EventContentBox(
      color: Colors.indigo,
      title: 'Halloweenparty am 26 November 2021',
      subtitle: 'An alle Schüler des FCG`s',
      author: 'Nachricht der Q2',
      icon: Icons.school,
      content: 'Geht da hin hab ich gesagt',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(widget.dateName,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'Nunito-Regular',
                    fontSize: 22.0,
                    color: Colors.white
                ),
              ),
            ),
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: events,
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

class EventContentBox extends StatefulWidget {
  const EventContentBox({Key? key, required this.title, required this.subtitle, required this.color, required this.author, required this.icon, required this.content}) : super(key: key);

  final String title, subtitle, author, content;
  final Color color;
  final IconData icon;

  @override
  _EventContentBoxState createState() => _EventContentBoxState();
}

class _EventContentBoxState extends State<EventContentBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {},
      child: Container(
        margin: EdgeInsets.only(bottom: 10, top: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 5, spreadRadius: 3)],
          borderRadius: BorderRadius.circular(13.0),
          color: Color.fromRGBO(255, 255, 255, 0.13),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 15),
                    child: Text(widget.subtitle, ///'An die Q2'
                      style: TextStyle(
                          fontFamily: 'Nunito-Regular',
                          fontSize: 16.0,
                          color: Color.fromRGBO(255, 255, 255, 0.53)
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 20),
                    child: Text(widget.title, ///'Bestellt euch jetzt ein Jahrbuch'
                      style: TextStyle(
                          fontFamily: 'Nunito-Regular',
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(255, 255, 255, 1)
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(13), bottomRight: Radius.circular(12)),
                color: Color.fromRGBO(22, 22, 22, 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.only(left: 15, right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: widget.color
                          ),
                          child: Center(
                            child: Icon(widget.icon, color: Colors.white, size: 18,),
                          ),
                        ),
                        Container(
                          child: Text(
                            widget.author, ///'Nachricht der SV'
                            style: TextStyle(
                                fontFamily: 'Nunito-Regular',
                                fontSize: 12.0,
                                color: Color.fromRGBO(255, 255, 255, 0.53)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(29, 29, 29, 1),
                        borderRadius: BorderRadius.circular(13.0)
                    ),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Padding(
                      padding: EdgeInsets.only(top: 7, bottom: 7, left: 10, right: 10),
                      child: Text(
                        'Mehr',
                        style: TextStyle(
                            fontFamily: 'Nunito-Regular',
                            fontSize: 12.0,
                            color: Color.fromRGBO(39, 140, 255, 1)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

