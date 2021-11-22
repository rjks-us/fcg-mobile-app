import 'dart:async';

import 'package:fcg_app/api/timetable.dart';
import 'package:fcg_app/api/utils.dart';
import 'package:fcg_app/main.dart';
import 'package:fcg_app/pages/components/comp.dart';
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
    username = await getString('var-username');
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
    httpBuilder.Request request = new httpBuilder.Request('GET', 'v1/timetable/$classId/${lastRefresh.year}/${lastRefresh.month}/${lastRefresh.day}', true, newRequest, !newRequest);
    httpBuilder.Response response = await request.flush();
    await response.checkCache();

    response.onSuccess((timetable) {
      currentDay.clear();

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

          if(lastItem + 1 != block && lastItem < block) {
            int lastBlock = 0;
            print((lastItem + 1));

            for(int i = lastItem + 1; i < block; i++) {
              lastBlock = i;
              currentDay.add(TimeTableFreeElement(hour: '$i.', time: getTimeFromBlockNumber(i), isOver: (DateTime.now().isAfter(getDateTimeFromBlockNumber(block, DateTime.now()))),));
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
              isOver: (DateTime.now().isAfter(getDateTimeFromBlockNumber(block, DateTime.now())))
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
    });

    response.onError((data) { ///Server Error
      currentDay.add(AnErrorOccurred(refresh: () {
        onRefreshPress();
      }));
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

  showTutorial() async {
    if(await isSet('tutorial-home-screen-1')) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Klicke auf die Stunden um mehr Informationen zu sehen"),
    ));

    saveBoolean('tutorial-home-screen-1', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: ScrollController(),
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
        ),
      ),
    );
  }
}
