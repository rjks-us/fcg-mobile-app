import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Line extends StatefulWidget {
  const Line({Key? key, required this.title, required this.blurred}) : super(key: key);

  final String title;
  final bool blurred;

  @override
  _LineState createState() => _LineState();
}

class _LineState extends State<Line> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 20.0, bottom: 10, right: 20.0, top: 10),
        child: Opacity(
          opacity: widget.blurred ? 0.6 : 1,
          child: Center(
            child: Text(
              widget.title,
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        )
    );
  }
}