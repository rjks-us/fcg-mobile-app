import 'package:fcg_app/app/Device.dart';
import 'package:fcg_app/fcgapp/components/default_background_design.dart';
import 'package:fcg_app/fcgapp/components/signature.dart';
import 'package:fcg_app/fcgapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NativeSplashScreen extends StatefulWidget {
  const NativeSplashScreen({Key? key}) : super(key: key);

  @override
  _NativeSplashScreenState createState() => _NativeSplashScreenState();
}

class _NativeSplashScreenState extends State<NativeSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultBackgroundDesign(
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
              margin: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Made by Robert J. Kratz', style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
