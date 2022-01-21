import 'package:fcg_app/app/Timetable.dart';
import 'package:fcg_app/fcgapp/components/block_spacer.dart';
import 'package:fcg_app/fcgapp/components/class_selection_card.dart';
import 'package:fcg_app/fcgapp/components/default_background_design.dart';
import 'package:fcg_app/fcgapp/components/error_messages.dart';
import 'package:fcg_app/fcgapp/components/signature.dart';
import 'package:fcg_app/fcgapp/components/title_section.dart';
import 'package:fcg_app/network/RequestHandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetClassPage extends StatefulWidget {
  const SetClassPage({Key? key, required this.onFinishEvent}) : super(key: key);

  final Function(BuildContext, SchoolClass) onFinishEvent;

  @override
  _SetClassPageState createState() => _SetClassPageState();
}

class _SetClassPageState extends State<SetClassPage> {

  int _classesFound = 0;

  List<Widget> _finalLoadedClassList = [];

  void _refresh() {
    if(this.mounted) setState(() {});
  }

  Future<void> _onRefresh() async {
    _refresh();
  }

  void _onClassSelected(BuildContext buildContext, SchoolClass schoolClass) {
    widget.onFinishEvent(buildContext, schoolClass);
  }

  Future<void> _fetchClasses() async {

    _finalLoadedClassList = [];

    TimetableHandler _timetableHandler = new TimetableHandler();

    List<SchoolClass> _classList = await _timetableHandler.getClassList();

    _classList.forEach((element) {
      _finalLoadedClassList.add(new ClassSelectionCard(
          schoolClass: element,
          onPressEvent: (context, element) => _onClassSelected(context, element)
      ));
    });

    if(_finalLoadedClassList.length == 0) {
      bool _connectionAvailable = await deviceIsConnectedToInternet();

      if(!_connectionAvailable) {
        _finalLoadedClassList.add(NoConnectionAvailableError(refreshPressed: () {
          if(this.mounted) setState(() {});
        }));
      } else {
        _finalLoadedClassList.add(NoEntryFoundError(refreshPressed: () {
          if(this.mounted) setState(() {});
        }));
      }
    }
  }

  @override
  void initState() {
    if(!this.mounted) return;
    // TODO: implement initState
    super.initState();
    _finalLoadedClassList = [];
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
          child: RefreshIndicator(
            backgroundColor: Color.fromRGBO(29, 29, 29, 1),
            color: Colors.indigo,
            onRefresh: _onRefresh,
            child: DefaultBackgroundDesign(
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 80),
                      child: FCGAppLogo(),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20.0, top: 30.0, bottom: 5.0, right: 20.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                        child: Text('Bitte wähle deine\nKlasse/Stufe aus', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 29),),
                      )
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
                      child: Center(
                        child: Text('Wähle deine Klasse indem du auf sie klickst', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 18),),
                      ),
                    ),
                    Container(
                        child: FutureBuilder(
                          future: _fetchClasses(),
                          builder: (context, AsyncSnapshot snapshot) {

                            if(snapshot.connectionState == ConnectionState.waiting) {
                              ///preview loading animation

                              return new Container(
                                margin: EdgeInsets.only(bottom: 50),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    ClassPreLoadingCard(),
                                    ClassPreLoadingCard(),
                                    ClassPreLoadingCard(),
                                    ClassPreLoadingCard(),
                                    ClassPreLoadingCard(),
                                    ClassPreLoadingCard(),
                                  ],
                                ),
                              );
                            } else {
                              ///Release data

                              return new Container(
                                margin: EdgeInsets.only(bottom: 50),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: _finalLoadedClassList,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      BlockSpacer(height: 100)
                    ],
                  ),
                )
            ),
          ),
        )
    );
  }
}
