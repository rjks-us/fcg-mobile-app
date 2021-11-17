import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:fcg_app/api/timetable.dart';
import 'package:fcg_app/pages/components/comp.dart';
import 'package:fcg_app/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetupFlow extends StatefulWidget {
  const SetupFlow({Key? key}) : super(key: key);

  @override
  _SetupFlowState createState() => _SetupFlowState();
}

class _SetupFlowState extends State<SetupFlow> {

  int _currentIndexPage = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getPage(_currentIndexPage),
    );
  }

  Widget getPage(int index) {

    List<Widget> pages = [
      Container(
        alignment: Alignment.center,
        child: SelectClass(),
      ),
      Container(
        alignment: Alignment.center,
        child: SelectCourse(id: 1, name: 'Q1',),
      ),
      Container(
        alignment: Alignment.center,
        child: SetUsername(),
      )
    ];

    return pages[index];
  }
}

/*
* SELECT CLASS WIDGET
* */

class SelectClass extends StatefulWidget {
  const SelectClass({Key? key}) : super(key: key);

  @override
  _SelectClassState createState() => _SelectClassState();
}

class _SelectClassState extends State<SelectClass> {

  int classesFound = 0;
  List<Widget> classList = [
    ClassPreLoadingBox(),
    ClassPreLoadingBox(),
    ClassPreLoadingBox(),
    ClassPreLoadingBox(),
    ClassPreLoadingBox(),
    ClassPreLoadingBox(),
    ClassPreLoadingBox(),
    ClassPreLoadingBox(),
    ClassPreLoadingBox(),
    ClassPreLoadingBox(),
    ClassPreLoadingBox(),
  ];

  select(String id) {

  }

  @override
  void initState() {
    super.initState();
    loadElements();
  }

  loadElements() async {
    List<dynamic>? classes = await getClasses();
    bool loaded = false;

    if(classes == null) loaded = !loaded;

    Timer(Duration(seconds: 1), () {
      try { /// <-- To many elements in queue
        if(this.mounted) {
          setState(() {
            classList.clear();

            classes!.forEach((element) {
              Map<String, dynamic> obj = element;
              String teacher = '-';

              try {
                teacher = obj['teachers'][0]; ///for this stupid AG class without a teacher
              } catch (_) {}

              classList.add(ClassElement(className: obj['short'], teacher: teacher, id: obj['id']));
              classesFound++;
            });

          });
        }
      } catch(err) {
        print(err); ///<-- Parsing error
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(54, 66, 106, 1),
                  Color.fromRGBO(29, 29, 29, 1)
                ]
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20.0, top: 80.0, bottom: 20.0),
                  child: Text('Bitte wähle deine\nKlasse/Stufe', style: TextStyle(color: Colors.white, fontSize: 30),),
                ),
                Container(
                  child: Column(
                    children: classList,
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text('Insgesamt wurden ${classesFound} Klassen gefunden', style: TextStyle(color: Colors.grey, fontSize: 12),),
                    )
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}

class ClassElement extends StatefulWidget {
  const ClassElement({Key? key, required this.className, required this.teacher, required this.id}) : super(key: key);

  final String className, teacher;
  final int id;

  @override
  _ClassElementState createState() => _ClassElementState();
}

class _ClassElementState extends State<ClassElement> {

  List<Color> colors = [Colors.blue];
  List<String> specialClasses = ['Q2'];
  
  Color defaultColor = Colors.grey, specialColor = Colors.orange;
  
  getSpecialClassColor(String name) { /// <-- Just for fun, cause Q2 is the best hahhahaha
    if(specialClasses.contains(name)) return specialColor;
    return defaultColor;
  }
  
  selectClass(int id) {
    print('Selected class ${widget.className} with id $id');
    saveInt('var-class-id', id);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(children: <Widget>[
        InkWell(
          onTap: () => selectClass(widget.id),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 80.0,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 5, spreadRadius: 3)],
              borderRadius: BorderRadius.circular(13.0),
              color: Color.fromRGBO(255, 255, 255, 0.13),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      height: 80,
                      child: Icon(Icons.school, color: getSpecialClassColor(widget.className),),
                    ),
                    Container(
                      width: 80,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15)),
                      ),
                      child: Center(
                        child: Text(
                          widget.className,
                          style: TextStyle(fontSize: 30.0, fontFamily: 'Nunito-SemiBold', color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Text(
                        widget.teacher,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(fontSize: 19.0, fontFamily: 'Nunito-SemiBold', color: Colors.grey.shade300),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: 20,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          color: colors[Random().nextInt(colors.length)]
                      ),
                      child: Container(
                        child: Icon(Icons.arrow_right, color: Colors.white, size: 20,),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        )
      ]),
    );
  }
}

/*
* SELECT COURSE WIDGET
* */

class SelectCourse extends StatefulWidget {
  const SelectCourse({Key? key, required this.id, required this.name}) : super(key: key);

  final String name;
  final int id;

  @override
  _SelectCourseState createState() => _SelectCourseState();
}

class _SelectCourseState extends State<SelectCourse> {

  List<Widget> course = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Done Button
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
        ),
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          onTap: () => {},
          child: Container(
            margin: EdgeInsets.all(10),
            height: 50,
            decoration: BoxDecoration(
                color: Colors.blue
            ),
            child: Center(
              child: Text('Fertig', style: TextStyle(color: Colors.white, fontSize: 22),),
            ),
          ),
        )
      ),
      //Content
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(54, 66, 106, 1),
                  Color.fromRGBO(29, 29, 29, 1)
                ]
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(40),
                  child: Center(
                    child: Text(widget.name, style: TextStyle(color: Colors.white, fontSize: 50),),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20.0, bottom: 20.0),
                  child: Text('Bitte wähle deine\nKurse', style: TextStyle(color: Colors.white, fontSize: 30),),
                ),
                CourseSection(title: 'Mathematik', color: Colors.blue,),
                CourseSection(title: 'Deutsch', color: Colors.red,),
                CourseSection(title: 'Englisch', color: Colors.green,),
                CourseSection(title: 'Sport', color: Colors.deepOrangeAccent,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text('Insgesamt wurden ${course.length} Kurse gefunden', style: TextStyle(color: Colors.grey, fontSize: 12),),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CourseSection extends StatefulWidget {
  const CourseSection({Key? key, required this.title, required this.color}) : super(key: key);

  final Color color;
  final String title;

  @override
  _CourseSectionState createState() => _CourseSectionState();
}

class _CourseSectionState extends State<CourseSection> {

  @override
  Widget build(BuildContext context) {

    List<Widget> list = [
      CourseElement(id: 1, name: 'Mathematik-LK', teacher: 'Elia Lee', color: widget.color),
      CourseElement(id: 2, name: 'Mathematik-Gk1', teacher: 'Liv Marquass', color: widget.color),
      CourseElement(id: 3, name: 'Mathematik-Gk2', teacher: 'Michael Stenzel', color: widget.color),
    ];

    return Container(
      child: Column(children: <Widget>[
        Line(title: widget.title),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: list,
        )
      ]),
    );
  }
}


class CourseElement extends StatefulWidget {
  const CourseElement({Key? key, required this.id, required this.name, required this.teacher, required this.color}) : super(key: key);

  final Color color;
  final String name, teacher;
  final int id;

  @override
  _CourseElementState createState() => _CourseElementState();
}

class _CourseElementState extends State<CourseElement> {

  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, bottom: 20, right: 20),
      width: MediaQuery.of(context).size.width,
      height: 80.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
          color: selected ? widget.color : Color.fromRGBO(255, 255, 255, 0.13)
      ),
      child: InkWell(
        onTap: () => {
          setState(() {
            selected = !selected;
          })
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      '${widget.name}\n${widget.teacher}',
                      style: TextStyle(fontSize: 19.0, fontFamily: 'Nunito-SemiBold', color: Colors.grey.shade300),
                    ),
                    margin: EdgeInsets.only(left: 20),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(3),
              width: 20,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(13),
                      bottomRight: Radius.circular(13)),
                  color: widget.color
              ),
            ),
          ],
        ),
      )
    );
  }
}

/*
* SET USERNAME FOR APP
* */

class SetUsername extends StatefulWidget {
  const SetUsername({Key? key}) : super(key: key);

  @override
  _SetUsernameState createState() => _SetUsernameState();
}

class _SetUsernameState extends State<SetUsername> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Done Button
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(29, 29, 29, 1),
          ),
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            onTap: () => {},
            child: Container(
              margin: EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(2)
              ),
              child: Center(
                child: Text('Nächster Schritt', style: TextStyle(color: Colors.white, fontSize: 22),),
              ),
            ),
          )
      ),
      //Content
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(54, 66, 106, 1),
                  Color.fromRGBO(29, 29, 29, 1)
                ]
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
                child: Text('Wie dürfen wir dich\nnennen?', style: TextStyle(color: Colors.white, fontSize: 30),),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
                child: Center(
                  child: TextFormField(
                    autocorrect: false,
                    onEditingComplete: () => {
                      print('test')
                    }, //Validate, we are not using the inbuild validator
                    cursorColor: Colors.blue,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Enter your username',
                      suffixIcon: Icon(Icons.check, color: Colors.green,),
                    ),
                  ),
                ),
              )
            ],
          )
      )
    );
  }
}

class FinishSetupScreen extends StatefulWidget {
  const FinishSetupScreen({Key? key}) : super(key: key);

  @override
  _FinishSetupScreenState createState() => _FinishSetupScreenState();
}

class _FinishSetupScreenState extends State<FinishSetupScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



