import 'package:flutter/cupertino.dart';

class BlockSpacer extends StatefulWidget {
  const BlockSpacer({Key? key,required this.height}) : super(key: key);

  final double height;

  @override
  _BlockSpacerState createState() => _BlockSpacerState();
}

class _BlockSpacerState extends State<BlockSpacer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
    );
  }
}