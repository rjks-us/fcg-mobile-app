import 'package:fcg_app/app/Device.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullSignatureComponent extends StatefulWidget {
  const FullSignatureComponent({Key? key, required this.appInfo}) : super(key: key);

  final AppInfo appInfo;

  @override
  _FullSignatureComponentState createState() => _FullSignatureComponentState();
}

class _FullSignatureComponentState extends State<FullSignatureComponent> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Made by ${widget.appInfo.getAppAuthor()}', style: TextStyle(color: Colors.grey, fontSize: 16)),
          Text('Powered by ${widget.appInfo.getProvider()}', style: TextStyle(color: Colors.white, fontSize: 18)),
          Text('\nv${widget.appInfo.getAppVersion()}', style: TextStyle(color: Colors.grey, fontSize: 16))
        ],
      ),
    );
  }
}

class FCGAppLogo extends StatefulWidget {
  const FCGAppLogo({Key? key}) : super(key: key);

  @override
  _FCGAppLogoState createState() => _FCGAppLogoState();
}

class _FCGAppLogoState extends State<FCGAppLogo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 5, spreadRadius: 3)],
      ) ,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: Image.asset("assets/img/fcg_app_logo.png"),
      ),
    );
  }
}
