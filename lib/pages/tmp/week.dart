import 'dart:async';

import 'package:fcg_app/api/helper.dart';
import 'package:fcg_app/api/timetable.dart';
import 'package:fcg_app/api/utils.dart';
import 'package:fcg_app/main.dart';
import 'package:fcg_app/pages/components/comp.dart';
import 'package:fcg_app/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:fcg_app/api/httpBuilder.dart' as httpBuilder;
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
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          child: PageView(
            controller: pageController,
            onPageChanged: (page) {
              print(page);
              //FloatingActionButton only shown if not on page 0
              if(page > 0) {
                print('a');
                showActionButton = true;
                refresh();
              } else if(page == 0) {
                print('b');
                showActionButton = false;
                refresh();
              }

              //Dynamically add next page if last page is shown
              if((page) == lastIndexCreated) {
                print('c');
                lastIndexCreated = page;
                return createPageDayAfter();
              }
            },
            pageSnapping: true,
            children: _pages,
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: showActionButton,
        child: Container(
          margin: EdgeInsets.all(20),
          child: FloatingActionButton(
            onPressed: () => {goToPage(0)},
            tooltip: 'Zurück zu heute',
            child: Icon(Icons.arrow_back, color: Colors.white,),
          ),
        )
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

  DateTime lastRefresh = DateTime.now();
  int classId = 0;
  List<int> selectedCourses = [];

  List<String> days = ['Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag'];
  List<String> month = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];

  List<Widget> currentDay = [],
      tmpDay = [
        TimeTablePreLoadingBox(time: '8:30'),
        TimeTablePreLoadingBox(time: '9:15'),
        TimeTablePreLoadingBox(time: '10:20'),
        TimeTablePreLoadingBox(time: '11:05'),
        TimeTablePreLoadingBox(time: '11:50'),
        TimeTablePreLoadingBox(time: '12:50'),
        TimeTablePreLoadingBox(time: '13:25'),
        TimeTablePreLoadingBox(time: '14:30'),
        TimeTablePreLoadingBox(time: '15:15'),
        TimeTablePreLoadingBox(time: '16:05'),
        TimeTablePreLoadingBox(time: '16:55'),
      ];

  refresh() {
    if(this.mounted) setState(() {});
  }

  onRefreshPress() async {
    await load(true);
  }

  load(bool newRequest) async {

    ///Show loading boxes
    currentDay.clear();
    currentDay.addAll(tmpDay);

    refresh();

    ///Loading local variables
    classId = await getInt('var-class-id');
    selectedCourses = await getIntList('var-courses');

    ///Check if it is weekend
    if(lastRefresh.weekday == 6 || lastRefresh.weekday == 7) {
      currentDay.add(Container(
        child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  child: Center(
                    child: Icon(Icons.weekend, size: 40, color: Colors.grey,),
                  ),
                ),
                Container(
                  child: Center(
                    child: Text(
                      'Heute ist Wochenende,\n du hast keine Schule',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            )
        ),
      ));
      if(this.mounted) refresh();
      return;
    }

    ///Request
    httpBuilder.Request request = new httpBuilder.Request('GET', 'v1/timetable/$classId/${widget.date.year}/${widget.date.month}/${widget.date.day}', true, newRequest, !newRequest);
    httpBuilder.Response response = await request.flush();
    await response.checkCache();

    currentDay.clear();

    response.onSuccess((timetable) {

      List<int> hours = [0];

      timetable.forEach((element) async {
        var subject = element['subject'], start = element['start'], end = element['end'], teacher = element['teacher'], status = element['status'];

        int classStatus = 0;

        String teacherName = '${teacher['firstname']} ${teacher['lastname']}';

        if(teacher['firstname'] == null || teacher['lastname'] == null) teacherName = '-';
        if(teacherName.split('')[0] == ' ') teacherName = teacherName.substring(1, teacherName.length);

        if(selectedCourses.contains(subject['id'])) {
          var block = getBlockNumberFromTime('${start['hour']}:${start['minute']}');
          var lastItem = hours[hours.length - 1];

          if(hours[hours.length - 1] + 1 != block) {
            int lastBlock = 0;
            for(int i = lastItem + 1; i < block; i++) {
              lastBlock = i;
              currentDay.add(TimeTableFreeElement(hour: '$i.', time: getTimeFromBlockNumber(i), isOver: (DateTime.now().isAfter(getDateTimeFromBlockNumber(block, widget.date)))));
            }
            hours.add(lastBlock);
          }
          bool visible = true;

          if(status['type'] == 'CLASS') {
            classStatus = 0;
          } else if(status['type'] == 'CANCELED') {
            classStatus = 1;
          } else if(status['type'] == 'INFO') {
            classStatus = 2;
            visible = false;
          }

          if(visible) {
            hours.add(block);
            currentDay.add(TimetableElement(
              status: classStatus,
              hour: '$block.',
              time: '${start['hour']}:${start['minute']}',
              title: subject['name'],
              subtitle: teacherName,
              data: element,
              isOver: (DateTime.now().isAfter(getDateTimeFromBlockNumber(block, widget.date)))
            ));
          }
        }
      });
      lastRefresh = DateTime.now();
    });

    response.onNoResult((data) { ///No connection
      currentDay.add(NoInternetConnectionScreen(refresh: () {
        onRefreshPress();
      }));
      if(this.mounted) refresh();
    });

    response.onError((data) { ///Server Error
      currentDay.add(AnErrorOccurred(refresh: () {
        onRefreshPress();
      }));
      if(this.mounted) refresh();
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
                    children: currentDay,
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
