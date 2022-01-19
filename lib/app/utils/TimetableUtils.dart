int getBlockNumberFromStartTime(String time) {

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
    case "115":
      return 4;
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