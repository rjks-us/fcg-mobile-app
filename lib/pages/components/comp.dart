import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


/// Separation line for elements
class Line extends StatefulWidget {
  const Line({Key? key, required this.title, required this.blurred}) : super(key: key);

  final String title;
  final bool blurred;

  @override
  _LineState createState() => _LineState();
}

class _LineState extends State<Line> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, bottom: 10, right: 20.0, top: 10),
      child: Opacity(
        opacity: widget.blurred ? 0.6 : 1,
        child: Center(
          child: Text(
            widget.title,
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
      )
    );
  }
}

class BigNextButton extends StatefulWidget {
  const BigNextButton({Key? key, required this.title, required this.callback}) : super(key: key);

  final String title;
  final Function callback;

  @override
  _BigNextButtonState createState() => _BigNextButtonState();
}

class _BigNextButtonState extends State<BigNextButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(29, 29, 29, 1),
        ),
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          onTap: () => widget.callback,
          child: Container(
            margin: EdgeInsets.all(10),
            height: 50,
            decoration: BoxDecoration(
                color: Colors.blue
            ),
            child: Center(
              child: Text(widget.title, style: TextStyle(color: Colors.white, fontSize: 22),),
            ),
          ),
        )
    );
  }
}

class TimeTablePreLoadingBox extends StatefulWidget {
  const TimeTablePreLoadingBox({Key? key, required this.time}) : super(key: key);

  final String time;

  @override
  _TimeTablePreLoadingBoxState createState() => _TimeTablePreLoadingBoxState();
}

class _TimeTablePreLoadingBoxState extends State<TimeTablePreLoadingBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        Line(title: widget.time, blurred: true),
        InkWell(
          child: PreLoadingBox(),
        )
      ]),
    );
  }
}


class PreLoadingBox extends StatefulWidget {
  const PreLoadingBox({Key? key}) : super(key: key);

  @override
  _PreLoadingBoxState createState() => _PreLoadingBoxState();
}

class _PreLoadingBoxState extends State<PreLoadingBox> {

  bool selected = false;

  Color from = Color.fromRGBO(48, 48, 52, 0.5);
  Color to = Color.fromRGBO(41, 40, 43, 0.5);

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 0), () {
      if(this.mounted) {
        setState(() {
          selected = !selected;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      height: 60.0,
      duration: Duration(seconds: 1, milliseconds: 5),
      onEnd: () {
        setState(() {
          selected = !selected;
        });
      },
      curve: Curves.ease,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: selected ? from : to,
      ),
    );
  }
}

class ClassPreLoadingBox extends StatefulWidget {
  const ClassPreLoadingBox({Key? key}) : super(key: key);

  @override
  _ClassPreLoadingBoxState createState() => _ClassPreLoadingBoxState();
}

class _ClassPreLoadingBoxState extends State<ClassPreLoadingBox> {
  bool selected = false;

  Color from = Color.fromRGBO(48, 48, 52, 0.5);
  Color to = Color.fromRGBO(41, 40, 43, 0.5);

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 0), () {
      setState(() {
        selected = !selected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      height: 80.0,
      duration: Duration(seconds: 1, milliseconds: 5),
      onEnd: () {
        setState(() {
          selected = !selected;
        });
      },
      curve: Curves.ease,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: selected ? from : to,
      ),
    );
  }
}

class EventPreLoadingBox extends StatefulWidget {
  const EventPreLoadingBox({Key? key}) : super(key: key);

  @override
  _EventPreLoadingBoxState createState() => _EventPreLoadingBoxState();
}

class _EventPreLoadingBoxState extends State<EventPreLoadingBox> {
  bool selected = false;

  Color from = Color.fromRGBO(48, 48, 52, 0.5);
  Color to = Color.fromRGBO(41, 40, 43, 0.5);

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 0), () {
      setState(() {
        selected = !selected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.only(bottom: 10, top: 10),
      height: 120.0,
      duration: Duration(seconds: 1, milliseconds: 5),
      onEnd: () {
        setState(() {
          selected = !selected;
        });
      },
      curve: Curves.ease,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: selected ? from : to,
      ),
    );
  }
}

class NoInternetConnectionScreen extends StatefulWidget {
  const NoInternetConnectionScreen({Key? key, required this.refresh}) : super(key: key);

  final VoidCallback refresh;

  @override
  _NoInternetConnectionScreenState createState() => _NoInternetConnectionScreenState();
}

class _NoInternetConnectionScreenState extends State<NoInternetConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () => widget.refresh(),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 15.0),
              child: Center(
                child: Icon(Icons.wifi_off, size: 40, color: Colors.grey,),
              ),
            ),
            Container(
              child: Center(
                child: Text(
                  'Es besteht keine Verbindung\nzum Internet',
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

class NoResultFoundScreen extends StatefulWidget {
  const NoResultFoundScreen({Key? key, required this.refresh, required this.error}) : super(key: key);

  final VoidCallback refresh;
  final String error;
  
  @override
  _NoResultFoundScreenState createState() => _NoResultFoundScreenState();
}

class _NoResultFoundScreenState extends State<NoResultFoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () => widget.refresh(),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 15.0),
                child: Center(
                  child: Icon(Icons.block, size: 40, color: Colors.grey,),
                ),
              ),
              Container(
                child: Center(
                  child: Text(
                    widget.error,
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

class CustomMessageScreen extends StatefulWidget {
  const CustomMessageScreen({Key? key, required this.refresh, required this.message, required this.icon}) : super(key: key);

  final VoidCallback refresh;
  final String message;
  final IconData icon;

  @override
  _CustomMessageScreen createState() => _CustomMessageScreen();
}

class _CustomMessageScreen extends State<CustomMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () => widget.refresh(),
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

class AnErrorOccurred extends StatefulWidget {
  const AnErrorOccurred({Key? key, required this.refresh}) : super(key: key);

  final VoidCallback refresh;

  @override
  _AnErrorOccurredState createState() => _AnErrorOccurredState();
}

class _AnErrorOccurredState extends State<AnErrorOccurred> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () => widget.refresh(),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 15.0),
                child: Center(
                  child: Icon(
                    Icons.block_outlined, size: 40, color: Colors.grey,),
                ),
              ),
              Container(
                child: Center(
                  child: Text(
                    'Ein Fehler ist aufgetreten,\nbitte versuche es später erneut',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}

class QuestionCard extends StatefulWidget {
  const QuestionCard({Key? key, required this.title, required this.subtitle, required this.option1, required this.callback1, required this.option2, required this.callback2, required this.visible}) : super(key: key);

  final bool visible;
  final String option1, option2, title, subtitle;
  final VoidCallback callback1, callback2;

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {

  bool ready = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Visibility(
        visible: widget.visible,
        child:Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.1),
              borderRadius: BorderRadius.all(Radius.circular(13))
          ),
          child: ready ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(widget.title, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.white),),
                margin: EdgeInsets.all(15),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if(this.mounted) setState(() {
                          ready = !ready;
                          widget.callback1();
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 10, bottom: 20),
                        height: 60,
                        decoration: BoxDecoration(
                            boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 5, spreadRadius: 3)],
                            color: Colors.indigo,
                            borderRadius: BorderRadius.all(Radius.circular(13))
                        ),
                        child: Center(
                          child: Text(widget.option1, style: TextStyle(fontSize: 17, color: Colors.white),),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: InkWell(
                        onTap: () {
                          if(this.mounted) setState(() {
                            ready = !ready;
                            widget.callback2();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 20, bottom: 20),
                          height: 60,
                          decoration: BoxDecoration(
                              boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 3, spreadRadius: 1)],
                              color: Colors.indigo,
                              borderRadius: BorderRadius.all(Radius.circular(13))
                          ),
                          child: Center(
                            child: Text(widget.option2, style: TextStyle(fontSize: 17, color: Colors.white),),
                          ),
                        ),
                      )
                  ),
                ],
              ),
              Container(
                  child: Text(widget.subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey),),
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20,)
              ),
            ],
          ) : Container(
            margin: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Icon(Icons.done, color: Colors.green, size: 35,),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text('Vielen Dank für deine Antwort!', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.white),),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressCard extends StatefulWidget {
  const ProgressCard({Key? key, required this.subtitle, required this.title, required this.value}) : super(key: key);

  final String subtitle, title;
  final double value;

  @override
  _ProgressCardState createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.13),
        borderRadius: BorderRadius.circular(13.0),
        // boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 3, spreadRadius: 1)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
              child: Text(widget.subtitle, textAlign: TextAlign.left, style: TextStyle(fontSize: 12, color: Colors.grey),),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text(widget.title, textAlign: TextAlign.left, style: TextStyle(fontSize: 16, color: Colors.white),),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 10),
            child: Center(
              child: LinearProgressIndicator(
                value: widget.value,
                minHeight: 8,
                backgroundColor: Colors.black12,
                color: Colors.indigo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BlockSpacer extends StatefulWidget {
  const BlockSpacer({Key? key,required this.height}) : super(key: key);

  final double height;

  @override
  _BlockSpacerState createState() => _BlockSpacerState();
}

class _BlockSpacerState extends State<BlockSpacer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
    );
  }
}



void createSettingsModalBottomSheet(var context, Widget content) {
  showModalBottomSheet(context: context, builder: (context) {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      color: Color.fromRGBO(29, 29, 29, 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Row(
              children: [
                Container(
                  child: Center(
                    child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: Colors.white10,)),
                  ),
                ),
              ],
            ),
          ),
          content,
        ],
      ),
    );
  });
}