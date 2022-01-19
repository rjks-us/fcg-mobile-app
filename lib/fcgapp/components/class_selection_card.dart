import 'dart:async';

import 'package:fcg_app/app/Timetable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassSelectionCard extends StatefulWidget {
  const ClassSelectionCard({Key? key, required this.schoolClass, required this.onPressEvent}) : super(key: key);

  final SchoolClass schoolClass;
  final Function(BuildContext, SchoolClass) onPressEvent;

  @override
  _ClassSelectionCardState createState() => _ClassSelectionCardState();
}

class _ClassSelectionCardState extends State<ClassSelectionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(children: <Widget>[
        GestureDetector(
          onTap: () => widget.onPressEvent(context, widget.schoolClass),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 80.0,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 5, spreadRadius: 3)],
              borderRadius: BorderRadius.circular(13.0),
              color: Color.fromRGBO(255, 255, 255, 0.13),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      height: 80,
                      child: Icon(Icons.school, color: (widget.schoolClass.longName == 'Q2') ? Colors.orange : Colors.grey,),
                    ),
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
                          widget.schoolClass.shortName,
                          style: TextStyle(fontSize: 25.0, fontFamily: 'Nunito-SemiBold', color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 20),
                      child: Text(
                        (widget.schoolClass.hasTeachers) ? widget.schoolClass.teachers[0] : "-",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(fontSize: 16.0, fontFamily: 'Nunito-SemiBold', color: Colors.grey.shade300),
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
                      child: Container(
                        child: Icon(Icons.arrow_right, color: Colors.white, size: 20,),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        )
      ]),
    );
  }
}


class ClassPreLoadingCard extends StatefulWidget {
  const ClassPreLoadingCard({Key? key}) : super(key: key);

  @override
  _ClassPreLoadingCardState createState() => _ClassPreLoadingCardState();
}

class _ClassPreLoadingCardState extends State<ClassPreLoadingCard> {

  bool selected = false;

  Color from = Color.fromRGBO(48, 48, 52, 0.5);
  Color to = Color.fromRGBO(41, 40, 43, 0.5);

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 0), () {
      if(this.mounted) setState(() {
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
        if(this.mounted) setState(() {
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
