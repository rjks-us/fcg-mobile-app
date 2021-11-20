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

  load() async {
    await main.initApp();

    if(main.splashScreen) {
      next();
    } else {
      Timer(Duration(seconds: 2), () {
        next();
      });
    }
  }

  next() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder:
          (context) => main.setUp ? main.Home() : SelectClass(userNav: true,)),
          (Route<dynamic> route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    load();
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Image.asset("assets/img/fcg_logo_gym.png"),
            ),
            Container(
              child: Text('„Seid gütig zueinander, seid barmherzig“ \n~ Epheser 4:32', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade300, fontSize: 16)),
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
