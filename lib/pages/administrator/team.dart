import 'package:fcg_app/admin/admin.dart' as admin;
import 'package:fcg_app/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {

  final username = TextEditingController(), password = TextEditingController();

  List<Widget> body = [];

  String a_name = '', a_email = '', statusmessage = 'Bitte Logge dich mit deinen Admin Daten ein.';
  List<int> scopes = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  loginTry() async {
    await login();
  }

  login() async {
    if(username.text.toString().length <= 3) {
      statusmessage = 'Ungültiger Nutzername';
      refresh();
      return;

    }
    if(password.text.toString().length <= 3) {
      statusmessage = 'Ungültiges Passwort';
      refresh();
      return;
    }

    print('${username.text} | ${password.text}');

    admin.Administrator administrator = await admin.loginUser(username.text.toString(), password.text.toString());

    print('bbb');

    if(!administrator.isValid()) {
      statusmessage = 'Die Nutzerdaten sind falsch!';
      refresh();
    } else {
      await loggedIn();
    }
  }

  notLoggedIn() async {
    body.clear();

    body.add(Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0),
      child: Text(
        'Einloggen',
        style: TextStyle(
            fontFamily: 'Nunito-Regular',
            fontSize: 29.0,
            color: Colors.white
        ),
      ),
    ));

    body.add(Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 20, top: 20),
          child: TextField(
            controller: username,
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
            controller: password,
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
            statusmessage,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: 16.0,
                color: Colors.grey
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            onTap: () => loginTry(),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(2)
              ),
              child: Center(
                child: Text('Weiter', style: TextStyle(color: Colors.white, fontSize: 22),),
              ),
            ),
          )
        )
      ],
    ));

    refresh();

  }

  loggedIn() async {
    body.clear();

    body.add(Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0),
      child: Text(
        'Willkommen $a_name',
        style: TextStyle(
            fontFamily: 'Nunito-Regular',
            fontSize: 29.0,
            color: Colors.white
        ),
      ),
    ));

    body.add(Column(
      children: <Widget>[
        Text(a_email),
        Container(
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
              onTap: () => loggedIn(),
              child: Container(
                margin: EdgeInsets.all(20),
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(2)
                ),
                child: Center(
                  child: Text('Ausloggen', style: TextStyle(color: Colors.white, fontSize: 22),),
                ),
              ),
            )
        )
      ],
    ));

    refresh();
  }

  refresh() {
    if(this.mounted) setState(() {

    });
  }

  load () async {
    print('a');

    if(await admin.isLoggedIn()) {
      admin.Administrator administrator = await admin.validateSession(await getString('var-admin-token'));
      print('b');

      if(!administrator.isValid()) {
        notLoggedIn();
        print('c');

      } else {
        a_name = administrator.name;
        a_email = administrator.email;
        scopes = administrator.scopes;

        print('d');


        loggedIn();
      }
    } else {
      notLoggedIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 66, 106, 1),
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(54, 66, 106, 1),
                Color.fromRGBO(29, 29, 29, 1)
              ]
          ),
        ),
        child: new SingleChildScrollView(
          controller: ScrollController(),
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: body,
            ),
          ),
        ),
      ),
    );
  }
}
