import 'dart:async';

import 'package:fcg_app/api/helper.dart';
import 'package:fcg_app/api/utils.dart';
import 'package:fcg_app/main.dart';
import 'package:fcg_app/pages/components/comp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../modal/modal_bottom_sheet.dart';

class WeekScreen extends StatefulWidget {
  const WeekScreen({Key? key}) : super(key: key);

  @override
  _WeekScreenState createState() => _WeekScreenState();
}

int pageViewIndex = 0, lastIndexCreated = 0, tmpdays = 0;

class _WeekScreenState extends State<WeekScreen> {

  List<Widget> _pages = <Widget>[];
  List<DateTime> _days = <DateTime>[];

  final PageController pageController = PageController();
  bool showActionButton = false;
  int currentPageIndex = 0;

  goToPage(int index) {
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  refresh() {
    setState(() {});
  }

  pageHasBeenCreated(DateTime date) {
    return _days.contains(date);
  }

  getCurrentPage(int page) {
    pageViewIndex = page;
  }

  createStartPage() {
    var date = DateTime.now();

    while(date.weekday == 6 || date.weekday == 7) { /// current day is weekend
      date = date.add(Duration(days: 1));
    }

    _pages.add(WeekPage(date: date));

    _days.add(date);
    refresh();
  }

  createPageDayAfter() {
    var date = _days[_days.length - 1].add(Duration(days: 1));

    while(date.weekday == 6 || date.weekday == 7) { //current day is weekend
      date = date.add(Duration(days: 1));
    }

    if(!pageHasBeenCreated(date)) {
      _pages.add(WeekPage(date: date));

      lastIndexCreated++;

      _days.add(date);
      refresh();
    }
  }

  showTutorial() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Wische nach rechts und links um die Seite zu wechseln"),
    ));
  }

  @override
  void initState() {
    super.initState();
    createStartPage();
    createPageDayAfter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PageView(
          controller: pageController,
          onPageChanged: (page) {
            //FloatingActionButton only shown if not on page 0
            if(page > 0) {
              showActionButton = true;
              refresh();
            } else if(page == 0) {
              showActionButton = false;
              refresh();
            }

            //Dynamically add next page if last page is shown
            if((page) == lastIndexCreated) {
              lastIndexCreated = page;
              return createPageDayAfter();
            }
          },
          pageSnapping: true,
          children: _pages,
        ),
      ),
      floatingActionButton: Visibility(
        visible: showActionButton,
        child: FloatingActionButton(
          onPressed: () => {goToPage(0)},
          tooltip: 'Zurück zu heute',
          child: Icon(Icons.arrow_back, color: Colors.white,),
        ),
      )
    );
  }
}

class WeekPage extends StatefulWidget {
  const WeekPage({Key? key, required this.date}) : super(key: key);

  final DateTime date;

  @override
  _WeekPageState createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> {

  List<String> days = ['Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag'];
  List<String> month = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];

  ///temporary list to simulate loading animation
  List<Widget> tmpElements = [
    TimetableElement(time: '8:30', hour: '1.', title: 'Biologie GK-2', subtitle: 'Ch1 - Eike Lückerath', status: 0, data: {},),
    TimetableElement(time: '9:15', hour: '2.', title: 'Religion GK-4', subtitle: 'K6 - Veit Reiß', status: 1, data: {},),
    TimetableElement(time: '10:20', hour: '3.', title: 'Mathematik GK-3', subtitle: 'K8 - Liv Marqiass', status: 2, data: {},),
    TimetableElement(time: '11:05', hour: '4.', title: 'Mathematik GK-3', subtitle: 'K8 - Liv Marqiass', status: 2, data: {},),
    TimetableElement(time: '12:50', hour: '5.', title: 'Sport GK-1', subtitle: 'SCH - Liv Marqiass', status: 0, data: {},),
    TimetableElement(time: '13:25', hour: '6.', title: 'Sport GK-1', subtitle: 'SCH - Liv Marqiass', status: 0, data: {},),
  ];

  List<Widget> classElements = [
    TimeTablePreLoadingBox(time: '8:30'),
    TimeTablePreLoadingBox(time: '9:15'),
    TimeTablePreLoadingBox(time: '10:20'),
    TimeTablePreLoadingBox(time: '11:05'),
    TimeTablePreLoadingBox(time: '11:50'),
    TimeTablePreLoadingBox(time: '12:50'),
    TimeTablePreLoadingBox(time: '13:25'),
  ];

  @override
  void initState() {
    super.initState();
    loadElements();
  }

  loadElements() async {
    Timer(Duration(seconds: 2), () {
      try { /// <-- To many elements in queue
        if(this.mounted) {
          setState(() {
            classElements.clear();

            tmpElements.forEach((element) {
              classElements.add(element);
            });
          });
        }
      } catch(err) {
        print(err); ///<-- This error should definitely not occur ~ rk
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
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
          child: new SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0),
                  child: Text(
                    //'${days[widget.date.weekday - 1]}, ${widget.date.day}. ${month[widget.date.month - 1]} ${widget.date.year}',
                    '${days[widget.date.weekday - 1]}',
                    style: TextStyle(
                        fontFamily: 'Nunito-Regular',
                        fontSize: 29.0,
                        color: Colors.white
                    ),
                  ),
                ),
                AlertBox(
                  color: Colors.indigoAccent,
                    text: '${widget.date.day}. ${month[widget.date.month - 1]} ${widget.date.year}',
                    label: Icon(Icons.today_outlined, size: 30, color: Colors.white,)
                ),
                Container(
                  child: Column(
                    children: classElements,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: Text(
                    'Letztes update 21:11',
                    style: TextStyle(
                        fontFamily: 'Nunito-Regular',
                        fontSize: 12.0,
                        color: Colors.grey
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
