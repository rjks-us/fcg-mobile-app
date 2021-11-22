import 'dart:convert';

import 'package:fcg_app/api/helper.dart';
import 'package:fcg_app/api/httpBuilder.dart' as httpBuilder;
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