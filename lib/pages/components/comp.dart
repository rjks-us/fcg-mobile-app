import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


/// Separation line for elements
class Line extends StatefulWidget {
  const Line({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LineState createState() => _LineState();
}

class _LineState extends State<Line> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, bottom: 10, right: 20.0, top: 10),
      child: Center(
        child: Text(
          widget.title,
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
    );
  }
}

class BigNextButton extends StatefulWidget {
  const BigNextButton({Key? key, required this.title, required this.callback}) : super(key: key);

  final String title;
  final Function callback;

  @override
  _BigNextButtonState createState() => _BigNextButtonState();
}

class _BigNextButtonState extends State<BigNextButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(29, 29, 29, 1),
        ),
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          onTap: () => widget.callback,
          child: Container(
            margin: EdgeInsets.all(10),
            height: 50,
            decoration: BoxDecoration(
                color: Colors.blue
            ),
            child: Center(
              child: Text(widget.title, style: TextStyle(color: Colors.white, fontSize: 22),),
            ),
          ),
        )
    );
  }
}

class TimeTablePreLoadingBox extends StatefulWidget {
  const TimeTablePreLoadingBox({Key? key, required this.time}) : super(key: key);

  final String time;

  @override
  _TimeTablePreLoadingBoxState createState() => _TimeTablePreLoadingBoxState();
}

class _TimeTablePreLoadingBoxState extends State<TimeTablePreLoadingBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        Line(title: widget.time),
        InkWell(
          child: PreLoadingBox(),
        )
      ]),
    );
  }
}


class PreLoadingBox extends StatefulWidget {
  const PreLoadingBox({Key? key}) : super(key: key);

  @override
  _PreLoadingBoxState createState() => _PreLoadingBoxState();
}

class _PreLoadingBoxState extends State<PreLoadingBox> {

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
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      height: 100.0,
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

class ClassPreLoadingBox extends StatefulWidget {
  const ClassPreLoadingBox({Key? key}) : super(key: key);

  @override
  _ClassPreLoadingBoxState createState() => _ClassPreLoadingBoxState();
}

class _ClassPreLoadingBoxState extends State<ClassPreLoadingBox> {
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
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      height: 80.0,
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

