import 'package:flutter/cupertino.dart';

class DefaultBackgroundDesign extends StatefulWidget {
  const DefaultBackgroundDesign({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _DefaultBackgroundDesignState createState() => _DefaultBackgroundDesignState();
}

class _DefaultBackgroundDesignState extends State<DefaultBackgroundDesign> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: widget.child,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.center,
          colors: [
            Color.fromRGBO(54, 66, 106, 1),
            Color.fromRGBO(29, 29, 29, 1)
          ]
        )
      )
    );
  }
}
