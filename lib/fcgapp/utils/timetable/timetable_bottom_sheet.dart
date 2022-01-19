import 'package:fcg_app/app/Timetable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showTimeTableBottomModalContext(BuildContext context, TimetableEntry timetableEntry) {
  Widget statusMessage = Container();

  int status = timetableEntry.timetableEntryState.state;

  List<Widget> _timetableEntrySectionCollection = <Widget>[];

  if(timetableEntry.timetableRoom.hasRoom) _timetableEntrySectionCollection.add(TimeTableInfoScreenListElement(icon: Icons.room_outlined, data: '${timetableEntry.timetableRoom.name} - ${timetableEntry.timetableRoom.short} '));
  if(timetableEntry.timetableTeacher.hasTeacher) _timetableEntrySectionCollection.add(TimeTableInfoScreenListElement(icon: Icons.school_outlined, data: timetableEntry.timetableTeacher.getFullName()));
  if(timetableEntry.timetableSubject.hasSubject) _timetableEntrySectionCollection.add(TimeTableInfoScreenListElement(icon: Icons.subject_outlined, data: timetableEntry.timetableSubject.short));

  if(status == 0) {
    statusMessage = Container(
      color: Colors.green,
      height: 35,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          'Unterricht nach Plan',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  } else if(status == 1) {
    statusMessage = Container(
      color: Colors.red,
      height: 35,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          'Entfällt',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  } else if(status == 2) {
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
        return SingleChildScrollView(
          controller: ScrollController(),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(29, 29, 29, 1),
            ),
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
                            ///${dateSection['day']}.${dateSection['month']}.${dateSection['year']} <--- Date
                            child: Text('${timetableEntry.startHour.toString() + ':' + timetableEntry.startMinute.toString()} - ${timetableEntry.endHour.toString() + ':' + timetableEntry.startMinute.toString()}', style: TextStyle(color: Colors.white54),),
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
                    timetableEntry.timetableSubject.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24
                    ),
                  ),
                  margin: EdgeInsets.all(20.0),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30),
                  color: Colors.white10,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    height: 60,
                    child: Text(
                      timetableEntry.timetableEntryState.message,
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: _timetableEntrySectionCollection,
                    )
                ),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                //   child: Center(
                //     child: Text(
                //       'ID: ${object['id']} Ray: ${object['rayid']}',
                //       style: TextStyle(color: Colors.white12),
                //     ),
                //   ),
                // ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.all(20),
                          color: Colors.indigo,
                          child: Center(
                            child: Text(
                              'Stunde ändern',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                    )
                )
              ],
            ),
          ),
        );
      });
}

class TimeTableInfoScreenListElement extends StatefulWidget {
  const TimeTableInfoScreenListElement({Key? key, required this.icon, required this.data}) : super(key: key);

  final IconData icon;
  final String data;

  @override
  _TimeTableInfoScreenListElementState createState() => _TimeTableInfoScreenListElementState();
}

class _TimeTableInfoScreenListElementState extends State<TimeTableInfoScreenListElement> {
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
                child: Icon(widget.icon, color: Colors.grey,),
              ),
              Container(
                  child: Text(widget.data, style: TextStyle(color: Colors.grey),)
              )
            ],
          ),
        )
    );
  }
}