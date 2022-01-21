import 'package:fcg_app/app/Timetable.dart';
import 'package:fcg_app/fcgapp/components/block_spacer.dart';
import 'package:fcg_app/fcgapp/components/buttons.dart';
import 'package:fcg_app/fcgapp/components/course_card.dart';
import 'package:fcg_app/fcgapp/components/default_background_design.dart';
import 'package:fcg_app/fcgapp/components/error_messages.dart';
import 'package:fcg_app/fcgapp/components/signature.dart';
import 'package:fcg_app/fcgapp/components/title_section.dart';
import 'package:fcg_app/network/RequestHandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetCoursesPage extends StatefulWidget {
  const SetCoursesPage({Key? key, required this.selectedClass, required this.onFinishEvent}) : super(key: key);

  final SchoolClass selectedClass;
  final Function(BuildContext, List<SchoolCourse>) onFinishEvent;

  @override
  _SetCoursesPageState createState() => _SetCoursesPageState();
}

class _SetCoursesPageState extends State<SetCoursesPage> {

  List<SchoolCourse> _selectedSchoolCourses = [];

  List<Widget> _finalLoadedCourseCollectionList = [];

  void _refresh() {
    if(this.mounted) setState(() {});
  }

  Future<void> _onRefresh() async {
    _refresh();
  }

  void _onFinishPress() {
    if(_selectedSchoolCourses.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Bitte wähle mindestens einen Kurs aus"),
      ));
    } else {
      widget.onFinishEvent(context, _selectedSchoolCourses);
    }
  }

  void _onCourseSelected(SchoolCourse schoolClass) {
    if(_selectedSchoolCourses.contains(schoolClass)) {
      _selectedSchoolCourses.remove(schoolClass);
    } else {
      _selectedSchoolCourses.add(schoolClass);
    }
  }

  Future<void> _fetchClasses() async {
    _selectedSchoolCourses = [];
    _finalLoadedCourseCollectionList = [];

    print('reloaded');

    TimetableHandler _timetableHandler = new TimetableHandler();

    List<TimetableSubjectCollection> _courseList = await _timetableHandler.getOrderedSubjectList(widget.selectedClass.id);

    _courseList.forEach((element) {
      _finalLoadedCourseCollectionList.add(new CourseCollectionSectionCard(
          title: '${element.name}',
          schoolCourseCollection: element.list,
          onClickEvent: (course, selected) {
            _onCourseSelected(course);
            print('[SETUP] ${course.longName} has been subscribed to: $selected');
          }
      ));
    });

    if(_finalLoadedCourseCollectionList.length == 0) {
      bool _connectionAvailable = await deviceIsConnectedToInternet();

      if(!_connectionAvailable) {
        _finalLoadedCourseCollectionList.add(NoConnectionAvailableError(refreshPressed: () {
          if(this.mounted) setState(() {});
        }));
      } else {
        _finalLoadedCourseCollectionList.add(NoEntryFoundError(refreshPressed: () {
          if(this.mounted) setState(() {});
        }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(29, 29, 29, 1),
            ),
            width: MediaQuery.of(context).size.width,
            child: PrimaryButton(
              active: true,
              title: 'Nächster Schritt',
              onClickEvent: _onFinishPress,
            )
        ),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(54, 66, 106, 1),
          elevation: 0,
          title: Text(widget.selectedClass.longName.toString()),
        ),
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
                          margin: EdgeInsets.only(top: 80),
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.indigo,
                              ),
                              height: 150,
                              width: 150,
                              child: Center(
                                child: Text(widget.selectedClass.shortName.toString(), style: TextStyle(color: Colors.white, fontSize: 40),),
                              ),
                            ),
                          )
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 20.0, top: 30.0, bottom: 5.0, right: 20.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                            child: Text('Bitte wähle deine\nKurse aus', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 29),),
                          )
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
                        child: Center(
                          child: Text('Wähle deine Kurse indem du auf sie klickst, klicke sie erneut um sie nicht mehr zu wählen', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 18),),
                        ),
                      ),
                      Container(
                          child: FutureBuilder(
                            future: _fetchClasses(),
                            builder: (context, AsyncSnapshot snapshot) {

                              if(snapshot.connectionState == ConnectionState.waiting) {
                                ///preview loading animation

                                return new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    CoursePreLoadingCard(),
                                    CoursePreLoadingCard(),
                                    CoursePreLoadingCard(),
                                    CoursePreLoadingCard(),
                                    CoursePreLoadingCard(),
                                    CoursePreLoadingCard(),
                                  ],
                                );
                              } else {
                                ///Release data

                                return new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: _finalLoadedCourseCollectionList,
                                );
                              }

                            },
                          )
                      ),
                      BlockSpacer(height: 150)
                    ],
                  ),
                )
            ),
          ),
        )
    );
  }
}
