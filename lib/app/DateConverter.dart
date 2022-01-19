class DateConverter {

  List<String> days = ['Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag'];
  List<String> month = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];

  DateTime dateTime;

  DateConverter(this.dateTime);

  String getWeekDayName() {
    return days[dateTime.weekday - 1];
  }

  String getMonthName() {
    return month[dateTime.month - 1];
  }

}