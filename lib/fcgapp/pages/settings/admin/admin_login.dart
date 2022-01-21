import 'package:fcg_app/fcgapp/app.dart';
import 'package:fcg_app/fcgapp/components/buttons.dart';
import 'package:fcg_app/fcgapp/components/default_background_design.dart';
import 'package:fcg_app/fcgapp/components/loading/loading_admination.dart';
import 'package:fcg_app/fcgapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {

  final TextEditingController _usernameController = new TextEditingController(), _passwordController = new TextEditingController();

  String _status = 'Bitte Logge dich mit deinen Admin Daten ein';
  Color _statusColor = Colors.grey;

  _refresh() {
    if(this.mounted) setState(() {});
  }

  Future<bool> _tryLogin() async {

    String _username = _usernameController.text.toString();

    bool successful = await device.account.loginUser(_usernameController.text.toString(), _passwordController.text.toString());

    if(!successful) {
      _statusColor = Colors.red;
      _status = 'Die angegebenen Daten sind nicht korrekt';

      _refresh();
    } else {
      Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => AppSetupLoadingAnimation(
          future: () async {
            await Future.delayed(Duration(seconds: 2));

            return true;
          },
          loadingText: 'Du wirst eingeloggt',
          errorText: 'Ein Fehler ist aufgetreten, klicke hier um es erneut zu versuchen',
          finishText: 'Hallo ${_usernameController.text.toString()}',
          onLoadFinishEvent: (loadBuildContext, success) {
            print('[SETUP] Successfully logged in as administrator');

            Navigator.pushAndRemoveUntil(loadBuildContext, CupertinoPageRoute(builder: (context) => DefaultStartApp()), (Route<dynamic> route) => false);

          }
      )), (Route<dynamic> route) => false);
    }

    return successful;
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
        child: DefaultBackgroundDesign(
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              'Einloggen',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: 'Nunito-Regular',
                                  fontSize: 29.0,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20, top: 20),
                    child: TextField(
                      controller: _usernameController,
                      autofocus: true,
                      autocorrect: false,
                      cursorColor: Colors.blue,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Nutzername',
                        fillColor: Color.fromRGBO(54, 66, 106, 1),
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _passwordController,
                      autofocus: true,
                      autocorrect: false,
                      obscureText: true,
                      enableSuggestions: false,
                      cursorColor: Colors.blue,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        fillColor: Color.fromRGBO(54, 66, 106, 1),
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: Text(
                      _status,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Nunito-Regular',
                          fontSize: 16.0,
                          color: _statusColor
                      ),
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: PrimaryButton(
                        active: true,
                        title: 'Einloggen',
                        onClickEvent: () => _tryLogin(),
                      )
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}
