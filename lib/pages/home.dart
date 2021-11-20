import 'dart:async';

import 'package:fcg_app/api/timetable.dart';
import 'package:fcg_app/api/utils.dart';
import 'package:fcg_app/main.dart';
import 'package:fcg_app/pages/components/comp.dart';
import 'package:fcg_app/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:visibility_detector/visibility_detector.dart';

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

  List<Widget> currentDay = [];

  refresh() {
    setState(() {});
  }

  load() async {
    currentDay.clear();

    refresh();

    currentDay = [
      TimeTablePreLoadingBox(time: '8:30'),
      TimeTablePreLoadingBox(time: '9:15'),
      TimeTablePreLoadingBox(time: '10:20'),
      TimeTablePreLoadingBox(time: '11:05'),
      TimeTablePreLoadingBox(time: '11:50'),
      TimeTablePreLoadingBox(time: '12:50'),
      TimeTablePreLoadingBox(time: '13:25'),
    ];

    username = await getString('var-username');
    classId = await getInt('var-class-id');
    selectedCourses = await getIntList('var-courses');

    List<dynamic>? timetable = await getTimeTable(DateTime.now(), classId);
    Timer(Duration(seconds: 2), () {
      try { /// <-- To many elements in queue
        if(this.mounted) {
          setState(() {
            currentDay.clear();

            if(timetable == null || timetable.length == 0) {
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
              } else {
                currentDay.add(Container(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          child: Center(
                            child: Icon(Icons.wifi_off, size: 40, color: Colors.grey,),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              'Es besteht keine Verbindung\nzum Internet',
                              style: TextStyle(color: Colors.grey, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                ));
              }

              refresh();
              return;
            }

            timetable.forEach((element) {
              var subject = element['subject'], start = element['start'], end = element['end'], teacher = element['teacher'];

              String teacherName = '${teacher['firstname']} ${teacher['lastname']}';

              if(teacher['firstname'] == null || teacher['lastname'] == null) teacherName = '-';
              if(teacherName.split('')[0] == ' ') teacherName = teacherName.substring(1, teacherName.length);

              if(selectedCourses.contains(subject['id'])) {
                currentDay.add(TimetableElement(status: 0, hour: '1.', time: '${start['hour']}:${start['minute']}', title: subject['name'], subtitle: teacherName));
              }
            });
            lastRefresh = DateTime.now();
            refresh();
          });
        }
      } catch(err) {
        print(err); ///<-- This error should definitely not occur ~ rk
      }
    });
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  void onRefreshPress() async {
    await load();
  }

  showTutorial() async {
    if(await isSet('tutorial-home-screen-1')) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Klicke auf die Stunden um mehr Informationen zu sehen"),
    ));

    saveBoolean('tutorial-home-screen-1', true);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0),
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
                        /*Container( ///<--- Settings Gear, moved to nav bar
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            onPressed: () => {onSettingsPress()},
                          )
                      )*/
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
                  child: Column(
                    children: currentDay,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: Text(
                    'Letztes update ${lastRefresh.hour}:${lastRefresh.minute}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Nunito-Regular',
                        fontSize: 12.0,
                        color: Colors.grey
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
