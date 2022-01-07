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
  int currentPageIndex = 0, currentPage = 0;

  DateTime currentDatePage = DateTime.now();

  bool backPossible = false, tomorrowPossible = true;

  goToLastPage() {
    goToPage(currentPage - 1);
    refresh();
  }

  goToNextPage() {
    createPageDayAfter();
    currentPage++;
    goToPage(currentPage);
    refresh();
  }

  goToPage(int index) {
    currentPage = index;
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
    lastIndexCreated = 0;
    createStartPage();
    createPageDayAfter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 70),
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black87
        ),
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Visibility(
                  child: GestureDetector(
                    onTap: ()  => goToLastPage(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Icon(Icons.arrow_back_ios_outlined, color: (backPossible ? Colors.white : Colors.grey),)
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text('Gestern', style: TextStyle(color: (backPossible ? Colors.white : Colors.grey), fontSize: 12),),
                        ),
                      ],
                    ),
                  ),
                  visible: true,
                ),
              ),
              Container(
                height: 100,
                width: 100,
                child: Transform(
                  transform: Matrix4.translationValues(0, -20, 0),
                  child: InkWell(
                    onTap: () => {goToPage(0)},
                    child: Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.only(top: 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(Icons.today, color: showActionButton ? Colors.white : Colors.grey,),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Visibility(
                  child: GestureDetector(
                    onTap: () => goToNextPage(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text('Morgen', style: TextStyle(color: Colors.white, fontSize: 12),),
                        ),
                        Container(
                            child: Icon(Icons.arrow_forward_ios_outlined, color: Colors.white,)
                        ),
                      ],
                    ),
                  ),
                  visible: tomorrowPossible,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: PageView(
          controller: pageController,
          onPageChanged: (page) {
            currentPage = page;
            print('p: ' + page.toString());
            print('l: ' + lastIndexCreated.toString());
            //FloatingActionButton only shown if not on page 0
            if(page > 0) {
              print('a');
              showActionButton = true;
              //Shows Back Button
              backPossible = true;
              refresh();
            } else if(page == 0) {
              print('b');
              //Hides Back Button
              backPossible = false;
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
  bool swappedSt = false;
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

  stSelectionWasMade(bool state) async {
    DateTime now = DateTime.now();

    saveBoolean('var-st-swap', state);
    save('var-st-swap-date', '${now.year}-${now.month}-${now.day}');

    if(this.mounted) refresh();
  }

  Future<bool> stHasToBeShown() async {
    print(await getString('var-st-swap-date'));
    print(await getBoolean('var-st-swap'));

    String data = await getString('var-st-swap-date');
    if(data != 'not-defined') {
      List<String> date = data.toString().split(' ');
      DateTime datum = new DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]));
      if(DateTime.now().difference(datum).inDays >= 25) { ///After 25 Days, the app will ask again
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  load(bool newRequest) async {

    ///Show loading boxes
    currentDay.clear();
    currentDay.addAll(tmpDay);

    refresh();

    ///Loading local variables
    classId = await getInt('var-class-id');
    selectedCourses = await getIntList('var-courses');
    swappedSt = await getBoolean('var-st-swapp');

    ///Timetable Magic

    Timetable timetable = new Timetable(widget.date, classId, selectedCourses, newRequest, () => onRefreshPress());

    await timetable.askAPI();

    if(timetable.timeTable.length != 0) {
      TimeTableElement first = timetable.timeTable[0], second = timetable.timeTable[timetable.timeTable.length - 1];
    }

    currentDay.clear();

    try {
      List<TimeTableElement> st = timetable.getStudienzeiten();

      bool visible = true;

      print(st);

      if(await stHasToBeShown() && st != [] && st.length == 4) {
        currentDay.add(QuestionCard(
          visible: visible,
          title: 'Welche Studienzeit hast du heute?',
          subtitle: 'Dies kann von dir jeder Zeit in den Einstellungen geändert werden.',
          option1: st[0].subject['name'] + ' - ' + st[0].teacher['short'],
          option2: st[1].subject['name'] + ' - ' + st[1].teacher['short'],
          callback1: () {
            print('selected ${st[0].subject['name']}');
            visible = !visible;
            if(weekNumber(widget.date).floor().isEven) {
              stSelectionWasMade(true);
            } else {
              stSelectionWasMade(false);
            }
          },
          callback2:() {
            print('selected ${st[1].subject['name']}');
            visible = !visible;
            if(weekNumber(widget.date).floor().isOdd) {
              stSelectionWasMade(true);
            } else {
              stSelectionWasMade(false);
            }
          },
        ));
      }
    } catch(_) {

    }

    currentDay.addAll(await timetable.getTimeTable());

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
                  margin: EdgeInsets.only(left: 20.0, top: 60.0, right: 20.0),
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
                  margin: EdgeInsets.all(40.0),
                  child: Text(
                    'Letztes Update ${lastRefresh.hour}:${lastRefresh.minute}\nAlle Angaben ohne Gewähr',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Nunito-Regular',
                        fontSize: 12.0,
                        color: Colors.grey
                    ),
                  ),
                ),
                BlockSpacer(height: 150)
              ],
            ),
          )
      ),
    );
  }
}
