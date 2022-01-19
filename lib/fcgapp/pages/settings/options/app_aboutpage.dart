import 'package:fcg_app/fcgapp/components/block_spacer.dart';
import 'package:fcg_app/fcgapp/components/subtitle_of_element.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsAboutPage extends StatefulWidget {
  const SettingsAboutPage({Key? key}) : super(key: key);

  @override
  _SettingsAboutPageState createState() => _SettingsAboutPageState();
}

class _SettingsAboutPageState extends State<SettingsAboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 66, 106, 1),
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Color.fromRGBO(54, 66, 106, 1),
                Color.fromRGBO(29, 29, 29, 1)
              ]
          ),
        ),
        child: new SingleChildScrollView(
          controller: ScrollController(),
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 40.0, bottom: 20.0),
                  child: Text(
                    'Vielen Dank an alle Mitwirkenden',
                    style: TextStyle(
                        fontFamily: 'Nunito-Regular',
                        fontSize: 29.0,
                        color: Colors.white
                    ),
                  ),
                ),
                Line(title: 'Entwicklung', blurred: false),
                SettingsAboutPersonElement(name: 'Robert J. Kratz', role: 'Front- und Backend'),
                Line(title: 'IOS Beta Tester', blurred: false),
                SettingsAboutPersonElement(name: 'Jan Kratz', role: 'IOS Beta Tester'),
                SettingsAboutPersonElement(name: 'Henrik Lankisch', role: 'IOS Beta Tester'),
                SettingsAboutPersonElement(name: 'Franziska Ruhl', role: 'IOS Beta Tester'),
                SettingsAboutPersonElement(name: 'Fabian Platow', role: 'IOS Beta Tester'),
                SettingsAboutPersonElement(name: 'Isabella Lehne', role: 'IOS Beta Tester'),
                SettingsAboutPersonElement(name: 'Sophia Stulle', role: 'IOS Beta Tester'),
                SettingsAboutPersonElement(name: 'Linus Wilde', role: 'IOS Beta Tester'),
                SettingsAboutPersonElement(name: 'Marco Kuhn', role: 'IOS Beta Tester'),
                Line(title: 'Android Beta Tester', blurred: false),
                SettingsAboutPersonElement(name: 'Philip Grüll', role: 'Android Beta Tester'),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0, top: 20.0),
                  child: Column(
                    children: <Widget>[
                      Text('Powered by rjks.us', style: TextStyle(color: Colors.white, fontSize: 18)),
                      Text('v1.0.0', style: TextStyle(color: Colors.grey, fontSize: 16))
                    ],
                  ),
                ),
                BlockSpacer(height: 200)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsAboutPersonElement extends StatefulWidget {
  const SettingsAboutPersonElement({Key? key, required this.name, required this.role}) : super(key: key);

  final String name, role;

  @override
  _SettingsAboutPersonElementState createState() => _SettingsAboutPersonElementState();
}

class _SettingsAboutPersonElementState extends State<SettingsAboutPersonElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  child: Text(widget.name, style: TextStyle(color: Colors.grey),)
              ),
              Container(
                  child: Text(widget.role, style: TextStyle(color: Colors.grey),)
              )
            ],
          ),
        )
    );
  }
}