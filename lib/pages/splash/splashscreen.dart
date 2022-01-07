import 'dart:async';

import 'package:fcg_app/api/helper.dart';
import 'package:fcg_app/api/timetable.dart';
import 'package:fcg_app/api/utils.dart';
import 'package:fcg_app/main.dart' as main;
import 'package:fcg_app/pages/setup/app_setup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fcg_app/device/device.dart' as device;

//Splashscreen util preparation is done
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(54, 66, 106, 1),
                  Color.fromRGBO(29, 29, 29, 1)
                ]
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 5, spreadRadius: 3)],
                    ) ,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Image.asset("assets/img/fcg_app_logo.png"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text('FCG-App', style: TextStyle(color: Colors.white, fontSize: 18),),
                  )
                ],
              )
            ),
            Container(
              child: Text('', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade300, fontSize: 16)),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Made by ${main.author}', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  Text('Powered by ${main.provider}', style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text('\nv${main.version}', style: TextStyle(color: Colors.grey, fontSize: 16))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    await Future.delayed(const Duration(seconds: 3));
  }
}
