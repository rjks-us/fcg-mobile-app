import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsOption extends StatefulWidget {
  const SettingsOption({Key? key, required this.title, required this.color, required this.onClickEvent, required this.icon}) : super(key: key);

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onClickEvent;

  @override
  _SettingsOptionState createState() => _SettingsOptionState();
}

class _SettingsOptionState extends State<SettingsOption> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => widget.onClickEvent(),
        child: Container(
          margin: EdgeInsets.only(left: 20, bottom: 20, right: 20),
          width: MediaQuery.of(context).size.width,
          height: 80.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13.0),
            color: Color.fromRGBO(255, 255, 255, 0.13),
            boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 5), blurRadius: 5, spreadRadius: 3)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 80,
                    child: Icon(widget.icon, color: Colors.grey),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                    ),
                    child: Center(
                      child: Text(
                        widget.title,
                        style: TextStyle(fontSize: 18.0, fontFamily: 'Nunito-SemiBold', color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 20,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                    color: widget.color
                ),
                child: Container(
                  child: Icon(Icons.arrow_right, color: Colors.white, size: 20,),
                ),
              ),
            ],
          ),
        )
    );
  }
}