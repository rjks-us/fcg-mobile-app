import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleContentCard extends StatefulWidget {
  const TitleContentCard({Key? key, required this.title, required this.icon, required this.color}) : super(key: key);

  final String title;
  final IconData icon;
  final Color color;

  @override
  _TitleContentCardState createState() => _TitleContentCardState();
}

class _TitleContentCardState extends State<TitleContentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100.0,
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: Color.fromRGBO(255, 255, 255, 0.13),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
              color: widget.color,
            ),
            child: Center(
              child: Icon(widget.icon, size: 30, color: Colors.white,),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 20.0, left: 20.0),
            child: Text(
              widget.title,
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 18.0,
                  fontFamily: 'Nunito-SemiBold',
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
