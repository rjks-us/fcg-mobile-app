import 'package:fcg_app/fcgapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudienzeitSettingsPage extends StatefulWidget {
  const StudienzeitSettingsPage({Key? key}) : super(key: key);

  @override
  _StudienzeitSettingsPage createState() => _StudienzeitSettingsPage();
}

class _StudienzeitSettingsPage extends State<StudienzeitSettingsPage> {

  bool swapped = false;

  _refresh() {
    if(this.mounted) setState(() {});
  }

  load() async {
    swapped = await device.isStudienzeitSwapped();

    print(swapped);

    _refresh();
  }

  update(bool state) {
    swapped = state;
    device.setStudienzeitLastChangeDate(state);
    _refresh();
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