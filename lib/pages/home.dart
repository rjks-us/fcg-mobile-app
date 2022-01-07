import 'dart:async';

import 'package:fcg_app/api/timetable.dart';
import 'package:fcg_app/api/utils.dart';
import 'package:fcg_app/main.dart';
import 'package:fcg_app/pages/components/comp.dart';
import 'package:fcg_app/pages/event/app_start_alert.dart';
import 'package:fcg_app/pages/settings/pastnotifications.dart';
import 'package:fcg_app/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:fcg_app/api/httpBuilder.dart' as httpBuilder;
import 'package:fcg_app/device/device.dart' as device;

import '../modal/modal_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DateTime lastRefresh = DateTime.now();
  String username = '';
  int classId = 0;
  List<int> selectedCourses = [];

  bool hasSchool = false;
  double daySprintValue = 0.0;
  String daySprintText = 'Dein Tag steht noch vor dir';

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
    print('refresh home button pressed');
    await load(true);

    WidgetsFlutterBinding.ensureInitialized();

    PageCollection pageCollection = new PageCollection(false);

    pageCollection.addPage(Container(
      height: 100,
      color: Colors.transparent,
      child: Center(
        child: Icon(Icons.pages, color: Colors.white,),
      ),
    ));

    pageCollection.addPage(Container(
      height: 100,
      color: Colors.transparent,
      child: Center(
        child: Icon(Icons.swap_horiz, color: Colors.white,),
      ),
    ));

    pageCollection.addPage(Container(
      height: 100,
      color: Colors.transparent,
      child: Center(
        child: Icon(Icons.account_box, color: Colors.white,),
      ),
    ));

    createAppStartAlertDialog(context, pageCollection);
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
    username = await getString('var-username');
    classId = await getInt('var-class-id');
    selectedCourses = await getIntList('var-courses');

    ///Timetable Magic

    Timetable timetable = new Timetable(lastRefresh, classId, selectedCourses, newRequest, () => onRefreshPress());

    await timetable.askAPI();

    ///Daily progess bar
    if(timetable.timeTable.length != 0) {
      try {
        TimeTableElement first = timetable.timeTable[0], second = timetable.timeTable[timetable.timeTable.length - 1];

        print(timetable.dateTime.toString());

        for(int i = 0; i < timetable.timeTable.length; i++) {
          if(!timetable.timeTable[i].isFree() && timetable.timeTable[i].classStatus == 0 || timetable.timeTable[i].classStatus == 2) {
            first = timetable.timeTable[i];
            break;
          }
        }

        for(int i = timetable.timeTable.length - 1; i >= 0; i--) {
          if(!timetable.timeTable[i].isFree() && timetable.timeTable[i].classStatus == 0 || timetable.timeTable[i].classStatus == 2) {
            second = timetable.timeTable[i];
            break;
          }
        }

        DateTime start = new DateTime(int.parse(first.date['year']), int.parse(first.date['month']), int.parse(first.date['day']), int.parse(first.start['hour']), int.parse(first.end['minute']));
        DateTime end = new DateTime(int.parse(second.date['year']), int.parse(second.date['month']), int.parse(second.date['day']), int.parse(second.end['hour']), int.parse(second.end['minute']));
        // DateTime now = new DateTime(2021, 12, 22, 11, 50);
        DateTime now = new DateTime.now();
        //
        if(start.isAfter(now)) {
          daySprintValue = 0.0;
        } else if(end.isBefore(now)) {
          daySprintValue = 1.0;
          daySprintText = 'Du hast den Tag geschafft!';
        } else {
          int total = DateTimeRange(start: start, end: end).duration.inSeconds;
          int ago = DateTimeRange(start: start, end: now).duration.inSeconds;

          int current = total - ago;

          print(total);
          print(ago);
          print(current);

          daySprintValue = 1.0 - ((current / total) * 100) / 100;

          daySprintText = 'Du hast bereits ${(daySprintValue * 100).toStringAsFixed(0)}% geschafft';

          print('total: ' + daySprintValue.toString());
        }

      } catch(_) {
        print(_);
      }
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
            if(weekNumber(lastRefresh).floor().isEven) {
              stSelectionWasMade(true);
            } else {
              stSelectionWasMade(false);
            }
          },
          callback2:() {
            print('selected ${st[1].subject['name']}');
            visible = !visible;
            if(weekNumber(lastRefresh).floor().isOdd) {
              stSelectionWasMade(true);
            } else {
              stSelectionWasMade(false);
            }
          },
        ));
      }
    } catch(_) {

    }

    hasSchool = timetable.hasSchool();

    currentDay.addAll(await timetable.getTimeTable());

    lastRefresh = new DateTime.now();

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

  showTutorial() async {
    if(await isSet('tutorial-home-screen-1')) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Klicke auf die Stunden um mehr Informationen zu sehen"),
    ));

    saveBoolean('tutorial-home-screen-1', true);
  }

  Future<void> _refresh() async {
    await load(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: RefreshIndicator(
          backgroundColor: Color.fromRGBO(29, 29, 29, 1),
          color: Colors.indigo,
          onRefresh: _refresh,
          child: VisibilityDetector(
            key: Key('week-home-dec-${randomKey()}'), /// <-- idk why this is needed, to not touch
            onVisibilityChanged: (info) {
              //load();
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.centerRight,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Guten Tag $username',
                                style: TextStyle(
                                    fontFamily: 'Nunito-Regular',
                                    fontSize: 29.0,
                                    color: Colors.white
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(
                                  Icons.notifications_active_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(builder: (context) => NotificationList())
                                  );
                                },
                              )
                            )
                          ],
                        )
                    ),
                    AlertBox(
                      color: Colors.indigo,
                      text: '17. November 2021',
                      label: Icon(Icons.calendar_today_rounded, size: 30, color: Colors.white,),
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Dein Tag',
                                style: TextStyle(
                                    fontFamily: 'Nunito-Regular',
                                    fontSize: 22.0,
                                    color: Colors.white
                                ),
                              ),
                            ),
                            Container(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => {onRefreshPress()},
                                )
                            )
                          ],
                        )
                    ),
                    Container(
                      child: Visibility(
                        visible: hasSchool,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(20.00),
                              child: ProgressCard(subtitle: 'Dein Tagesfortschritt', value: daySprintValue, title: daySprintText,),
                            ),
                            Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        'Heute',
                                        style: TextStyle(
                                            fontFamily: 'Nunito-Regular',
                                            fontSize: 22.0,
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
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
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Nunito-Regular',
                            fontSize: 12.0,
                            color: Colors.grey
                        ),
                      ),
                    ),
                    BlockSpacer(height: 100)
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}
