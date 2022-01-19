import 'dart:async';

import 'package:fcg_app/app/Timetable.dart';
import 'package:fcg_app/app/utils/TimetableUtils.dart';
import 'package:fcg_app/fcgapp/components/subtitle_of_element.dart';
import 'package:fcg_app/fcgapp/utils/timetable/timetable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimetableContentCard extends StatefulWidget {
  const TimetableContentCard({Key? key, required this.timetableEntry, required this.activeBlock, required this.isOver}) : super(key: key);

  final TimetableEntry timetableEntry;
  final int activeBlock;
  final bool isOver;

  @override
  _TimetableContentCardState createState() => _TimetableContentCardState();
}

class _TimetableContentCardState extends State<TimetableContentCard> {

  Color getColor(int state) {
    switch(state) {
      case 0: return Colors.green;
      case 1: return Colors.red;
      case 2: return Colors.orange;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Opacity(
        opacity: widget.isOver ? 0.6 : 1,
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
          child: IntrinsicHeight(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              Container(
                width: 40,
                  margin: EdgeInsets.only(left: 5, bottom: 10, right: 20.0, top: 10),
                  child: Opacity(
                    opacity: widget.isOver ? 0.6 : 1,
                    child: Text(
                      getTimeFromBlockNumber(widget.activeBlock),
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  )
              ),
              Expanded(child: GestureDetector(
                onTap: () => showTimeTableBottomModalContext(context, widget.timetableEntry),
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  height: 60.0,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 60,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15)),
                              ),
                              child: Center(
                                child: Text(
                                  widget.activeBlock.toString(),
                                  style: TextStyle(fontSize: 22.0, fontFamily: 'Nunito-SemiBold', color: Colors.white),
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
                                        widget.timetableEntry.timetableSubject.name,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 16.0, fontFamily: 'Nunito-SemiBold', color: Colors.grey.shade300),
                                      ),
                                    ),
                                    Container(
                                      width: 180,
                                      child: Text(
                                        widget.timetableEntry.timetableTeacher.getFullName(),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 12.0, fontFamily: 'Nunito-SemiBold', color: Colors.grey.shade400),
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
                            color: getColor(widget.timetableEntry.timetableEntryState.state)
                        ),
                      ),
                    ],
                  ),
                ),
              ))
            ]),
          ),
        ),
      ),
    );
  }
}

class TimetableEmptyCard extends StatefulWidget {
  const TimetableEmptyCard({Key? key, required this.hour, required this.time, required this.isOver}) : super(key: key);

  final bool isOver;
  final String hour, time;

  @override
  _TimetableEmptyCardState createState() => _TimetableEmptyCardState();
}

class _TimetableEmptyCardState extends State<TimetableEmptyCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Opacity(
        opacity: widget.isOver ? 0.6 : 1,
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
          child: IntrinsicHeight(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              Container(
                  width: 40,
                  margin: EdgeInsets.only(left: 5, bottom: 10, right: 20.0, top: 10),
                  child: Opacity(
                    opacity: widget.isOver ? 0.6 : 1,
                    child: Text(
                      widget.time,
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  )
              ),
              Expanded(child: GestureDetector(
                onTap: () => {},
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  height: 60.0,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 60,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15)),
                              ),
                              child: Center(
                                child: Text(
                                  widget.hour,
                                  style: TextStyle(fontSize: 22.0, fontFamily: 'Nunito-SemiBold', color: Colors.white),
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
                                        style: TextStyle(fontSize: 16.0, fontFamily: 'Nunito-SemiBold', color: Colors.grey.shade300),
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
                ),
              ))
            ]),
          ),
        ),
      ),
    );
  }
}

class TimetablePreLoadingCard extends StatefulWidget {
  const TimetablePreLoadingCard({Key? key}) : super(key: key);

  @override
  _TimetablePreLoadingCardState createState() => _TimetablePreLoadingCardState();
}

class _TimetablePreLoadingCardState extends State<TimetablePreLoadingCard> {

  ///TODO: Add also a preloading box for the old "line"

  bool selected = false;

  Color from = Color.fromRGBO(48, 48, 52, 0.5);
  Color to = Color.fromRGBO(41, 40, 43, 0.5);

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 0), () {
      if(this.mounted) {
        setState(() {
          selected = !selected;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
      height: 60.0,
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
