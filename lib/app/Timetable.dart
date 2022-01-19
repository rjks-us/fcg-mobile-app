import 'dart:convert';

import 'package:fcg_app/app/utils/TimetableUtils.dart';
import 'package:fcg_app/fcgapp/components/question_card.dart';
import 'package:fcg_app/fcgapp/components/timetable_card.dart';
import 'package:fcg_app/fcgapp/main.dart';
import 'package:fcg_app/network/RequestHandler.dart' as RequestHandler;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimetableBuilder {

  TimetableHandler timetableHandler = new TimetableHandler();

  late DateTime dateTime;
  late int classId;
  late List<int> subscribedClasses;

  late List<TimetableEntry> timetableEntry = [];

  late TimetableHoliday timetableHoliday;

  bool holiday = false, weekend = false, error = false, noResult = false;

  TimetableBuilder(this.dateTime, this.classId, this.subscribedClasses);

  Future<TimetableBuilder> loadTimeTable() async {
    List<TimetableEntry> _tmpTimetableEntry = [];

    if(this.subscribedClasses.length == 0) {
      _tmpTimetableEntry = await timetableHandler.getTimetable(classId, dateTime);
    } else {
      _tmpTimetableEntry = await timetableHandler.getTimetableWithFilter(classId, dateTime, subscribedClasses);
    }

    this.timetableEntry = _tmpTimetableEntry;

    if(_tmpTimetableEntry.length == 0) {
      bool _connectionAvailable = await RequestHandler.deviceIsConnectedToInternet();

      if(!_connectionAvailable) {
        this.error = true;
        return this;
      } else {

        ///CHECK FOR WEEKEND
        if(dateTime.weekday == 6 || dateTime.weekday == 7) {
          this.weekend = true;
          return this;
        } else {
          ///CHECK FOR HOLIDAYS
          List<TimetableHoliday> _tmpTimetableHolidays = await timetableHandler.getHolidayList();

          if(_tmpTimetableHolidays.length == 0) { ///No connection!
            this.error = true;
          } else {
            _tmpTimetableHolidays.forEach((element) {
              if(element.isCurrentlyActive(this.dateTime)) {
                this.holiday = true;
                this.timetableHoliday = element;
              }
            });
            if(!this.holiday) {
              this.noResult = true;
            }
            return this;
          }

        }
      }
    }
    return this;
  }

  List<TimetableEntry> getStudienzeiten() {
    List<TimetableEntry> studienzeiten = [];

    timetableEntry.forEach((element) {
      if(element.timetableSubject.name.startsWith('StZ')) {
        studienzeiten.add(element);
      }
    });

    return studienzeiten;
  }

  Future<List<Widget>> toWidget(bool indicateOverSubjects) async {

    Map<String, List<TimetableEntry>> _sortedTimetableElements = sortElements(this.timetableEntry);

    List<TimetableEntry> _mergedElements = _mergeMultipleElement(_sortedTimetableElements);

    List<TimetableEntry> _replacedStudienzeitList = await _replaceStudienzeit(_mergedElements);

    List<Widget> _finElements = _fillGapsWithFreeTime(_replacedStudienzeitList, indicateOverSubjects);

    return _finElements;

    // bool _stHasToBeShown = await device.studienzeitQuestionBoxHasToBeShown();
    //
    // if(_stHasToBeShown) {
    //   List<Widget> _final = [];
    //
    //   _final.add(await getQuestionCard());
    //
    //   _final.addAll(_finElements);
    //
    //   print()
    //
    //   return _final;
    // } else {
    //   return _finElements;
    // }
  }

  Future<List<TimetableEntry>> _replaceStudienzeit(List<TimetableEntry> _timetableSortedCollection) async {
    List<TimetableEntry> _finalTimetableCollection = [];

    bool swappedZK = await device.isStudienzeitSwapped();
    _timetableSortedCollection.forEach((element) {
      String name = element.timetableSubject.name;

      if(name.startsWith('StZ')) {
        if(name.endsWith('A')) {
          if(!swappedZK) {
            if(weekNumber(dateTime).floor().isEven) {
              _finalTimetableCollection.add(element);
            }
          } else {
            if(weekNumber(dateTime).floor().isOdd) {
              _finalTimetableCollection.add(element);
            }
          }
        } else if(name.endsWith('B')) {
          if(!swappedZK) {
            if(weekNumber(dateTime).floor().isOdd) {
              _finalTimetableCollection.add(element);
            }
          } else {
            if(weekNumber(dateTime).floor().isEven) {
              _finalTimetableCollection.add(element);
            }
          }
        }
      } else {
        _finalTimetableCollection.add(element);
      }
    });

    return _finalTimetableCollection;
  }

  List<Widget> _fillGapsWithFreeTime(List<TimetableEntry> _timetableSortedCollection, bool indicateOverSubjects) {
    List<Widget> _finalTimetableCollection = [];

    List<int> _blocks = [];

    _timetableSortedCollection.forEach((element) {
      int block = getBlockNumberFromStartTime(element.startHour.toString() + ':' + element.startMinute.toString());
      _blocks.add(block);
    });

    int _maxValue = _blocks.reduce((curr, next) => curr > next? curr: next); ///Get highest block number

    for(int i = 1; i < _maxValue + 1; i++) {
      TimetableEntry? _tmpTimetableEntry;

      for(int a = 0; a < _timetableSortedCollection.length; a++) {
        int block = getBlockNumberFromStartTime(_timetableSortedCollection[a].startHour.toString() + ':' + _timetableSortedCollection[a].startMinute.toString());

        if(block == i) {
          _tmpTimetableEntry = _timetableSortedCollection[a];
        }
      }
      if(_tmpTimetableEntry != null) {
        String startString = _tmpTimetableEntry.startHour.toString() + ':' + _tmpTimetableEntry.startMinute.toString();

        int block = getBlockNumberFromStartTime(startString);

        _finalTimetableCollection.add(new TimetableContentCard(
            timetableEntry: _tmpTimetableEntry,
            activeBlock: block,
            isOver: (!indicateOverSubjects) ? false : (new DateTime.now().isAfter(new DateTime(
                _tmpTimetableEntry.date.year,
                _tmpTimetableEntry.date.month,
                _tmpTimetableEntry.date.day,
                _tmpTimetableEntry.startHour,
                _tmpTimetableEntry.startMinute)
            ))
        ));
      } else {
        _finalTimetableCollection.add(new TimetableEmptyCard(
            hour: i.toString(),
            time: '${getDateTimeFromBlockNumber(i, this.dateTime).hour}:${getDateTimeFromBlockNumber(i, this.dateTime).minute}',
            isOver: (!indicateOverSubjects) ? false : (new DateTime.now().isAfter(new DateTime(
                this.dateTime.year,
                this.dateTime.month,
                this.dateTime.day,
                getDateTimeFromBlockNumber(i, this.dateTime).hour,
                getDateTimeFromBlockNumber(i, this.dateTime).minute)
        ))));
      }
    }

    return _finalTimetableCollection;
  }

  List<TimetableEntry> _mergeMultipleElement(Map<String, List<TimetableEntry>> _timetableSortedCollection) {
    List<TimetableEntry> _finalTimetableCollection = [];

    _timetableSortedCollection.forEach((key, value) {

      if(value.length == 1) {
        _finalTimetableCollection.add(value[0]);
      } else {
        TimetableEntry _info = value[0], _canceled = value[1];

        if(value[0].timetableEntryState.state == 1) {
          _info = _canceled;
          _canceled = value[1];
        }

        _canceled.timetableRoom = _info.timetableRoom;

        if(_canceled.timetableTeacher.hasTeacher || _canceled.timetableRoom.hasRoom) _canceled.timetableEntryState = new TimetableEntryState({
          'type': 'CANCELED',
          'message': 'eigenverantwortliches Arbeiten'
        });

        _finalTimetableCollection.add(_canceled);
      }
    });

    return _finalTimetableCollection;
  }

  Map<String, List<TimetableEntry>> sortElements(List<TimetableEntry> _timetableEntrys) {
    Map<String, List<TimetableEntry>> _finalList = new Map();

    _timetableEntrys.forEach((element) {
      String _identifier = element.timetableSubject.id.toString() + element.startHour.toString() + element.startMinute.toString();

      if(_finalList[_identifier] == null) {
        _finalList[_identifier] = [element];
      } else {
        _finalList[_identifier]!.add(element);
      }
    });

    return _finalList;
  }

  Future<Widget> getQuestionCard() async {
    List<TimetableEntry> st = getStudienzeiten();

    if(await device.studienzeitQuestionBoxHasToBeShown() && st != [] && st.length == 4) {
      return QuestionCard(
        visible: true,
        title: 'Welche Studienzeit hast du heute?',
        subtitle: 'Dies kann von dir jeder Zeit in den Einstellungen geändert werden.',
        option1: st[0].timetableSubject.name + ' - ' + st[0].timetableTeacher.shortName,
        option2: st[1].timetableSubject.name + ' - ' + st[1].timetableTeacher.shortName,
        callback1: () {
          if(weekNumber(this.dateTime).floor().isEven) {
            device.setStudienzeitLastChangeDate(true);
          } else {
            device.setStudienzeitLastChangeDate(false);
          }
        },
        callback2:() {
          if(weekNumber(this.dateTime).floor().isOdd) {
            device.setStudienzeitLastChangeDate(true);
          } else {
            device.setStudienzeitLastChangeDate(false);
          }
        },
      );
    }

    return Container();
  }
}

class TimetableHandler {

  TimetableHandler();

  Future<List<SchoolClass>> getClassList() async {
    List<SchoolClass> _timetableClasses = [];

    RequestHandler.Request request = RequestHandler.Request('GET', 'v1/classes');

    var response = request.send();

    await response.processResponse();

    response.onSuccess((data) {
      data.forEach((dataElement) {
        _timetableClasses.add(new SchoolClass(dataElement));
      });
    });

    response.onError((httpResponse) {
      print('[TIMETABLE] Unable to load the class list');
    });

    response.registerListeners();

    return _timetableClasses;
  }

  Future<List<TimetableSubjectCollection>> getOrderedSubjectList(int classId) async {
    List<TimetableSubjectCollection> _timetableClasses = [];

    RequestHandler.Request request = RequestHandler.Request('GET', 'v1/subjectsList/$classId');

    var response = request.send();

    await response.processResponse();

    response.onSuccess((data) {

      data.forEach((key, value) {
        List<SchoolCourse> _courses = [];
        try {
          value.forEach((element) {
            _courses.add(new SchoolCourse(element));
          });

          _timetableClasses.add(new TimetableSubjectCollection(key, _courses));
        } catch(_) {
          print(_);
        }
      });
    });

    response.onError((httpResponse) {
      print('[TIMETABLE] Unable to load the class list');
    });

    response.registerListeners();

    return _timetableClasses;
  }

  Future<List<TimetableHoliday>> getHolidayList() async {
    List<TimetableHoliday> _timetableHolidays = [];

    RequestHandler.Request request = RequestHandler.Request('GET', 'v1/holidays');

    var response = request.send();

    await response.processResponse();

    response.onSuccess((data) {

      for(int i = 0; i < data.length; i++) {
        Map<String, dynamic> _selectedElement = data[i];

        try {
          _timetableHolidays.add(new TimetableHoliday(_selectedElement));
        } catch(_) {
          print(_);
        }
      }
    });

    response.onError((httpResponse) {
      print('[TIMETABLE] Unable to load the holidays list');
    });

    response.registerListeners();

    return _timetableHolidays;
  }

  Future<List<TimetableDay>> getTimegrid() async {
    List<TimetableDay> _timegrid = [];

    RequestHandler.Request request = RequestHandler.Request('GET', 'v1/timegrid');

    var response = request.send();

    await response.processResponse();

    response.onSuccess((data) {

      for(int i = 0; i < data.length; i++) {
        Map<String, dynamic> _selectedElement = data[i];

        _timegrid.add(new TimetableDay(_selectedElement));
      }
    });

    response.onError((httpResponse) {
      print('[TIMETABLE] Unable to load the timegrid');
    });

    response.registerListeners();

    return _timegrid;
  }

  Future<List<TimetableEntry>> getTimetable(int classId, DateTime dateTime) async {
    List<TimetableEntry> _timetable = [];

    RequestHandler.Request request = RequestHandler.Request('GET', 'v1/timetable/$classId/${dateTime.year}/${dateTime.month}/${dateTime.day}');

    var response = request.send();

    await response.processResponse();

    response.onSuccess((data) {

      for(int i = 0; i < data.length; i++) {
        Map<String, dynamic> _selectedElement = data[i];
        try {
          _timetable.add(new TimetableEntry(_selectedElement));
        } catch(_) {
          print(_);
        }
      }
    });

    response.onError((httpResponse) {
      print('[TIMETABLE] Unable to load the timetable for ${dateTime.year}/${dateTime.month}/${dateTime.day}');
    });

    response.registerListeners();

    return _timetable;
  }

  Future<List<TimetableEntry>> getTimetableWithFilter(int classId, DateTime dateTime, List<int> filter) async {
    List<TimetableEntry> _timetable = [];

    RequestHandler.Request request = RequestHandler.Request('POST', 'v1/timetable/filter/$classId/${dateTime.year}/${dateTime.month}/${dateTime.day}');

    request.setBody({"filter": filter});
    request.setHeader(request.buildAccessHeader(''));

    var response = request.send();

    await response.processResponse();

    response.onSuccess((data) {

      for(int i = 0; i < data.length; i++) {
        Map<String, dynamic> _selectedElement = data[i];

        _timetable.add(new TimetableEntry(_selectedElement));
      }
    });

    response.onError((httpResponse) {
      print('[TIMETABLE] Unable to load the timetable with filter for ${dateTime.year}/${dateTime.month}/${dateTime.day}');
    });

    response.registerListeners();

    return _timetable;
  }
}

class TimetableHoliday {

  late Map<String, dynamic> query;

  late String shortName, longName;
  late DateTime startDate, endDate;
  late int id;

  TimetableHoliday(Map<String, dynamic> query) {

    this.id = query['id'];
    this.shortName = query['short'];
    this.longName = query['name'];

    var start = query['start'], end = query['end'];

    this.startDate = new DateTime(int.parse(start['year']), int.parse(start['month']), int.parse(start['day']));
    this.endDate = new DateTime(int.parse(end['year']), int.parse(end['month']), int.parse(end['day']));

  }

  bool isCurrentlyActive(DateTime date) {
    return (date.isAfter(this.startDate) && date.isBefore(this.endDate));
  }

}

class SchoolClass {

  late Map<String, dynamic> query;

  late String shortName, longName;
  late List<dynamic> teachers;
  late int id;

  bool hasTeachers = true;

  SchoolClass(Map<String, dynamic> query) {

    this.query = query;

    this.id = query['id'];
    this.shortName = query['short'];

    this.longName = query['name'];

    if(query['teachers'].length == 0) {
      this.hasTeachers = false;
    } else {
      this.teachers = query['teachers'];
    }
  }

}

class SchoolCourse {

  late Map<String, dynamic> query;

  late int id;
  late String shortName, longName;

  late TimetableTeacher timetableTeacher;
  late TimetableClass timetableClass;

  SchoolCourse(Map<String, dynamic> query) {

    this.query = query;

    this.id = query['id'];
    this.shortName = query['short'];
    this.longName = query['name'];

    if(query['teacher'].toString() == '{}') {
      query['teacher'] = {
        'id': 1,
        'short': '-',
        'lastname': '',
        'firstname': '-'
      };
    }

    this.timetableClass = new TimetableClass(query['class']);
    this.timetableTeacher = new TimetableTeacher(query['teacher']);
  }

}

class TimetableEntry {

  late int id, rayId;
  late int startMinute, startHour, endMinute, endHour;

  late DateTime date;

  late Map<String, dynamic> query;

  late TimetableClass timetableClass;
  late TimetableTeacher timetableTeacher;
  late TimetableSubject timetableSubject;
  late TimetableRoom timetableRoom;
  late TimetableEntryState timetableEntryState;

  TimetableEntry(Map<String, dynamic> _query) {

    this.query = _query;

    this.id = _query['id'];
    this.rayId = _query['rayid'];

    var start = _query['start'], end = _query['end'];

    this.startMinute = int.parse(start['minute'].toString());
    this.startHour = int.parse(start['hour'].toString());

    this.endMinute = int.parse(end['minute'].toString());
    this.endHour = int.parse(end['hour'].toString());

    var date = _query['date'];

    this.date = new DateTime(int.parse(date['year']), int.parse(date['month']), int.parse(date['day']));

    this.timetableClass = new TimetableClass(_query['class']);

    this.timetableTeacher = new TimetableTeacher(_query['teacher']);

    this.timetableSubject = new TimetableSubject(_query['subject']);

    this.timetableRoom = new TimetableRoom(_query['room']);

    this.timetableEntryState = new TimetableEntryState(_query['status']);
  }

  String getIdentifier() {
    return '${this.id}-';
  }
}

class TimetableClass {

  late Map<String, dynamic> query;

  late int id;
  late String shortName, longName;

  TimetableClass(Map<String, dynamic> _query) {

    this.query = _query;

    this.id = _query['id'];
    this.shortName = _query['short'];
    this.longName = _query['name'];
  }

}

class TimetableTeacher {

  late Map<String, dynamic> query;

  late int id;
  late String shortName, firstName, lastName;

  bool hasTeacher = true;

  TimetableTeacher(Map<String, dynamic> _query) {

    this.query = _query;

    if(_query['id'] != null) {
      this.id = _query['id'];
      this.shortName = (_query['short'] == null) ? '' : _query['short'];
      this.firstName = (_query['firstname'] == null) ? '' : _query['firstname'];
      this.lastName = (_query['lastname'] == null) ? '' : _query['lastname'];
    } else {
      this.hasTeacher = false;
    }
  }

  String getFullName() {
    if(!this.hasTeacher) return '-';

    String teacherName = '${this.firstName} ${this.lastName}';
    if(this.firstName == null || this.lastName == null) teacherName = '-';
    if(teacherName.split('')[0] == ' ') teacherName = teacherName.substring(1, teacherName.length);

    return teacherName;
  }
}

class TimetableSubject {

  late Map<String, dynamic> query;

  late int id;
  late String short, name;

  bool hasSubject = true;

  TimetableSubject(Map<String, dynamic> query) {

    this.query = query;

    if(query['id'] != null) {
      this.id = query['id'];
      this.short = query['short'];
      this.name = query['name'];
    } else {
      this.hasSubject = false;
    }
  }
}

class TimetableRoom {

  late Map<String, dynamic> query;

  late int id;
  late String short, name;

  bool hasRoom = true;

  TimetableRoom(Map<String, dynamic> _query) {

    this.query = _query;

    if(_query['id'] != null) {
      this.id = query['id'];
      this.short = query['short'];
      this.name = query['name'];
    } else {
      this.hasRoom = false;
    }
  }
}

class TimetableEntryState {

  late Map<String, dynamic> query;

  late int state;
  late String message, type;

  TimetableEntryState(Map<String, dynamic> _query) {

    this.query = _query;

    this.type = _query['type'];

    switch(this.type) {
      case 'CLASS': state = 0; break;
      case 'CANCELED': state = 1; break;
      case 'INFO': state = 2; break;
    }

    if(_query['message'] != null) {
      this.message = _query['message'];
    } else {
      this.message = 'Es wurden keine Anmerkungen gefunden';
    }
  }

}

class TimetableDay {

  late Map<String, dynamic> query;

  late int no;
  late String name;
  late List<TimetableBlock> _blocks;

  TimetableDay(Map<String, dynamic> query) {

    this.query = query;

    this.name = query['name'];
    this.no = query['day'];

    List<Map<String, dynamic>> _time = query['time'];
    _time.forEach((block) => _blocks.add(new TimetableBlock(block)));
  }

}

class TimetableBlock {

  late Map<String, dynamic> query;

  late int no;
  late int startMinute, startHour, endMinute, endHour;
  late String startRaw, endRaw;

  TimetableBlock(Map<String, dynamic> query) {

    this.query = query;

    this.no = query['name'];

    String startTime = query['startTime'].toString(), endTime = query['endTime'].toString();

    this.startRaw = startTime;
    this.endRaw = endTime;

    if(startTime.length == 3) {
      this.startMinute = int.parse(startTime[0]);
      this.startHour = int.parse(startTime[1] + startTime[2]);
    } else {
      this.endMinute = int.parse(endTime[0] + endTime[1]);
      this.endHour = int.parse(endTime[2] + endTime[3]);
    }
  }
}

class TimetableSubjectCollection {

  late String name;
  late List<SchoolCourse> list;

  TimetableSubjectCollection(String name, List<SchoolCourse> subjects) {

    this.name = name;
    this.list = subjects;
  }

}