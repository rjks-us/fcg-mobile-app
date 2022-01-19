import 'dart:io';

import 'package:fcg_app/api/utils.dart';
import 'package:fcg_app/device/device.dart';
import 'package:fcg_app/pages/administrator/team.dart';
import 'package:fcg_app/pages/components/comp.dart';
import 'package:fcg_app/pages/setup/app_setup.dart';
import 'package:fcg_app/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsOverviewPage extends StatefulWidget {
  const SettingsOverviewPage({Key? key}) : super(key: key);

  @override
  _SettingsOverviewPageState createState() => _SettingsOverviewPageState();
}

class _SettingsOverviewPageState extends State<SettingsOverviewPage> {
  
  String username = '', className = '';
  int classId = 0;

  Widget status = Text('Der name muss mindestens 2, und maximal 15 Zeichen lang sein.', style: TextStyle(color: Colors.grey, fontSize: 16),);
  final controller = TextEditingController();

  refresh() {
    if(this.mounted) setState(() {});
  }

  load() async {
    username = await getString('var-username');
    className = await getString('var-class-name');
    classId = await getInt('var-class-id');

    refresh();
  }

  deleteApp() async {
    clearCache();

    await deleteThisDevice();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SelectClass(userNav: true)),
          (Route<dynamic> route) => false,
    );
  }

  finish() {
    String content = controller.text;

    if(content.length > 1 && content.length < 15) {
      save('var-username', content);
      print('Saved new username $content');

      username = content;

      Navigator.pop(context);
      refresh();
    } else {
      status = Text('Der name muss mindestens 2, und maximal 15 Zeichen lang sein', style: TextStyle(color: Colors.redAccent, fontSize: 16),);
      refresh();
    }
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
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
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 20, top: 60),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Text('$username', style: TextStyle(color: Colors.white, fontSize: 30),),
                        ),
                        IconButton(
                            onPressed: () {
                              createSettingsModalBottomSheet(context,
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: SingleChildScrollView(
                                      controller: ScrollController(),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(left: 20.0, right: 20.0),
                                            child: status,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 20.0, right: 20.0),
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 10, bottom: 10),
                                              child: TextField(
                                                controller: controller,
                                                autofocus: true,
                                                maxLength: 15,
                                                autocorrect: false,
                                                cursorColor: Colors.blue,
                                                style: TextStyle(color: Colors.white),
                                                decoration: InputDecoration(
                                                  labelText: 'Dein Name',
                                                  fillColor: Color.fromRGBO(
                                                      66, 66, 66, 1.0),
                                                  filled: true,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10.0, right: 10.0),
                                            child: InkWell(
                                              onTap: () => finish(),
                                              child: Container(
                                                margin: EdgeInsets.all(10),
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: Colors.indigo
                                                ),
                                                child: Center(
                                                  child: Text('Speichern', style: TextStyle(color: Colors.white, fontSize: 18),),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              );
                            },
                            icon: Icon(Icons.edit, color: Colors.white, size: 20,)
                        )
                      ],
                    )
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
                child: Center(
                  child: Text('FCG-Schüler', style: TextStyle(color: Colors.grey, fontSize: 20),),
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    SettingsOption(title: 'Klasse/Stufe wechseln', color: Colors.indigoAccent, icon: Icons.school, action: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => SelectClass(userNav: false,))
                      );
                    }),
                    SettingsOption(title: 'Kurse wechseln', color: Colors.indigoAccent, icon: Icons.list_alt_rounded, action: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => SelectCourse(navFlow: false, name: className, id: classId, navCallback: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Du hast deine Kurse Aktualisiert"),
                            ));
                          }))
                      );
                    }),
                    SettingsOption(title: 'Studienzeit Woche', color: Colors.green, icon: Icons.swap_horiz, action: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => StudienzeitSwapPage())
                      );
                    }),
                    SettingsOption(title: 'FCG-Website', color: Colors.indigoAccent, icon: Icons.web, action: () {
                      try {
                        launchURL("https://fcg-duesseldorf.de/");
                      } catch (_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Es ist ein Fehler aufgetreten"),
                        ));
                      }
                    }),
                    Line(title: 'Support', blurred: false),
                    SettingsOption(title: 'Kontaktiere uns', color: Colors.orange, icon: Icons.contact_support, action: () {
                      try {
                        //mailto:fcg.developers@gmail.com?subject=Neues%20Support%20Ticket
                        launchURL("https://fcg-app.de/support");
                      } catch (_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Es ist ein Fehler aufgetreten"),
                        ));
                      }
                    }),
                    SettingsOption(title: 'Fehler melden', color: Colors.orange, icon: Icons.bug_report, action: () {
                      try {
                        //mailto:fcg.developers@gmail.com?subject=Neues%20Support%20Ticket
                        launchURL("https://fcg-app.de/support");
                      } catch (_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Es ist ein Fehler aufgetreten"),
                        ));
                      }
                    }),
                    Line(title: 'Allgemein', blurred: false),
                    SettingsOption(title: 'Bewerte diese App', color: Colors.green, icon: Icons.star_rate_sharp, action: () {
                      try {
                        //mailto:fcg.developers@gmail.com?subject=Neues%20Support%20Ticket
                        launchURL("https://fcg-app.de/rate?platform=" + getPlatform());
                      } catch (_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Es ist ein Fehler aufgetreten"),
                        ));
                      }
                    }),
                    SettingsOption(title: 'Über diese App', color: Colors.blue, icon: Icons.location_history, action: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => SettingsAboutPage())
                      );
                    }),
                    SettingsOption(title: 'Entwickler', color: Colors.indigo, icon: Icons.bar_chart, action: () {
                      try {
                        //mailto:fcg.developers@gmail.com?subject=Neues%20Support%20Ticket
                        launchURL("https://robertkratz.dev?redirect=fcg-app");
                      } catch (_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Es ist ein Fehler aufgetreten"),
                        ));
                      }
                    }),
                    Line(title: 'System Einstellungen', blurred: false),
                    SettingsOption(title: 'Anmelden', color: Colors.redAccent, icon: Icons.vpn_key, action: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => AdminLogin())
                      );
                    }),
                    SettingsOption(title: 'App reset', color: Colors.redAccent, icon: Icons.delete, action: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => SettingsAppReset(deleteApp: () => deleteApp()))
                      );
                    }),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: <Widget>[
                    Text('Made by Robert J. Kratz', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    Text('Powered by rjks.us', style: TextStyle(color: Colors.white, fontSize: 18)),
                    Text('v1.0.0', style: TextStyle(color: Colors.grey, fontSize: 16))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsOption extends StatefulWidget {
  const SettingsOption({Key? key, required this.title, required this.color, required this.action, required this.icon}) : super(key: key);

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback action;

  @override
  _SettingsOptionState createState() => _SettingsOptionState();
}

class _SettingsOptionState extends State<SettingsOption> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 20, bottom: 20, right: 20),
        width: MediaQuery.of(context).size.width,
        height: 80.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13.0),
          color: Color.fromRGBO(255, 255, 255, 0.13),
          boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 5, spreadRadius: 3)],
        ),
        child: InkWell(
          onTap: () => widget.action(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 80,
                    child: Icon(widget.icon, color: Colors.grey),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                    ),
                    child: Center(
                      child: Text(
                        widget.title,
                        style: TextStyle(fontSize: 18.0, fontFamily: 'Nunito-SemiBold', color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 20,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                    color: widget.color
                ),
                child: Container(
                  child: Icon(Icons.arrow_right, color: Colors.white, size: 20,),
                ),
              ),
            ],
          ),
        )
    );
  }
}

class SettingsAboutPage extends StatefulWidget {
  const SettingsAboutPage({Key? key}) : super(key: key);

  @override
  _SettingsAboutPageState createState() => _SettingsAboutPageState();
}

class _SettingsAboutPageState extends State<SettingsAboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 66, 106, 1),
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Color.fromRGBO(54, 66, 106, 1),
                Color.fromRGBO(29, 29, 29, 1)
              ]
          ),
        ),
        child: new SingleChildScrollView(
          controller: ScrollController(),
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 40.0, bottom: 20.0),
                  child: Text(
                    'Vielen Dank an alle Mitwirkenden',
                    style: TextStyle(
                        fontFamily: 'Nunito-Regular',
                        fontSize: 29.0,
                        color: Colors.white
                    ),
                  ),
                ),
                Line(title: 'Entwicklung', blurred: false),
                SettingsAboutPersonElement(name: 'Robert J. Kratz', role: 'Front- und Backend'),
                Line(title: 'IOS Beta Tester', blurred: false),
                SettingsAboutPersonElement(name: 'Jan Kratz', role: 'IOS Beta Tester'),
                SettingsAboutPersonElement(name: 'Henrik Lankisch', role: 'IOS Beta Tester'),
                SettingsAboutPersonElement(name: 'Franziska Ruhl', role: 'IOS Beta Tester'),
                SettingsAboutPersonElement(name: 'Fabian Platow', role: 'IOS Beta Tester'),
                SettingsAboutPersonElement(name: 'Isabella Lehne', role: 'IOS Beta Tester'),
                SettingsAboutPersonElement(name: 'Sophia Stulle', role: 'IOS Beta Tester'),
                SettingsAboutPersonElement(name: 'Frederik Trethau', role: 'IOS Beta Tester'),
                SettingsAboutPersonElement(name: 'Linus Wilde', role: 'IOS Beta Tester'),
                SettingsAboutPersonElement(name: 'Marco Kuhn', role: 'IOS Beta Tester'),
                Line(title: 'Android Beta Tester', blurred: false),
                SettingsAboutPersonElement(name: 'Philip Grüll', role: 'Android Beta Tester'),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0, top: 20.0),
                  child: Column(
                    children: <Widget>[
                      Text('Powered by rjks.us', style: TextStyle(color: Colors.white, fontSize: 18)),
                      Text('v1.0.0', style: TextStyle(color: Colors.grey, fontSize: 16))
                    ],
                  ),
                ),
                BlockSpacer(height: 200)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StudienzeitSwapPage extends StatefulWidget {
  const StudienzeitSwapPage({Key? key}) : super(key: key);

  @override
  _StudienzeitSwapPageState createState() => _StudienzeitSwapPageState();
}

class _StudienzeitSwapPageState extends State<StudienzeitSwapPage> {

  bool swapped = false;

  refresh() {
    if(this.mounted) setState(() {});
  }

  load() async {
    swapped = await getBoolean('var-st-swapp');
    refresh();
  }

  update(bool state) {
    swapped = state;
    saveBoolean('var-st-swapp', state);
    print('changed stz order to $state');
    refresh();
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 66, 106, 1),
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Color.fromRGBO(54, 66, 106, 1),
                Color.fromRGBO(29, 29, 29, 1)
              ]
          ),
        ),
        child: new SingleChildScrollView(
          controller: ScrollController(),
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 40.0, bottom: 20.0),
                  child: Text(
                    'Studienzeit für die Q1/Q2',
                    style: TextStyle(
                        fontFamily: 'Nunito-Regular',
                        fontSize: 29.0,
                        color: Colors.white
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: Text('Die Studienzeit ist die 5. und 6. Wochenstunde des Leistungskurses und wechselt Wöchentlich.\n\nMit dieser Einstellung kannst du festlegen, in welcher Woche welche Studienzeit stattfindet.', style: TextStyle(color: Colors.grey, fontSize: 16),),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Tausche die StZA und StZB', style: TextStyle(color: Colors.white, fontSize: 16),),
                      CupertinoSwitch(
                        activeColor: Colors.green,
                        thumbColor: Colors.white,
                        value: swapped,
                        onChanged: (bool value) { setState(() {update(!swapped);}); },
                      )
                    ],
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


class SettingsAppReset extends StatefulWidget {
  const SettingsAppReset({Key? key, required this.deleteApp}) : super(key: key);

  final VoidCallback deleteApp;

  @override
  _SettingsAppResetState createState() => _SettingsAppResetState();
}

class _SettingsAppResetState extends State<SettingsAppReset> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 66, 106, 1),
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Color.fromRGBO(54, 66, 106, 1),
                Color.fromRGBO(29, 29, 29, 1)
              ]
          ),
        ),
        child: new SingleChildScrollView(
          controller: ScrollController(),
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('Bist du dir sicher, dass du diese App zurücksetzen willst?', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 25.0, fontWeight: FontWeight.bold),),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: Text('Dadurch werden alle geispeicherteten Daten von dir unwiederruflich gelöscht, und können nich wiederhergestellt werden.', style: TextStyle(color: Colors.grey, fontSize: 16),),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => widget.deleteApp(),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.red
                      ),
                      child: Center(
                        child: Text('Alle Daten Löschen', style: TextStyle(color: Colors.white, fontSize: 18),),
                      ),
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


class SettingsAboutPersonElement extends StatefulWidget {
  const SettingsAboutPersonElement({Key? key, required this.name, required this.role}) : super(key: key);

  final String name, role;

  @override
  _SettingsAboutPersonElementState createState() => _SettingsAboutPersonElementState();
}

class _SettingsAboutPersonElementState extends State<SettingsAboutPersonElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.black12),
                top: BorderSide(color: Colors.black12)
            )
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  child: Text(widget.name, style: TextStyle(color: Colors.grey),)
              ),
              Container(
                  child: Text(widget.role, style: TextStyle(color: Colors.grey),)
              )
            ],
          ),
        )
    );
  }
}
