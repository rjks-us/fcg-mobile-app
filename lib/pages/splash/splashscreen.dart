import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Splashscreen util preparation is done
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required this.version, required this.author}) : super(key: key);

  final String version, author;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
                  Text('Made by ${widget.author}', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  Text('Powered by rjks.us', style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text('\nv${widget.version}', style: TextStyle(color: Colors.grey, fontSize: 16))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
