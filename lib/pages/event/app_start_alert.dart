import 'package:fcg_app/pages/components/dot_type.dart';
import 'package:fcg_app/pages/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

createAppStartAlertDialog(BuildContext context, PageCollection collection) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AlertDialog(pageCollection: collection,))
  );
}

class AlertDialog extends StatefulWidget {
  const AlertDialog({Key? key, required this.pageCollection}) : super(key: key);

  final PageCollection pageCollection;

  @override
  _AlertDialogState createState() => _AlertDialogState();
}

class _AlertDialogState extends State<AlertDialog> {

  PageController pageController = new PageController();
  int currentIndex = 0;
  List<Widget> _dots = [];

  bool showCloseIcon() {
    if(widget.pageCollection.skippable) return true;

    if(currentIndex == widget.pageCollection.getAmountOfPages() - 1) return true;

    return false;
  }

  void _refreshDots() {
    _dots.clear();
    for(int i = 0; i < widget.pageCollection.getAmountOfPages(); i++) {
      _dots.add(Container(
        margin: EdgeInsets.all(5),
        child: Dot(
          color: currentIndex == i ? Colors.indigo : Colors.black38,
          radius: 10,
          type: DotType.circle,
        ),
      ));
    }
    if(this.mounted) setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _refreshDots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(54, 66, 106, 1),
                Color.fromRGBO(29, 29, 29, 1)
              ]
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(20),
                    child: GestureDetector(
                      child: Icon(Icons.close, color: showCloseIcon() ? Colors.white : Colors.transparent, size: 26,),
                      onTap: () {
                        if(showCloseIcon()) Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: PageView(
                scrollDirection: Axis.horizontal,
                controller: pageController,
                pageSnapping: true,
                children: widget.pageCollection.pages,
                onPageChanged: (page) {
                  currentIndex = page;
                  if(this.mounted) setState(() {
                    _refreshDots();
                    showCloseIcon();
                  });
                },
              )
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 30),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _dots
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PageCollection {

  late bool skippable;

  List<Widget> pages = [];

  PageCollection(bool skippable) {
    this.skippable = skippable;
  }

  addPage(Widget widget) {
    pages.add(widget);
  }

  int getAmountOfPages() {
    return pages.length;
  }
}
