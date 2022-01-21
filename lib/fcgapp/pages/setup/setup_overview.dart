import 'package:fcg_app/app/Timetable.dart';
import 'package:fcg_app/fcgapp/components/block_spacer.dart';
import 'package:fcg_app/fcgapp/components/buttons.dart';
import 'package:fcg_app/fcgapp/components/course_card.dart';
import 'package:fcg_app/fcgapp/components/default_background_design.dart';
import 'package:fcg_app/fcgapp/components/title_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetUpConfirmPage extends StatefulWidget {
  const SetUpConfirmPage({Key? key, required this.username, required this.className, required this.preSelectedCourses, required this.onFinishEvent}) : super(key: key);

  final String username, className;
  final List<SchoolCourse> preSelectedCourses;
  final Function(BuildContext, List<SchoolCourse>) onFinishEvent;

  @override
  _SetUpConfirmPageState createState() => _SetUpConfirmPageState();
}

class _SetUpConfirmPageState extends State<SetUpConfirmPage> {

  int _selectedCourses = 0;
  List<SchoolCourse> _finalSelectedCourses = [];

  List<Widget> _finalSelectedCourseAsWidgetList = [];

  void _onFinishPress() {
    if(_finalSelectedCourses.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Bitte wähle mindestens einen Kurs aus"),
      ));
    } else {
      widget.onFinishEvent(context, _finalSelectedCourses);
    }
  }

  void _showSelectedCourses() {
    widget.preSelectedCourses.forEach((element) {
      _finalSelectedCourseAsWidgetList.add(new CourseSelectionCard(
          schoolCourse: element,
          blureOnClick: true,
          onClickEvent: (element, selected) {
            if(selected) {
              _finalSelectedCourses.remove(element);
              print('[SETUP] ${element.longName} has been removed from subscribed subjects');
            } else {
              _finalSelectedCourses.add(element);
              print('[SETUP] ${element.longName} has been added to subscribed subjects');
            }
          }
      ));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showSelectedCourses();
    _finalSelectedCourses = widget.preSelectedCourses;
    _selectedCourses = widget.preSelectedCourses.length;
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
              title: 'Fertigstellen',
              onClickEvent: _onFinishPress,
            )
        ),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(54, 66, 106, 1),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          controller: ScrollController(),
          child: DefaultBackgroundDesign(
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(20.0),
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
                            child: Text(widget.className, style: TextStyle(color: Colors.white, fontSize: 40),),
                          ),
                        ),
                      )
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 20.0, bottom: 5.0, right: 20.0),
                    child: Center(
                      child: Text('Hallo ${widget.username}', style: TextStyle(color: Colors.white, fontSize: 30),),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
                    child: Center(
                      child: Text('Bitte überprüfe deine Kurse', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 20),),
                    ),
                  ),
                  SmallSubInformationTextText(
                      title: 'Möchtest du einen Kurs wieder entfernen klicke auf ihn'
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: GestureDetector(
                        onTap: () => {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _finalSelectedCourseAsWidgetList,
                        ),
                      )
                  ),
                  SmallSubInformationTextText(
                      title: 'Du hast insgesamt $_selectedCourses Kurse ausgewählt'
                  ),
                  BlockSpacer(height: 100)
                ],
              ),
            )
          )
        )
    );
  }
}
