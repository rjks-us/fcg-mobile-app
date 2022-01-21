import 'package:fcg_app/app/DateConverter.dart';
import 'package:fcg_app/app/Timetable.dart';
import 'package:fcg_app/fcgapp/components/block_spacer.dart';
import 'package:fcg_app/fcgapp/components/default_background_design.dart';
import 'package:fcg_app/fcgapp/components/error_messages.dart';
import 'package:fcg_app/fcgapp/components/timetable_card.dart';
import 'package:fcg_app/fcgapp/components/title_card.dart';
import 'package:fcg_app/fcgapp/components/title_section.dart';
import 'package:fcg_app/fcgapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

int pageViewIndex = 0, lastIndexCreated = 0, tmpdays = 0;

class MainWeekPlanContentPage extends StatefulWidget {
  const MainWeekPlanContentPage({Key? key}) : super(key: key);

  @override
  _MainWeekPlanContentPageState createState() => _MainWeekPlanContentPageState();
}

class _MainWeekPlanContentPageState extends State<MainWeekPlanContentPage> {
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

    _pages.add(MainWeekPlanWeekPageInstance(date: date));

    _days.add(date);
    refresh();
  }

  createPageDayAfter() {
    var date = _days[_days.length - 1].add(Duration(days: 1));

    while(date.weekday == 6 || date.weekday == 7) { //current day is weekend
      date = date.add(Duration(days: 1));
    }

    if(!pageHasBeenCreated(date)) {
      _pages.add(MainWeekPlanWeekPageInstance(date: date));

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
                        color: Colors.indigo,
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
            //FloatingActionButton only shown if not on page 0
            if(page > 0) {
              showActionButton = true;
              //Shows Back Button
              backPossible = true;
              refresh();
            } else if(page == 0) {
              //Hides Back Button
              backPossible = false;
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
    );
  }
}

class MainWeekPlanWeekPageInstance extends StatefulWidget {
  const MainWeekPlanWeekPageInstance({Key? key, required this.date}) : super(key: key);

  final DateTime date;

  @override
  _MainWeekPlanWeekPageInstanceState createState() => _MainWeekPlanWeekPageInstanceState();
}

class _MainWeekPlanWeekPageInstanceState extends State<MainWeekPlanWeekPageInstance> {

  DateTime _lastRefresh = new DateTime.now();

  List<Widget> _finalTimeTableCollection = [];

  List<int> _subscribedSubjectList = [];
  int _subscribedClassId = 0;

  String _dayName = '';
  String _currentDate = '';

  void _refresh() {
    if(this.mounted) setState(() {});
  }

  Future<void> _onRefresh() async {
    _lastRefresh = new DateTime.now();
    _refresh();
  }

  Future<void> _fetchTimetable() async {
    _finalTimeTableCollection = [];

    _subscribedSubjectList = await device.getDeviceCourseList();
    _subscribedClassId = await device.getDeviceClassId();

    TimetableBuilder timetableBuilder = new TimetableBuilder(widget.date, _subscribedClassId, _subscribedSubjectList);

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
    _currentDate = '${widget.date.day}. ${new DateConverter(widget.date).getMonthName()} ${widget.date.year}';
    _dayName = new DateConverter(widget.date).getWeekDayName();

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
                              _dayName,
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
                      icon: Icons.today_outlined,
                      color: Colors.indigo
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              'Dein Stundenplan',
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
                  BlockSpacer(height: 130)
                ],
              ),
            )
          ),
        ),
      )
    );
  }
}
