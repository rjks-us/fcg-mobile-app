import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeTable {
  late int id, rayid;
  late String message, day, month, year, starthour, startminute, endhour, endminute;

  TimeTable(this.id, this.message);

  TimeTable.fromJSON(Map<String, dynamic> json) {
    this.id = json['id'];
    this.message = json['message'];
  }

  Map<String, dynamic> toJSON() => {'id': id, 'message': message};
}

void showTimeTable(var context, Map<String, dynamic> object) {
  Widget statusMessage = Container();

  print(object['status']);

  if(object['status'] == 0) {
    statusMessage = Container(
      color: Colors.green,
      height: 35,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          'Unterricht nach plan',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  } else if(object['status'] == 1) {
    statusMessage = Container(
      color: Colors.red,
      height: 35,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          'Entfällt heute',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  } else if(object['status'] == 2) {
    statusMessage = Container(
      color: Colors.orange,
      height: 35,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          'Information',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height,
        color: Color.fromRGBO(29, 29, 29, 1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Row(
                children: [
                  Container(
                    child: Center(
                      child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: Colors.white10,)),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(right: 20.0),
                      child: Center(
                        child: Text('8:30 - 9:15 | Dienstag, 01.11.2021', style: TextStyle(color: Colors.white54),),
                      ),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black54
                  )
                )
              ),
            ),
            statusMessage,
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Deutsch GK - D-G3',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24
                ),
              ),
              margin: EdgeInsets.all(20.0),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              color: Colors.white10,
              width: MediaQuery.of(context).size.width,
              child: Container(
                margin: EdgeInsets.all(5.0),
                height: 60,
                child: Text(
                  object['message'],
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            )
          ],
        ),
      );
    });
}