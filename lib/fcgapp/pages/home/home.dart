import 'package:fcg_app/app/DateConverter.dart';
import 'package:fcg_app/app/Timetable.dart';
import 'package:fcg_app/fcgapp/components/block_spacer.dart';
import 'package:fcg_app/fcgapp/components/default_background_design.dart';
import 'package:fcg_app/fcgapp/components/error_messages.dart';
import 'package:fcg_app/fcgapp/components/progress_bar.dart';
import 'package:fcg_app/fcgapp/components/timetable_card.dart';
import 'package:fcg_app/fcgapp/components/title_card.dart';
import 'package:fcg_app/fcgapp/components/title_section.dart';
import 'package:fcg_app/fcgapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainHomeContentPage extends StatefulWidget {
  const MainHomeContentPage({Key? key}) : super(key: key);

  @override
  _MainHomeContentPageState createState() => _MainHomeContentPageState();
}

class _MainHomeContentPageState extends State<MainHomeContentPage> {

  DateTime _lastRefresh = new DateTime.now();

  List<Widget> _finalTimeTableCollection = [];

  List<int> _subscribedSubjectList = [];
  int _subscribedClassId = 0;

  String _username = '';
  String _currentDate = '';

  String _progressBarTitle = 'Daten werden geladen...';
  double _progressBarValue = 0.0;
  bool _progressBarVisible = true;

  void _refresh() {
    if(this.mounted) setState(() {});
  }

  Future<void> _onRefresh() async {

    print('Home refresh pressed');
    _lastRefresh = new DateTime.now();

    _refresh();

  }

  Future<void> _fetchTimetable() async {

    _finalTimeTableCollection = [];

    _subscribedSubjectList = await device.getDeviceCourseList();
    _subscribedClassId = await device.getDeviceClassId();

    TimetableBuilder timetableBuilder = new TimetableBuilder(DateTime.now(), _subscribedClassId, _subscribedSubjectList);

    await timetableBuilder.loadTimeTable();

    if(timetableBuilder.noResult) {
      _finalTimeTableCollection.add(new NoEntryFoundError(refreshPressed: () => _refresh()));
    } else if(timetableBuilder.holiday) {
      _finalTimeTableCollection.add(new HolidayMessage(refreshPressed: () => _refresh(), holidayName: timetableBuilder.timetableHoliday.longName,));
    } else if(timetableBuilder.weekend) {
      _finalTimeTableCollection.add(new WeekendMessage(refreshPressed: () => _refresh()));
    } else if(timetableBuilder.error) {
      _finalTimeTableCollection.add(new NoConnectionAvailableError(refreshPressed: () => _refresh()));
    } else {
      _finalTimeTableCollection = await timetableBuilder.toWidget(true);
    }
  }

  Future<void> loadDeviceInformation() async {
    _username = await device.getDeviceUsername();

    _currentDate = '${DateTime.now().day}. ${new DateConverter(DateTime.now()).getMonthName()} ${DateTime.now().year}';

    _refresh();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDeviceInformation();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: RefreshIndicator(
          backgroundColor: Color.fromRGBO(29, 29, 29, 1),
          color: Colors.indigo,
          onRefresh: _onRefresh,
          child: DefaultBackgroundDesign(
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20.0, top: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Guten Tag $_username',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'Nunito-Regular',
                                fontSize: 29.0,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                  TitleContentCard(
                      title: _currentDate,
                      icon: Icons.calendar_today_rounded,
                      color: Colors.indigo
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              'Dein Tag',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: 'Nunito-Regular',
                                  fontSize: 22.0,
                                  color: Colors.white
                              ),
                            ),
                          ),
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.refresh),
                              color: Colors.white,
                              onPressed: () => _onRefresh(),
                            )
                          ),
                        ],
                      )
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 15.0, right: 20.0),
                    child: ProgressBarCard(
                      subtitle: 'Dein Tagesfortschritt',
                      title: _progressBarTitle,
                      value: _progressBarValue,
                      visible: _progressBarVisible,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 20.0, top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              'Heute',
                              textAlign: TextAlign.start,
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
                  Container(
                    child: FutureBuilder(
                      future: _fetchTimetable(),
                      builder: (context, AsyncSnapshot snapshot) {

                        if(snapshot.connectionState == ConnectionState.waiting) {
                          ///preview loading animation

                          return new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              TimetablePreLoadingCard(),
                              TimetablePreLoadingCard(),
                              TimetablePreLoadingCard(),
                              TimetablePreLoadingCard(),
                              TimetablePreLoadingCard(),
                            ],
                          );
                        } else {
                          ///Release data

                          return new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: _finalTimeTableCollection,
                          );
                        }

                      },
                    )
                  ),
                  SmallSubInformationTextText(
                      title: 'Letztes Update ${_lastRefresh.hour}:${_lastRefresh.minute}\nAlle Angaben ohne Gewähr'
                  ),
                  BlockSpacer(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
