import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BigLandingHeading extends StatefulWidget {
  const BigLandingHeading({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _BigLandingHeadingState createState() => _BigLandingHeadingState();
}

class _BigLandingHeadingState extends State<BigLandingHeading> {
  @override
  Widget build(BuildContext context) {
    return HeadingTemplate(title: widget.title, fontSize: 29.0);
  }
}


class MidSectionHeading extends StatefulWidget {
  const MidSectionHeading({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MidSectionHeadingState createState() => _MidSectionHeadingState();
}

class _MidSectionHeadingState extends State<MidSectionHeading> {
  @override
  Widget build(BuildContext context) {
    return HeadingTemplate(title: widget.title, fontSize: 22.0);
  }
}


class SmallTextDescription extends StatefulWidget {
  const SmallTextDescription({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  _SmallTextDescriptionState createState() => _SmallTextDescriptionState();
}

class _SmallTextDescriptionState extends State<SmallTextDescription> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20.0, bottom: 20.0),
      child: Text(widget.text, style: TextStyle(color: Colors.grey, fontSize: 16),),
    );
  }
}



class HeadingTemplate extends StatefulWidget {
  const HeadingTemplate({Key? key, required this.title, required this.fontSize}) : super(key: key);

  final String title;
  final double fontSize;

  @override
  _HeadingTemplateState createState() => _HeadingTemplateState();
}

class _HeadingTemplateState extends State<HeadingTemplate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        widget.title,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Nunito-Regular',
            fontSize: widget.fontSize,
            color: Colors.white
        ),
      ),
    );
  }
}


class SmallSubInformationTextText extends StatefulWidget {
  const SmallSubInformationTextText({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SmallSubInformationTextTextState createState() => _SmallSubInformationTextTextState();
}

class _SmallSubInformationTextTextState extends State<SmallSubInformationTextText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Text(
        widget.title,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Nunito-Regular',
            fontSize: 12.0,
            color: Colors.grey
        ),
      ),
    );
  }
}
