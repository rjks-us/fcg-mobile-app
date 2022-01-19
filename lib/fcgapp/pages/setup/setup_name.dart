import 'package:fcg_app/fcgapp/components/buttons.dart';
import 'package:fcg_app/fcgapp/components/default_background_design.dart';
import 'package:fcg_app/fcgapp/components/signature.dart';
import 'package:fcg_app/fcgapp/components/title_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetUsernamePage extends StatefulWidget {
  const SetUsernamePage({Key? key, required this.buttonText, required this.onFinishEvent}) : super(key: key);

  final String buttonText;
  final Function(BuildContext, String) onFinishEvent;

  @override
  _SetUsernamePageState createState() => _SetUsernamePageState();
}

class _SetUsernamePageState extends State<SetUsernamePage> {

  final TextEditingController _textEditingController = new TextEditingController();

  String _textInputErrorMessage = 'Dein name muss mindestens 2 Zeichen lang sein';
  Color _statusColor = Colors.grey;

  Future<void> _onRefresh() async {

    print('Class selection refresh pressed');

  }

  void _onFinishPress() {
    widget.onFinishEvent(context, _textEditingController.text);
  }

  void _validateTextFieldInput() {
    String _textInput = _textEditingController.text;

    if(_textInput.length > 1 && _textInput.length < 15) {
      _onFinishPress();
    } else {
     if(this.mounted) {
       setState(() {
         _textInputErrorMessage = 'Der name muss mindestens 2, und maximal 15 Zeichen lang sein';
         _statusColor = Colors.red;
       });
     }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(54, 66, 106, 1),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          controller: ScrollController(),
          child: RefreshIndicator(
            backgroundColor: Color.fromRGBO(29, 29, 29, 1),
            color: Colors.indigo,
            onRefresh: _onRefresh,
            child: DefaultBackgroundDesign(
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 20.0, top: 30.0, bottom: 5.0, right: 20.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                            child: Text('Wie dürfen wir dich nennen?', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 29),),
                          )
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
                        child: Center(
                          child: Text(_textInputErrorMessage, textAlign: TextAlign.center, style: TextStyle(color: _statusColor, fontSize: 18),),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
                        child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: TextField(
                                controller: _textEditingController,
                                autofocus: true,
                                autocorrect: false,
                                onEditingComplete: () => {

                                }, //Validate, we are not using the inbuild validator
                                cursorColor: Colors.blue,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Dein Name',
                                  fillColor: Color.fromRGBO(54, 66, 106, 1),
                                  filled: true,
                                ),
                              ),
                            )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                          width: MediaQuery.of(context).size.width,
                          child: PrimaryButton(
                            active: true,
                            title: 'Nächster Schritt',
                            onClickEvent: _validateTextFieldInput,
                          )
                      )
                    ],
                  ),
                )
            ),
          ),
        )
    );
  }
}
