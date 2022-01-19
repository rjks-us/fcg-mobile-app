import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({Key? key, required this.title, required this.subtitle, required this.description, required this.color, required this.iat}) : super(key: key);

  final DateTime iat;

  final String title, subtitle, description;
  final Color color;


  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {

  String _timeAgo = 'vor 2T';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {},
      child: Container(
        margin: EdgeInsets.only(bottom: 10, top: 10, left: 20, right: 20),
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
                            child: Icon(Icons.notifications_active_outlined, color: Colors.white, size: 12,),
                          ),
                        ),
                        Container(
                          child: Text(
                            widget.description, ///'Nachricht der SV'
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
                        _timeAgo,
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

class NotificationPreLoadingCard extends StatefulWidget {
  const NotificationPreLoadingCard({Key? key}) : super(key: key);

  @override
  _NotificationPreLoadingCardState createState() => _NotificationPreLoadingCardState();
}

class _NotificationPreLoadingCardState extends State<NotificationPreLoadingCard> {
  bool selected = false;

  Color from = Color.fromRGBO(48, 48, 52, 0.5);
  Color to = Color.fromRGBO(41, 40, 43, 0.5);

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 0), () {
      setState(() {
        selected = !selected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10, top: 10),
      height: 120.0,
      duration: Duration(seconds: 1, milliseconds: 5),
      onEnd: () {
        setState(() {
          selected = !selected;
        });
      },
      curve: Curves.ease,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: selected ? from : to,
      ),
    );
  }
}

