import 'package:fcg_app/app/Timetable.dart';
import 'package:fcg_app/fcgapp/app.dart';
import 'package:fcg_app/fcgapp/components/buttons.dart';
import 'package:fcg_app/fcgapp/components/default_background_design.dart';
import 'package:fcg_app/fcgapp/components/loading/loading_admination.dart';
import 'package:fcg_app/fcgapp/main.dart';
import 'package:fcg_app/fcgapp/utils/timetable/timetable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimetableElementAdminManipulizePage extends StatefulWidget {
  const TimetableElementAdminManipulizePage({Key? key, required this.timetableEntry}) : super(key: key);

  final TimetableEntry timetableEntry;

  @override
  _TimetableElementAdminManipulizePageState createState() => _TimetableElementAdminManipulizePageState();
}

class _TimetableElementAdminManipulizePageState extends State<TimetableElementAdminManipulizePage> {

  final TextEditingController _messageController = new TextEditingController();

  double _manipulizedState = 1;
  String _manipulizedMessage = 'heute enfällt alles du hund';

  @override
  void initState() {
    _messageController.text = 'eigenverantwortliches Arbeiten';

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 66, 106, 1),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: DefaultBackgroundDesign(
          child: SingleChildScrollView(
              controller: ScrollController(),
              child: Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 40.0, bottom: 20.0),
                      child: Text(
                        widget.timetableEntry.timetableSubject.name + ' - ' + widget.timetableEntry.timetableTeacher.getFullName(),
                        style: TextStyle(
                            fontFamily: 'Nunito-Regular',
                            fontSize: 29.0,
                            color: Colors.white
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
                      child: Text('${widget.timetableEntry.date.day}.${widget.timetableEntry.date.month}.${widget.timetableEntry.date.year} ${widget.timetableEntry.startHour}:${widget.timetableEntry.startMinute} - ${widget.timetableEntry.endHour}:${widget.timetableEntry.endMinute}', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 18),),
                    ),
                    Container(
                      child: Slider(
                        value: _manipulizedState,
                        min: 1,
                        max: 3,
                        divisions: 2,
                        label: (_manipulizedState.round() == 1) ? 'Unterricht' : ((_manipulizedState == 2) ? 'Entfall' : 'Information'),
                        onChanged: (double value) {
                          setState(() {
                            _manipulizedState = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20, top: 20),
                      child: TextField(
                        controller: _messageController,
                        autofocus: true,
                        autocorrect: false,
                        cursorColor: Colors.blue,
                        minLines: 3,
                        maxLines: 3,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Nachricht',
                          fillColor: Color.fromRGBO(54, 66, 106, 1),
                          filled: true,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20.0, top: 25, right: 20.0),
                      child: PrimaryButton(
                        active: true,
                        title: 'Eingabe Speichern',
                        onClickEvent: () {
                          Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => AppSetupLoadingAnimation(
                              future: () async {
                                bool successful = await device.account.manipulateTimetablentry(widget.timetableEntry, _manipulizedState.round() - 1, _messageController.text);

                                return successful;
                              },
                              loadingText: '${widget.timetableEntry.timetableSubject.name} wird manipuliert',
                              errorText: 'Ein Fehler ist aufgetreten, klicke hier um es erneut zu versuchen',
                              finishText: 'Fertig!',
                              onLoadFinishEvent: (loadBuildContext, success) {
                                Navigator.pushAndRemoveUntil(loadBuildContext, CupertinoPageRoute(builder: (context) => DefaultStartApp()), (Route<dynamic> route) => false);
                              }
                          )), (Route<dynamic> route) => false);
                        },
                      ),
                    )
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
}
