import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:fcg_app/api/timetable.dart';
import 'package:fcg_app/device/device.dart' as device;
import 'package:fcg_app/api/httpBuilder.dart' as httpBuilder;
import 'package:fcg_app/main.dart';
import 'package:fcg_app/pages/components/comp.dart';
import 'package:fcg_app/pages/components/loader.dart';
import 'package:fcg_app/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
* SELECT CLASS WIDGET
* */

class SelectClass extends StatefulWidget {
  const SelectClass({Key? key, required this.userNav}) : super(key: key);

  final bool userNav;

  @override
  _SelectClassState createState() => _SelectClassState();
}

class _SelectClassState extends State<SelectClass> {

  int classesFound = 0;
  bool connection = false;

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

  refresh() {
    setState(() {});
  }
  
  onRefreshPress() async {
    await load(true);
  }
  
  load(bool newRequest) async {
    httpBuilder.Request request = new httpBuilder.Request('GET', 'v1/classes', true, newRequest, !newRequest);
    httpBuilder.Response response = await request.flush();
    await response.checkCache();

    classList.clear();
    
    response.onSuccess((classes) {
      classes!.forEach((element) {
        Map<String, dynamic> obj = element;
        String teacher = '-';

        try {
          teacher = obj['teachers'][0]; ///for this stupid AG class without a teacher
        } catch (_) {}

        classList.add(ClassElement(className: obj['short'], teacher: teacher, id: obj['id'], userRedirect: widget.userNav,));
        classesFound++;
      });
      connection = true;
    });
    
    response.onNoResult((data) {
      connection = false;
      classList.add(NoInternetConnectionScreen(refresh: () {
        onRefreshPress();
      }));
    });
    
    response.onError((data) {
      connection = false;
      classList.add(AnErrorOccurred(refresh: () {
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 66, 106, 1),
        elevation: 0,
      ),
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
                Visibility(
                  visible: connection,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text('Insgesamt wurden ${classesFound} Klassen gefunden', style: TextStyle(color: Colors.grey, fontSize: 12),),
                    )
                )),
              ],
            ),
          )
        ),
      ),
    );
  }
}

class ClassElement extends StatefulWidget {
  const ClassElement({Key? key, required this.className, required this.teacher, required this.id, required this.userRedirect}) : super(key: key);

  final String className, teacher;
  final int id;
  final bool userRedirect;

  @override
  _ClassElementState createState() => _ClassElementState();
}

class _ClassElementState extends State<ClassElement> {

  List<Color> colors = [Colors.blue];
  List<String> specialClasses = ['Q2'];
  
  Color defaultColor = Colors.grey, specialColor = Colors.orange;

  bool selected = false;

  getSpecialClassColor(String name) { /// <-- Just for fun, cause Q2 is the best hahhahaha
    if(specialClasses.contains(name)) return specialColor;
    return defaultColor;
  }
  
  selectClass(int id) {
    // if(selected) return; /// <--- To fast selection of multiple classes
    // selected = true;

    print('Selected class ${widget.className} with id $id');
    saveInt('var-class-id', id);
    save('var-class-name', widget.className);

    Navigator.push(
      context,
        CupertinoPageRoute(builder: (context) => SelectCourse(name: widget.className, id: id, navFlow: widget.userRedirect, navCallback: () {

        }))
    );
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
                      width: 150,
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
  const SelectCourse({Key? key, required this.id, required this.name, required this.navFlow, required this.navCallback}) : super(key: key);

  final String name;
  final int id;
  final navFlow;
  final VoidCallback navCallback;

  @override
  _SelectCourseState createState() => _SelectCourseState();
}

class _SelectCourseState extends State<SelectCourse> {

  int coursesFound = 0;
  Color lastColor = Colors.red;
  bool connected = false;
  
  List<Color> colors = [Colors.blue, Colors.red, Colors.green, Colors.deepOrangeAccent];

  List<Widget> section = [
    ClassPreLoadingBox(),
    ClassPreLoadingBox(),
    ClassPreLoadingBox(),
    ClassPreLoadingBox(),
    ClassPreLoadingBox(),
    ClassPreLoadingBox(),
    ClassPreLoadingBox(),
    ClassPreLoadingBox(),
  ];

  getRandomColor() {
    Color current = colors[new Random().nextInt(colors.length)];
    while(current == lastColor) {
      current = colors[new Random().nextInt(colors.length)];
    }
    return current;
  }

  goBack() {
    Navigator.pop(context);
  }

  refresh() {
    setState(() {});
  }

  onRefreshPress() async {
    await load(true);
  }
  
  load(bool newRequest) async {

    httpBuilder.Request request = new httpBuilder.Request('GET', 'v1/subjectsList/${widget.id}', true, newRequest, !newRequest);
    httpBuilder.Response response = await request.flush();
    await response.checkCache();

    section.clear();

    response.onSuccess((classes) {
      classes!.forEach((key, value) {
        String sectionName = key;
        Color sectionColor = getRandomColor();
        List<dynamic> courses = classes[sectionName];

        List<Widget> coursesCollection = [];

        courses.forEach((element) {
          Map<String, dynamic> courseElement = element, teacher = courseElement['teacher'];
          String teacherName = '${teacher['firstname']} ${teacher['lastname']}';

          if(teacher['firstname'] == null || teacher['lastname'] == null) teacherName = '-';
          if(teacherName.split('')[0] == ' ') teacherName = teacherName.substring(1, teacherName.length);

          coursesCollection.add(CourseElement(id: courseElement['id'], name: '${courseElement['name']} (${courseElement['short']})', teacher: teacherName, color: sectionColor));
        });
        lastColor = sectionColor;
        section.add(CourseSection(title: sectionName, color: Colors.green, courses: coursesCollection));
      });
      connection = true;
    });

    response.onNoResult((data) {
      connection = false;
      coursesFound = 0;
      section.add(NoInternetConnectionScreen(refresh: () {
        onRefreshPress();
      }));
    });

    response.onError((data) {
      connection = false;
      coursesFound = 0;
      section.add(AnErrorOccurred(refresh: () {
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

  finish() {
    List<String> list = courses.map((e) => '$e').toList();
    saveStringList('var-courses', list);
    print('Saved new courses: $list');

    if(!widget.navFlow) {

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => APIWaitUntilSyncScreen(createNewDevice: false)),
            (Route<dynamic> route) => false,
      );

      widget.navCallback();
      ///Restore cache
      return;
    }

    Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => SetUsername())
    );
  }

  @override
  void initState() {
    super.initState();
    tmpSelectedCourse.clear();
    courses.clear();
    load(false);
  }

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
          onTap: () => finish(),
          child: Container(
            margin: EdgeInsets.all(10),
            height: 50,
            decoration: BoxDecoration(
                color: Colors.blue
            ),
            child: Center(
              child: Text('Nächster Schritt', style: TextStyle(color: Colors.white, fontSize: 22),),
            ),
          ),
        )
      ),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 66, 106, 1),
        elevation: 0,
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
                  margin: EdgeInsets.only(left: 20.0, bottom: 5.0),
                  child: Text('Bitte wähle deine\nKurse', style: TextStyle(color: Colors.white, fontSize: 30),),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20.0, bottom: 20.0),
                  child: Text('Klicke auf die Kurse, um diese auszuwählen', style: TextStyle(color: Colors.grey, fontSize: 16),),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: section,
                  ),
                ),
                Container(
                  child: Visibility(
                    visible: connected,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(20.0),
                        child: Center(
                          child: Text('Insgesamt wurden ${section.length} Kurse gefunden', style: TextStyle(color: Colors.grey, fontSize: 12),),
                        )
                    ),
                  ),
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
  const CourseSection({Key? key, required this.title, required this.color, required this.courses}) : super(key: key);

  final Color color;
  final String title;

  final List<Widget> courses;

  @override
  _CourseSectionState createState() => _CourseSectionState();
}

class _CourseSectionState extends State<CourseSection> {

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(children: <Widget>[
        Line(title: widget.title),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.courses,
        )
      ]),
    );
  }
}

List<int> courses = []; ///<-- Course cache when seleced
List<Widget> tmpSelectedCourse = [];

class CourseElement extends StatefulWidget {
  const CourseElement({Key? key, required this.id, required this.name, required this.teacher, required this.color}) : super(key: key);

  final Color color;
  final String name, teacher;
  final int id;

  toggleCourse() {
    if(courses.contains(id)) {
      courses.remove(id);
      tmpSelectedCourse.remove(this);
      print('Unselected course $name with id $id');
    } else {
      courses.add(id);
      tmpSelectedCourse.add(this);
      print('Selected course $name with id $id');
    }
  }

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
        color: selected ? widget.color : Color.fromRGBO(255, 255, 255, 0.13),
        boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 5, spreadRadius: 3)],
      ),
      child: InkWell(
        onTap: () => {
          setState(() {
            if(!_cancelClickEventInFinishScreen) {
              selected = !selected;
              widget.toggleCourse();
            }
          })
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20),
              height: 100,
              width: 270,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Flexible(
                      child: Text(
                        widget.name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 19.0, fontFamily: 'Nunito-SemiBold', color: Colors.grey.shade300),
                      ),
                    )
                  ),
                  Container(
                    child: Flexible(
                      child: Text(
                        widget.teacher,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 19.0, fontFamily: 'Nunito-SemiBold', color: Colors.grey.shade400),
                      ),
                    )
                  )
                ],
              )
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

  final controller = TextEditingController();

  Widget status = Text('Dein name muss mindestens 2 Zeichen lang sein', style: TextStyle(color: Colors.grey, fontSize: 16),);

  finish() {
    String content = controller.text;

    if(content.length > 1 && content.length < 15) {
      save('var-username', content);
      print('Saved new username $content');
      Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => FinishSetupScreen())
      );
    } else {
      setState(() {
        status = Text('Der name muss mindestens 2, und maximal 15 Zeichen lang sein', style: TextStyle(color: Colors.redAccent, fontSize: 16),);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 66, 106, 1),
        elevation: 0,
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20.0, bottom: 5.0, right: 20.0),
                child: Text('Wie dürfen wir dich\nnennen?', style: TextStyle(color: Colors.white, fontSize: 30),),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
                child: status, ///Status message
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
                child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: TextField(
                        controller: controller,
                        autofocus: true,
                        autocorrect: false,
                        onEditingComplete: () => {

                        }, //Validate, we are not using the inbuild validator
                        cursorColor: Colors.blue,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Dein Name',
                          fillColor: Color.fromRGBO(54, 66, 106, 1),
                          filled: true,
                        ),
                      ),
                    )
                ),
              ),
              //Done Button
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () => finish(),
                    child: Container(
                      margin: EdgeInsets.all(20),
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(2)
                      ),
                      child: Center(
                        child: Text('Fertig stellen', style: TextStyle(color: Colors.white, fontSize: 22),),
                      ),
                    ),
                  )
              ),
            ],
          )
        ),
      )
    );
  }
}

///ClassElement Click event is getting canceled if this is true, just for the finish screen so you cant select courses in finish screen
bool _cancelClickEventInFinishScreen = false;

class FinishSetupScreen extends StatefulWidget {
  const FinishSetupScreen({Key? key}) : super(key: key);

  @override
  _FinishSetupScreenState createState() => _FinishSetupScreenState();
}

class _FinishSetupScreenState extends State<FinishSetupScreen> {
  
  String username = '', className = '';
  List<Widget> selectedClasses = [];
  
  refresh() {
    setState(() {});
  }

  loadContent() async {
    username = await getString('var-username');
    className = await getString('var-class-name');

    List<String> tmp = await getStringList('var-courses');
    List<int> list = tmp.map((e) => int.parse('$e')).toList();
    
    await getSubjectList(await getInt('var-class-id'));

    refresh();
  }

  finish() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => APIWaitUntilSyncScreen(createNewDevice: true,)),
          (Route<dynamic> route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _cancelClickEventInFinishScreen = true;
    loadContent();
  }

  @override
  void dispose() {
    super.dispose();
    _cancelClickEventInFinishScreen = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 66, 106, 1),
        elevation: 0,
      ),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.grey[850],
          ),
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            onTap: () => finish(),
            child: Container(
              margin: EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blue
              ),
              child: Center(
                child: Text('Fertigstellen', style: TextStyle(color: Colors.white, fontSize: 22),),
              ),
            ),
          )
      ),
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
        child: SingleChildScrollView(
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
                      child: Text('$className', style: TextStyle(color: Colors.white, fontSize: 40),),
                    ),
                  ),
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20.0, bottom: 5.0, right: 20.0),
                child: Center(
                  child: Text('Hallo $username', style: TextStyle(color: Colors.white, fontSize: 30),),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
                child: Center(
                  child: Text('Bitte verifiziere deine Kurse', style: TextStyle(color: Colors.grey, fontSize: 20),),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: GestureDetector(
                  onTap: () => {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: tmpSelectedCourse,
                  ),
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(20.0),
                child: Center(
                  child: Text('Du bist in ${tmpSelectedCourse.length} Kursen', style: TextStyle(color: Colors.grey, fontSize: 12),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class APIWaitUntilSyncScreen extends StatefulWidget {
  const APIWaitUntilSyncScreen({Key? key, required this.createNewDevice}) : super(key: key);

  final bool createNewDevice;

  @override
  _APIWaitUntilSyncScreenState createState() => _APIWaitUntilSyncScreenState();
}

class _APIWaitUntilSyncScreenState extends State<APIWaitUntilSyncScreen> {

  bool created = true;
  String status = 'Wir optimieren deinen Stundenplan...';

  refresh() {
    setState(() {});
  }

  load() async {
    try {
      if(!await device.deviceRegistered()) {
        await device.register();

        Timer(Duration(seconds: 1), () {
          if(this.mounted && created) {
            status = 'Fertig!';
            refresh();
          }
        });

      } else {
        print('Current device is already registered');
        if(!await device.isSessionValid()) device.refreshSession();
      }
    } catch(_) {
      created = false;
      status = 'Es ist ein Fehler aufgetreten,\nbitte versuche es später erneut';
      refresh();
    }

    Timer(Duration(seconds: 3), () {
      if(this.mounted && created) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
              (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ColorLoader(),
            Container(
              margin: EdgeInsets.only(top: 30, left: 20, right: 20),
              child: Text(status, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18),),
            )
          ],
        ),
      ),
    );
  }
}
