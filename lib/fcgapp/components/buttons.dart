import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({Key? key, required this.title, required this.active, required this.onClickEvent}) : super(key: key);

  final bool active;
  final String title;
  final VoidCallback onClickEvent;

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          widget.onClickEvent();
        },
        child: Container(
          margin: EdgeInsets.all(10),
          height: 50,
          decoration: BoxDecoration(
            color: (widget.active) ? Color.fromRGBO(102, 72, 255, 1) : Color.fromRGBO(102, 72, 255, 0.7),
            borderRadius: BorderRadius.circular(20)
          ),
          child: Center(
            child: Text(widget.title, style: TextStyle(color: (widget.active) ? Colors.white : Colors.grey, fontFamily: 'Nunito-SemiBold', fontSize: 19),),
          ),
        ),
      )
    );
  }
}

class PrimaryButtonLoading extends StatefulWidget {
  const PrimaryButtonLoading({Key? key, required this.title, required this.active, required this.onClickEvent}) : super(key: key);

  final bool active;
  final String title;
  final VoidCallback onClickEvent;

  @override
  _PrimaryButtonLoadingState createState() => _PrimaryButtonLoadingState();
}

class _PrimaryButtonLoadingState extends State<PrimaryButtonLoading> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () {
            widget.onClickEvent();
          },
          child: Container(
            margin: EdgeInsets.all(10),
            height: 50,
            decoration: BoxDecoration(
                color: (widget.active) ? Color.fromRGBO(102, 72, 255, 1) : Color.fromRGBO(102, 72, 255, 0.7),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        )
    );
  }
}



class SecondaryButton extends StatefulWidget {
  const SecondaryButton({Key? key, required this.title, required this.onClickEvent}) : super(key: key);

  final String title;
  final VoidCallback onClickEvent;

  @override
  _SecondaryButtonState createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () => widget.onClickEvent(),
          child: Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            height: 50,
            child: Center(
              child: Text(widget.title, style: TextStyle(color: Colors.grey, fontFamily: 'Nunito-SemiBold', fontSize: 16),),
            ),
          ),
        )
    );
  }
}
