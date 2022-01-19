import 'dart:async';

import 'package:fcg_app/app/Timetable.dart';
import 'package:fcg_app/fcgapp/components/subtitle_of_element.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseCollectionSectionCard extends StatefulWidget {
  const CourseCollectionSectionCard({Key? key, required this.title, required this.schoolCourseCollection, required this.onClickEvent}) : super(key: key);

  final String title;
  final Function(SchoolCourse, bool) onClickEvent;
  final List<SchoolCourse> schoolCourseCollection;
  
  @override
  _CourseCollectionSectionCardState createState() => _CourseCollectionSectionCardState();
}

class _CourseCollectionSectionCardState extends State<CourseCollectionSectionCard> {
  
  List<Widget> formatSchoolCourseObjectToWidgetList(List<SchoolCourse> list) {
    List<Widget> _widgets = [];
    
    list.forEach((element) => _widgets.add(CourseSelectionCard(schoolCourse: element, blureOnClick: false, onClickEvent: (schoolCourse, state) => widget.onClickEvent(schoolCourse, state))));
    
    return _widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        Line(title: widget.title, blurred: false),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: formatSchoolCourseObjectToWidgetList(widget.schoolCourseCollection),
        )
      ]),
    );
  }
}


class CourseSelectionCard extends StatefulWidget {
  const CourseSelectionCard({Key? key, required this.schoolCourse, required this.blureOnClick, required this.onClickEvent}) : super(key: key);

  final bool blureOnClick;
  final SchoolCourse schoolCourse;
  final Function(SchoolCourse, bool) onClickEvent;
  
  @override
  _CourseSelectionCardState createState() => _CourseSelectionCardState();
}

class _CourseSelectionCardState extends State<CourseSelectionCard> {
  bool _selected = false;

  void _cardClickedEvent() {
    if(this.mounted) setState(() {
      _selected = !_selected;
    });
    widget.onClickEvent(widget.schoolCourse, _selected);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 20, bottom: 20, right: 20),
        width: MediaQuery.of(context).size.width,
        height: 80.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13.0),
          color: (widget.blureOnClick) ?
          ((_selected) ? Color.fromRGBO(255, 255, 255, 0.05) : Color.fromRGBO(255, 255, 255, 0.13)) :
          ((_selected) ? Colors.indigo : Color.fromRGBO(255, 255, 255, 0.13)),
          boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 5, spreadRadius: 3)],
        ),
        child: InkWell(
          onTap: () => _cardClickedEvent(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 20),
                  height: 100,
                  width: 270,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          child: Flexible(
                            child: Text(
                              '${widget.schoolCourse.longName} - ${widget.schoolCourse.shortName}',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 19.0, fontFamily: 'Nunito-SemiBold',
                                  color: (widget.blureOnClick) ?
                                  ((_selected) ? Colors.grey.shade400 : Colors.grey.shade300) :
                                  (Colors.grey.shade300),
                              ),
                            ),
                          )
                      ),
                      Container(
                          child: Flexible(
                            child: Text(
                              'Bei ${widget.schoolCourse.timetableTeacher.getFullName()}',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16.0, fontFamily: 'Nunito-SemiBold',
                                  color: (widget.blureOnClick) ?
                                  ((_selected) ? Colors.grey.shade500 : Colors.grey.shade400) :
                                  (Colors.grey.shade400),
                              ),
                            ),
                          )
                      )
                    ],
                  )
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(3),
                width: 20,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(13),
                        bottomRight: Radius.circular(13)),
                    color: (widget.blureOnClick) ?
                    ((_selected) ? Color.fromRGBO(63, 81, 181, 0.7) : Colors.indigo) :
                    (Colors.indigo),
                ),
              ),
            ],
          ),
        )
    );
  }
}


class CoursePreLoadingCard extends StatefulWidget {
  const CoursePreLoadingCard({Key? key}) : super(key: key);

  @override
  _CoursePreLoadingCardState createState() => _CoursePreLoadingCardState();
}

class _CoursePreLoadingCardState extends State<CoursePreLoadingCard> {

  ///TODO: Add also a preloading box for the old "line"

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
