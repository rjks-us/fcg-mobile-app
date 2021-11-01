import 'package:fcg_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../modal/modal_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
                            'Guten Tag ${widget.username}',
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
                AlertBox(label: '01.', text: 'November 2021, 2. Quatal'),
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Dein Tag',
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
                TimetableElement(time: '8:30', hour: '1.', title: 'Biologie GK-2', subtitle: 'Ch1 | Eike Lückerath', color: Colors.green, status: 0),
                TimetableElement(time: '9:15', hour: '2.', title: 'Religion GK-4', subtitle: 'K6 | Veit Reiß', color: Colors.red, status: 1),
                TimetableElement(time: '10:20', hour: '3.', title: 'Mathematik GK-3', subtitle: 'K8 | Liv Marqiass', color: Colors.yellow, status: 2),
                TimetableElement(time: '11:05', hour: '4.', title: 'Mathematik GK-3', subtitle: 'K8 | Liv Marqiass', color: Colors.yellow, status: 2),
                TimetableElement(time: '12:50', hour: '5.', title: 'Sport GK-1', subtitle: 'SCH | Liv Marqiass', color: Colors.green, status: 0),
                TimetableElement(time: '13:25', hour: '6.', title: 'Sport GK-1', subtitle: 'SCH | Liv Marqiass', color: Colors.green, status: 0,),
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
