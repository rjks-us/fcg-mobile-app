import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoEntryFoundError extends StatefulWidget {
  const NoEntryFoundError({Key? key, required this.refreshPressed}) : super(key: key);

  final VoidCallback refreshPressed;

  @override
  _NoEntryFoundErrorState createState() => _NoEntryFoundErrorState();
}

class _NoEntryFoundErrorState extends State<NoEntryFoundError> {
  @override
  Widget build(BuildContext context) {
    return ErrorMessageTemplate(
        message: 'Es wurden keine\nErgebnisse gefunden',
        icon: Icons.block,
        refreshPressed: widget.refreshPressed
    );
  }
}

class NoConnectionAvailableError extends StatefulWidget {
  const NoConnectionAvailableError({Key? key, required this.refreshPressed}) : super(key: key);

  final VoidCallback refreshPressed;

  @override
  _NoConnectionAvailableErrorState createState() => _NoConnectionAvailableErrorState();
}

class _NoConnectionAvailableErrorState extends State<NoConnectionAvailableError> {
  @override
  Widget build(BuildContext context) {
    return ErrorMessageTemplate(
        message: 'Es besteht keine Verbindung\nzum Internet',
        icon: Icons.wifi_off,
        refreshPressed: widget.refreshPressed
    );
  }
}

class NoPermissionError extends StatefulWidget {
  const NoPermissionError({Key? key, required this.refreshPressed}) : super(key: key);

  final VoidCallback refreshPressed;

  @override
  _NoPermissionErrorState createState() => _NoPermissionErrorState();
}

class _NoPermissionErrorState extends State<NoPermissionError> {
  @override
  Widget build(BuildContext context) {
    return ErrorMessageTemplate(
        message: 'Du hast keine Berechtigung',
        icon: Icons.shield_sharp,
        refreshPressed: widget.refreshPressed
    );
  }
}

class HolidayMessage extends StatefulWidget {
  const HolidayMessage({Key? key, required this.refreshPressed, required this.holidayName}) : super(key: key);

  final String holidayName;
  final VoidCallback refreshPressed;

  @override
  _HolidayMessageState createState() => _HolidayMessageState();
}

class _HolidayMessageState extends State<HolidayMessage> {
  @override
  Widget build(BuildContext context) {
    return ErrorMessageTemplate(
        message: 'Heute sind Ferien\n- ${widget.holidayName} -',
        icon: Icons.holiday_village_outlined,
        refreshPressed: widget.refreshPressed
    );
  }
}

class WeekendMessage extends StatefulWidget {
  const WeekendMessage({Key? key, required this.refreshPressed}) : super(key: key);

  final VoidCallback refreshPressed;

  @override
  _WeekendMessageState createState() => _WeekendMessageState();
}

class _WeekendMessageState extends State<WeekendMessage> {
  @override
  Widget build(BuildContext context) {
    return ErrorMessageTemplate(
        message: 'Heute ist Wochenende,\n du hast keine Schule',
        icon: Icons.weekend,
        refreshPressed: widget.refreshPressed
    );
  }
}

class ErrorMessageTemplate extends StatefulWidget {
  const ErrorMessageTemplate({Key? key, required this.message, required this.icon, required this.refreshPressed}) : super(key: key);

  final String message;
  final IconData icon;
  final VoidCallback refreshPressed;

  @override
  _ErrorMessageTemplateState createState() => _ErrorMessageTemplateState();
}

class _ErrorMessageTemplateState extends State<ErrorMessageTemplate> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () => widget.refreshPressed(),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 15.0),
                child: Center(
                  child: Icon(widget.icon, size: 40, color: Colors.grey,),
                ),
              ),
              Container(
                child: Center(
                  child: Text(
                    widget.message,
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
