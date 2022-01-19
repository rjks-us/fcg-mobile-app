import 'dart:async';

import 'package:fcg_app/fcgapp/components/loading/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSetupLoadingAnimation extends StatefulWidget {
  const AppSetupLoadingAnimation({Key? key, required this.future, required this.loadingText, required this.errorText, required this.finishText, required this.onLoadFinishEvent}) : super(key: key);

  final String loadingText, errorText, finishText;
  final Function(BuildContext, bool) onLoadFinishEvent;
  final Future<bool> Function() future;

  @override
  _AppSetupLoadingAnimationState createState() => _AppSetupLoadingAnimationState();
}

class _AppSetupLoadingAnimationState extends State<AppSetupLoadingAnimation> {

  String status = '';
  bool gSuccess = true;

  void _refresh() {
    if(this.mounted) setState(() {});
  }

  Future<void> _runFutureTask() async {
    bool success = await widget.future();

    if(success) {
      status = widget.finishText;
    } else {
      status = widget.errorText;
    }

    gSuccess = success;

    Timer(Duration(seconds: 2), () {
        if(this.mounted && success) {
          widget.onLoadFinishEvent(context, success);
        }
    });
  }

  void _onRefreshIsPressed() {
    if(!gSuccess) _refresh();
  }

  @override
  void initState() {
    super.initState();

    status = widget.loadingText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(54, 66, 106, 1),
                Color.fromRGBO(29, 29, 29, 1)
              ]
          ),
        ),
        child: GestureDetector(
          onTap: () => _onRefreshIsPressed(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ColorLoader(),
              FutureBuilder(
                  future: _runFutureTask(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                        child: Text(widget.loadingText, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18),),
                      );
                    } else {
                      return Container(
                        margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                        child: Text(status, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18),),
                      );
                    }
                  }
              )
            ],
          ),
        )
      ),
    );
  }
}
