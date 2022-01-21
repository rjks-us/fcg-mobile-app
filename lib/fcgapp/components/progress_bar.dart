import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressBarCard extends StatefulWidget {
  const ProgressBarCard({Key? key, required this.subtitle, required this.title, required this.value, required this.visible}) : super(key: key);

  final String subtitle, title;
  final double value;
  final bool visible;

  @override
  _ProgressBarCardState createState() => _ProgressBarCardState();
}

class _ProgressBarCardState extends State<ProgressBarCard> {

  Timer? _timer;

  void _refresh() {
    if(this.mounted) setState(() {});
  }

  void _refreshSchedule() {
    _timer = new Timer(Duration(seconds: 3), () {
      print('aaa');
      if(this.mounted) {
        _refresh();
      } else {
        _timer!.cancel();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.13),
        borderRadius: BorderRadius.circular(13.0),
      ),
      child: Visibility(
        visible: widget.visible,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
              child: Text(widget.subtitle, textAlign: TextAlign.left, style: TextStyle(fontSize: 12, color: Colors.grey),),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Text(widget.title, textAlign: TextAlign.left, style: TextStyle(fontSize: 16, color: Colors.white),),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 10),
              child: Center(
                child: LinearProgressIndicator(
                  value: widget.value,
                  minHeight: 8,
                  backgroundColor: Colors.black12,
                  color: Colors.indigo,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
