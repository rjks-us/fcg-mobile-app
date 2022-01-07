import 'dart:convert';

import 'package:fcg_app/api/helper.dart';
import 'package:fcg_app/api/httpBuilder.dart' as httpBuilder;
import 'package:fcg_app/device/device.dart';
import 'package:fcg_app/main.dart';
import 'package:fcg_app/pages/components/comp.dart';
import 'package:fcg_app/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> getTodaysEvents(String name) async {
  var request = createRequest('GET', 'v1/today');
  var response = await request.send();

  if (response.statusCode == 200) {
    Map<String, dynamic> body = new Map<String, dynamic>();
    body = jsonDecode(await response.stream.bytesToString());

    return body['data']; ///return response data from api
  } else {
    //Wrong input
    print(response.reasonPhrase);
    return null;
  }
}

Future<List<dynamic>?> getTimeGrid() async {
  var request = createRequest('GET', 'v1/timegrid');
  var response = await request.send();

  if (response.statusCode == 200) {
    Map<String, dynamic> body = new Map<String, dynamic>();
    body = jsonDecode(await response.stream.bytesToString());

    return body['data']; ///return response data from api
  } else {
    //Wrong input
    print(response.reasonPhrase);
    return null;
  }
}

Future<List<dynamic>?> getTimeTable(DateTime date, int classId) async {
  var request = createRequest('GET', 'v1/timetable/$classId/${date.year}/${date.month}/${date.day}');
  var response = await request.send();

  if (response.statusCode == 200) {
    Map<String, dynamic> body = new Map<String, dynamic>();
    body = jsonDecode(await response.stream.bytesToString());

    return body['data']; ///return response data from api
  } else {
    //Wrong input
    print(response.reasonPhrase);
    return null;
  }
}

Future<List<dynamic>?> getTimeTableWithFilter(DateTime date, int classId, List<int> filter) async {
  var request = createRequest('POST', 'v1/timetable/filter/$classId/${date.year}/${date.month}/${date.day}');

  request.body = jsonEncode({
    'filter': filter,
    'test': '123'
  });

  print(request.toString());

  var response = await request.send();

  if (response.statusCode == 200) {
    Map<String, dynamic> body = new Map<String, dynamic>();
    body = jsonDecode(await response.stream.bytesToString());

    return body['data']; ///return response data from api
  } else {
    //Wrong input
    print(await response.stream.bytesToString());
    print(response.statusCode);
    print(response.reasonPhrase);
    return null;
  }
}

Future<Map<String, dynamic>?> getSubjectList(int classId) async {
  var request = createRequest('GET', 'v1/subjectsList/$classId');
  var response = await request.send();

  if (response.statusCode == 200) {
    Map<String, dynamic> body = new Map<String, dynamic>();
    body = jsonDecode(await response.stream.bytesToString());

    return body['data']; ///return response data from api
  } else {
    //Wrong input
    print(response.reasonPhrase);
    return null;
  }
}

Future<List<dynamic>?> getClasses() async {
  var request = createRequest('GET', 'v1/classes');
  var response = await request.send();

  if (response.statusCode == 200) {
    Map<String, dynamic> body = new Map<String, dynamic>();
    body = jsonDecode(await response.stream.bytesToString());

    return body['data']; ///return response data from api
  } else {
    //Wrong input
    print(response.reasonPhrase);
    return null;
  }
}

String getTimeFromBlockNumber(int block) {

  switch(block) {
    case 1:
      return "8:30";
    case 2:
      return "9:15";
    case 3:
      return "10:20";
    case 4:
      return "11:05";
    case 5:
      return "12:50";
    case 6:
      return "13:35";
    case 7:
      return "14:30";
    case 8:
      return "15:15";
    case 9:
      return "16:10";
    case 10:
      return "16:55";
    default:
      return "-";
  }
}

///getTimeFromBlockNumber(i).split(':')[0]

DateTime getDateTimeFromBlockNumber(int block, DateTime dateTime) {

  int hour = 0, minute = 0;

  switch(block) {
    case 1:
      hour = 8;
      minute = 30;
      break;
    case 2:
      hour = 9;
      minute = 15;
      break;
    case 3:
      hour = 10;
      minute = 20;
      break;
    case 4:
      hour = 11;
      minute = 5;
      break;
    case 5:
      hour = 12;
      minute = 50;
      break;
    case 6:
      hour = 13;
      minute = 35;
      break;
    case 7:
      hour = 14;
      minute = 30;
      break;
    case 8:
      hour = 15;
      minute = 15;
      break;
    case 9:
      hour = 16;
      minute = 10;
      break;
    case 10:
      hour = 16;
      minute = 55;
      break;
    default:
      hour = 1;
      minute = 0;
      break;
  }

  return new DateTime(dateTime.year, dateTime.month, dateTime.day, hour, minute);
}

int getBlockNumberFromTime(String time) {
  String timeFormat = time.replaceAll(':', '');

  switch(timeFormat) {
    case "830":
      return 1;
      break;
    case "915":
      return 2;
      break;
    case "1020":
      return 3;
      break;
    case "1105":
      return 4;
      break;
    case "1250":
      return 5;
      break;
    case "1335":
      return 6;
      break;
    case "1430":
      return 7;
      break;
    case "1515":
      return 8;
      break;
    case "1610":
      return 9;
      break;
    case "1655":
      return 10;
      break;
    default:
      return -1;
  }

  // DateTime today = DateTime.now();
  //
  // httpBuilder.Request request = new httpBuilder.Request('GET', 'v1/timegrid', true, false, true);
  // httpBuilder.Response response = await request.flush();
  // await response.checkCache();
  //
  // var result = 0;
  //
  // response.onSuccess((data) {
  //   data?.forEach((day) {
  //     if(day['day'] == (today.weekday - 1)) {
  //       List<dynamic> timeGrid = day['time'];
  //
  //       timeGrid.forEach((block) {
  //         if(block['startTime'] == timeFormat) {
  //           result = block['name'];
  //         }
  //       });
  //     }
  //   });
  // });
  //
  // response.onNoResult((data) {
  //   switch(timeFormat) {
  //     case "830":
  //       result = 1;
  //       break;
  //     case "915":
  //       result = 2;
  //       break;
  //     case "1020":
  //       result = 3;
  //       break;
  //     case "1105":
  //       result = 4;
  //       break;
  //     case "1250":
  //       result = 5;
  //       break;
  //     case "1335":
  //       result = 6;
  //       break;
  //     case "1430":
  //       result = 7;
  //       break;
  //     case "1515":
  //       result = 8;
  //       break;
  //     case "1610":
  //       result = 9;
  //       break;
  //     case "1655":
  //       result = 10;
  //       break;
  //     default:
  //       return -1;
  //   }
  // });
  //
  // response.onError((data) {
  //   switch(timeFormat) {
  //     case "830":
  //       result = 1;
  //       break;
  //     case "915":
  //       result = 2;
  //       break;
  //     case "1020":
  //       result = 3;
  //       break;
  //     case "1105":
  //       result = 4;
  //       break;
  //     case "1250":
  //       result = 5;
  //       break;
  //     case "1335":
  //       result = 6;
  //       break;
  //     case "1430":
  //       result = 7;
  //       break;
  //     case "1515":
  //       result = 8;
  //       break;
  //     case "1610":
  //       result = 9;
  //       break;
  //     case "1655":
  //       result = 10;
  //       break;
  //     default:
  //       return -1;
  //   }
  // });
  //
  // await response.process();
  //
  // return result;
}

int weekNumber(DateTime date) {
  final startOfYear = new DateTime(date.year, 1, 1, 0, 0);

  final firstMonday = startOfYear.weekday;
  final daysInFirstWeek = 8 - firstMonday;
  final diff = date.difference(startOfYear);

  var weeks = ((diff.inDays - daysInFirstWeek) / 7).ceil();

  if(daysInFirstWeek > 3) {
    weeks += 1;
  }
  return weeks;
}

class Timetable {

  late bool hasStudienzeit;
  late DateTime dateTime, lastRefresh;
  late int classId;
  late bool forceRequest, isSchool = true;
  late List<int> courses;
  late List<Widget> result = [], error = [];

  late VoidCallback refresh;

  List<TimeTableElement> timeTable = [];

  Timetable(DateTime date, int classId, List<int> courses, bool forceRequest, VoidCallback refresh) {
    this.dateTime = date;
    this.courses = courses;
    this.classId = classId;
    this.forceRequest = forceRequest;
    this.refresh = refresh;
  }

  Future<void> askAPI() async {

    result.clear(); ///<-- Clear result cache to prevent multiple elements

    if(dateTime.weekday == 6 || dateTime.weekday == 7) {
      error.add(Container(
        child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  child: Center(
                    child: Icon(Icons.weekend, size: 40, color: Colors.grey,),
                  ),
                ),
                Container(
                  child: Center(
                    child: Text(
                      'Heute ist Wochenende,\n du hast keine Schule',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            )
        ),
      ));
      isSchool = false;
      return;
    }

    httpBuilder.Request request = new httpBuilder.Request('GET', 'v1/timetable/$classId/${dateTime.year}/${dateTime.month}/${dateTime.day}', true, forceRequest, !forceRequest);
    httpBuilder.Response response = await request.flush();
    await response.checkCache();

    bool noEntry = false;

    response.onSuccess((timetable) {

      List<int> hours = [0];

      ///No entries found, check for holidays later
      if(timetable.length == 0) {
        noEntry = true;
        return;
      }

      timetable.forEach((element) async {
        var subject = element['subject'], start = element['start'], status = element['status'];

        int classStatus = 0;

        if(courses.contains(subject['id'])) {
          var block = getBlockNumberFromTime('${start['hour']}:${start['minute']}');
          var lastItem = hours[hours.length - 1];

          if(hours[hours.length - 1] + 1 != block) {
            int lastBlock = 0;
            for(int i = lastItem + 1; i < block; i++) {
              lastBlock = i;

              timeTable.add(new TimeTableElement(true, i, classStatus));

              // result.add(TimeTableFreeElement(hour: '$i.', time: getTimeFromBlockNumber(i), isOver: (DateTime.now().isAfter(getDateTimeFromBlockNumber(block, dateTime)))));
            }
            hours.add(lastBlock);
          }

          hours.add(block);

          switch (status['type']) {
            case 'CLASS': classStatus = 0; break;
            case 'CANCELED': classStatus = 1; break;
            case 'INFO': classStatus = 2; break;
          }

          ///Adding full element to timetable queue
          try {
            TimeTableElement tableElement = new TimeTableElement(false, block, classStatus);
            tableElement.setElement(element);
            timeTable.add(tableElement);
          } catch(_) {
            print(_);
          }

          // result.add(TimetableElement(
          //     status: classStatus,
          //     hour: '$block.',
          //     time: '${start['hour']}:${start['minute']}',
          //     title: subject['name'],
          //     subtitle: teacherName,
          //     data: element,
          //     isOver: (DateTime.now().isAfter(getDateTimeFromBlockNumber(block, dateTime)))
          // ));
        }

      });
      lastRefresh = DateTime.now();
    });

    response.onNoResult((data) { ///No connection
      error.add(NoInternetConnectionScreen(refresh: () {
        refresh();
      }));
    });

    response.onError((data) { ///Server Error
      error.add(AnErrorOccurred(refresh: () {
        refresh();
      }));
    });

    await response.process();

    ///No subjects were provided, checking for connection and holidays
    if(noEntry) {
      ///Timetable Plan Request
      httpBuilder.Request request = new httpBuilder.Request('GET', 'v1/holidays', true, forceRequest, !forceRequest);
      httpBuilder.Response response = await request.flush();
      await response.checkCache();

      response.onSuccess((results) {
        var begin, ending;

        results.forEach((element) async {
          begin = element['start']; ending = element['end'];

          DateTimeRange dtr = new DateTimeRange(
              start: new DateTime(int.parse(begin['year']), int.parse(begin['month']), int.parse(begin['day'])),
              end: new DateTime(int.parse(ending['year']), int.parse(ending['month']), int.parse(ending['day'])
              ));

          if(dateTime.isAfter(dtr.start) && dateTime.isBefore(dtr.end)) {
            isSchool = false;
            error.add(CustomMessageScreen(refresh: () => {}, message: 'Heute sind Ferien\n- ${element['name']} -', icon: Icons.holiday_village_outlined));
          }
        });

        if(error.length == 0) {
          isSchool = false;
          error.add(CustomMessageScreen(refresh: () => {}, message: 'Es wurden keine Informationen\nzu diesem Tag gefunden', icon: Icons.error_outline,));
        }
      });

      response.onNoResult((data) => {});
      response.onError((data) => {});

      await response.process();
    }

  }

  bool hasSchool() {
    return this.isSchool;
  }

  Future<List<Widget>> getTimeTable() async {
    bool swappedZK = await getBoolean('var-st-swapp');

    if(error.length == 0) {
      List<TimeTableElement> list = timeTable;
      List<int> doubles = [];

      list.forEach((a) async {
        if(!a.isFree()) {
          list.forEach((b) {

            if(a.block == b.block && a.rayId != b.rayId && !doubles.contains(a.block) && !a.subject['name'].toString().startsWith('StZ')) { ///Studienzeit Filter
              doubles.add(a.block);

              if(a.room['id'] != b.room['id']) {
                b.status['message'] = 'Raumänderung zu ${b.room['name']}';
              }
              if(a.subject['id'] != b.subject['id']) {
                b.status['message'] = 'Fachänderung zu ${b.subject['name']}';
              }
              if(a.teacher['id'] != b.teacher['id']) {
                b.status['message'] = 'Vertretung durch ${b.teacher['firstname']} ${b.teacher['lastname']}';
              }

              a.element['optimized'] = 1;
            }
          });

          ///Studienzeit swap
          if(a.subject['name'].toString().startsWith('StZ')) {
            if(a.subject['name'].toString().endsWith('A')) {
              if(!swappedZK) {
                if(weekNumber(dateTime).floor().isEven) {
                  a.element['optimized'] = 1;
                  print('a1');
                }
              } else {
                if(weekNumber(dateTime).floor().isOdd) {
                  a.element['optimized'] = 1;
                  print('a2');
                }
              }
            } else if (a.subject['name'].toString().endsWith('B')) {
              if(!swappedZK) {
                if(weekNumber(dateTime).floor().isOdd) {
                  a.element['optimized'] = 1;
                  print('a3');
                }
              } else {
                if(weekNumber(dateTime).floor().isEven) {
                  a.element['optimized'] = 1;
                  print('a4');
                }
              }
            }
          }
        }

      });

      return getWidgetTree(list);
    } else return error;
  }

  List<Widget> getWidgetTree(List<TimeTableElement> list) {
    List<Widget> subjects = [];

    list.forEach((element) {

      try {
        if(element.isFree()) {
          subjects.add(TimeTableFreeElement(hour: '${element.block}', time: getTimeFromBlockNumber(element.block), isOver: (DateTime.now().isAfter(getDateTimeFromBlockNumber(element.block, dateTime)))));
        } else if(element.element['optimized'] == null) {
          ///Build teachers full name
          String teacherName = '${element.teacher['firstname']} ${element.teacher['lastname']}';
          if(element.teacher['firstname'] == null || element.teacher['lastname'] == null) teacherName = '-';
          if(teacherName.split('')[0] == ' ') teacherName = teacherName.substring(1, teacherName.length);

          subjects.add(TimetableElement(
              status: element.classStatus,
              hour: '${element.block}.',
              time: '${element.start['hour']}:${element.start['minute']}',
              title: element.subject['name'],
              subtitle: teacherName + ' - ' + element.room['short'],
              data: element.element,
              isOver: (DateTime.now().isAfter(getDateTimeFromBlockNumber(element.block, dateTime)))
          ));
        }
      } catch(_) {
      }
    });

    return subjects;
  }

  List<TimeTableElement> getStudienzeiten() {
    List<TimeTableElement> studienzeiten = [];

    timeTable.forEach((element) {
      if(!element.isFree() && element.subject['name'].toString().startsWith('StZ')) {
        studienzeiten.add(element);
      }
    });

    return studienzeiten;
  }
}

class TimeTableElement {

  late bool free;
  late Map<String, dynamic> element;
  late int id = 0, rayId = 0, block = 0, classStatus;
  late Map<String, dynamic> subject, start, end, teacher, status, date, classObj, room;

  TimeTableElement(bool free, int block, int status) {
    this.free = free;
    this.block = block;
    this.classStatus = status;
  }

  isFree() {return free;}

  setElement(Map<String, dynamic> element) {
    if(isFree()) return;

    this.element = element;

    this.id = element['id'];

    this.rayId = element['rayid'];

    this.date = element['date'];

    this.classObj = element['class'];
    this.subject = element['subject'];

    this.start = element['start'];
    this.end = element['end'];

    this.room = element['room'];
    this.teacher = element['teacher'];

    this.status = element['status'];
  }
}