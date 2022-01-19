import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  _NotificationSettingsPage createState() => _NotificationSettingsPage();
}

class _NotificationSettingsPage extends State<NotificationSettingsPage> {

  bool swapped = false;

  refresh() {
    if(this.mounted) setState(() {});
  }

  load() async {
    // swapped = await getBoolean('var-st-swapp');
    swapped = true;
    refresh();
  }

  update(bool state) {
    swapped = state;
    // saveBoolean('var-st-swapp', state);
    print('changed push notifications to $state');
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
                    'Push Benachrichtigungen',
                    style: TextStyle(
                        fontFamily: 'Nunito-Regular',
                        fontSize: 29.0,
                        color: Colors.white
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: Text('Wir empfelen dir die Push Benachrichtigungen zu aktivieren, um immer über Änderungen am Stundenplan informiert zu werden.', style: TextStyle(color: Colors.grey, fontSize: 16),),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Benachrichtigungen', style: TextStyle(color: Colors.white, fontSize: 16),),
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