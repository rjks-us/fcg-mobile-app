import 'package:fcg_app/fcgapp/app.dart';
import 'package:fcg_app/fcgapp/components/buttons.dart';
import 'package:fcg_app/fcgapp/components/default_background_design.dart';
import 'package:fcg_app/fcgapp/components/loading/loading_admination.dart';
import 'package:fcg_app/fcgapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  String _username = '';

  void _refresh() {
    if(this.mounted) setState(() {});
  }

  Future<void> _loadDeviceInformation() async {

    this._username = await device.getAccount().getAdminUsername();

    _refresh();
  }

  Future<void> _logOut() async {

    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => AppSetupLoadingAnimation(
        future: () async {
          bool state = await device.getAccount().signOut();

          return state;
        },
        loadingText: 'Du wirst ausgeloggt',
        errorText: 'Ein Fehler ist aufgetreten, klicke hier um es erneut zu versuchen',
        finishText: 'Ausgeloggt!',
        onLoadFinishEvent: (loadBuildContext, success) {
          print('[SETUP] Successfully logged out as administrator');

          device.account.updateAdminSessionToken('');
          device.account.updateAdminUsername('');
          device.account.updateSessionTimeout('');
          device.account.updateAdminUserScopes([]);

          Navigator.pushAndRemoveUntil(loadBuildContext, CupertinoPageRoute(builder: (context) => DefaultStartApp()), (Route<dynamic> route) => false);

        }
    )), (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDeviceInformation();
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
                        margin: EdgeInsets.only(bottom: 20, top: 60),
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.indigo,
                            ),
                            height: 150,
                            width: 150,
                            child: Center(
                              child: Icon(Icons.shield_sharp, size: 50, color: Colors.white,),
                            ),
                          ),
                        )
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          '$_username',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Nunito-Regular',
                              fontSize: 29.0,
                              color: Colors.white
                          ),
                        ),
                      )
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20.0, top: 25, right: 20.0),
                      child: PrimaryButton(
                        active: true,
                        title: 'Ausloggen',
                        onClickEvent: () => _logOut(),
                      ),
                    )
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
}
