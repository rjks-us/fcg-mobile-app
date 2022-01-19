class NotificationElement {

  String title, message, sender;
  int iat;
  NotificationAction notificationAction;

  NotificationElement(this.title, this.message, this.sender, this.iat, this.notificationAction);

  DateTime getDateTime() {
    return new DateTime.fromMicrosecondsSinceEpoch(this.iat);
  }
}

class NotificationAction {

  int type;
  String description;

  NotificationAction(this.type, this.description);

}