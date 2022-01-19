import 'package:fcg_app/fcgapp/app.dart';
import 'package:fcg_app/fcgapp/components/loading/loading_admination.dart';
import 'package:fcg_app/fcgapp/main.dart';
import 'package:fcg_app/fcgapp/pages/setup/setup_name.dart';
import 'package:flutter/cupertino.dart';

void openChangeNameFlow(BuildContext context) async {

  Navigator.push(context, CupertinoPageRoute(builder: (context) => SetUsernamePage(buttonText: 'Namen Ändern', onFinishEvent: (usernameContext, name) {

    Navigator.pushAndRemoveUntil(usernameContext, CupertinoPageRoute(builder: (context) => AppSetupLoadingAnimation(
        future: () async {

          bool success = await device.updateDeviceUsername(name);

          return success;
        },
        loadingText: 'Dein Name wird geändert',
        errorText: 'Ein Fehler ist aufgetreten, klicke hier um es erneut zu versuchen',
        finishText: 'Hallo $name',
        onLoadFinishEvent: (loadBuildContext, success) {
          print('[SETTINGS] Device username was changed to $name');

          Navigator.pushAndRemoveUntil(loadBuildContext, CupertinoPageRoute(builder: (context) => DefaultStartApp()), (Route<dynamic> route) => false);

        }
    )), (Route<dynamic> route) => false);

  })));
}