import 'package:fcg_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../modal/modal_bottom_sheet.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  void onSettingsPress() {
    print('pressed settings button');
  }

  void onRefreshPress() {
    print('pressed settings button');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromRGBO(54, 66, 106, 1),
                    Color.fromRGBO(29, 29, 29, 1)
                  ]
              )
          ),
          child: new SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Kalender',
                            style: TextStyle(
                                fontFamily: 'Nunito-Regular',
                                fontSize: 29.0,
                                color: Colors.white
                            ),
                          ),
                        ),
                        Container(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.settings,
                                color: Colors.white,
                              ),
                              onPressed: () => {onSettingsPress()},
                            )
                        )
                      ],
                    )
                ),
                AlertBox(label: '16', text: 'Tage Bis: Herbstferien'),
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Klausuren',
                            style: TextStyle(
                                fontFamily: 'Nunito-Regular',
                                fontSize: 22.0,
                                color: Colors.white
                            ),
                          ),
                        ),
                        Container(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              onPressed: () => {onRefreshPress()},
                            )
                        )
                      ],
                    )
                ),
                CalendarElement(time: '9:30', title: 'Geschichte LK', subtitle: 'K9 - Staphan Schillbach', date: 'Mittwoch, 16. November',),
                CalendarElement(time: '10:20', title: 'Englisch LK', subtitle: 'K7 - Tilly Rolle', date: 'Freitag, 19. November',),
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: Text(
                    'Letztes update 21:11',
                    style: TextStyle(
                        fontFamily: 'Nunito-Regular',
                        fontSize: 12.0,
                        color: Colors.grey
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}