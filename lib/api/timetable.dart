import 'dart:convert';

import 'package:fcg_app/api/helper.dart';
import 'package:fcg_app/device/device.dart';

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