import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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