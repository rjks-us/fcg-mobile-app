import 'package:fcg_app/app/Storage.dart';
import 'package:fcg_app/fcgapp/components/buttons.dart';
import 'package:fcg_app/fcgapp/components/loading/loading_admination.dart';
import 'package:fcg_app/fcgapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppResetSettingsPage extends StatefulWidget {
  const AppResetSettingsPage({Key? key}) : super(key: key);

  @override
  _AppResetSettingsPage createState() => _AppResetSettingsPage();
}

class _AppResetSettingsPage extends State<AppResetSettingsPage> {

  Future<void> _deleteCurrentDevice() async {

    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => AppSetupLoadingAnimation(
        future: () async {
          bool success = await device.deleteDevice();

          print('[DEVICE] The current device has been successfully deleted.');

          return success;
        },
        loadingText: 'Daten werden gelöscht...',
        errorText: 'Ein Fehler ist aufgetreten, klicke hier um es erneut zu versuchen',
        finishText: 'Deine Daten wurden zurückgesetzt',
        onLoadFinishEvent: (loadBuildContext, success) {
          print('[DEVICE] Device has been successfully deleted');

          Navigator.pushAndRemoveUntil(loadBuildContext, CupertinoPageRoute(builder: (context) => Main()), (Route<dynamic> route) => false);

        }
    )), (Route<dynamic> route) => false);
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
              begin: Alignment.topCenter,
              end: Alignment.center,
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
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('Bist du dir sicher, dass du diese App zurücksetzen willst?', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 25.0, fontWeight: FontWeight.bold),),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: Text('Dadurch werden alle geispeicherteten Daten von dir unwiederruflich gelöscht, und können nich wiederhergestellt werden.', style: TextStyle(color: Colors.grey, fontSize: 16),),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: PrimaryButton(
                    active: true,
                    title: 'Alle Daten Löschen',
                    onClickEvent: () => _deleteCurrentDevice(),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}