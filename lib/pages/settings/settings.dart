import 'package:fcg_app/device/device.dart';
import 'package:fcg_app/pages/components/comp.dart';
import 'package:fcg_app/pages/setup/app_setup.dart';
import 'package:fcg_app/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                          child: Text('Q1', style: TextStyle(color: Colors.white, fontSize: 40),),
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
                                      height: MediaQuery.of(context).size.height - 50,
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
                      SettingsOption(title: 'Helligkeit', color: Colors.indigoAccent, icon: Icons.dark_mode, action: () {

                      }),
                      Line(title: 'Support'),
                      SettingsOption(title: 'Kontaktiere uns', color: Colors.orange, icon: Icons.contact_support, action: () {

                      }),
                      SettingsOption(title: 'Fehler melden', color: Colors.orange, icon: Icons.bug_report, action: () {

                      }),
                      Line(title: 'Allgemein'),
                      SettingsOption(title: 'Bewerte diese App', color: Colors.green, icon: Icons.star_rate_sharp, action: () {

                      }),
                      SettingsOption(title: 'Über diese App', color: Colors.blue, icon: Icons.location_history, action: () {

                      }),
                      SettingsOption(title: 'Statistiken', color: Colors.orange, icon: Icons.bar_chart, action: () {

                      }),
                      Line(title: 'System Einstellungen'),
                      SettingsOption(title: 'Anmelden', color: Colors.redAccent, icon: Icons.vpn_key, action: () {

                      }),
                      SettingsOption(title: 'App reset', color: Colors.redAccent, icon: Icons.delete, action: () {
                        createSettingsModalBottomSheet(context, Container(
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            controller: ScrollController(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10, bottom: 10),
                                  child: Text('Bist du dir sicher, dass du diese App zurücksetzen willst?', style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Text('Dadurch werden alle geispeicherteten Daten von dir unwiederruflich gelöscht, und können nich wiederhergestellt werden.', style: TextStyle(color: Colors.grey, fontSize: 16),),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                                  child: InkWell(
                                    onTap: () => deleteApp(),
                                    child: Container(
                                      margin: EdgeInsets.all(10),
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
                                Container(
                                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: InkWell(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white
                                      ),
                                      child: Center(
                                        child: Text('Zurück', style: TextStyle(color: Colors.black, fontSize: 18),),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ));
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
      )
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
