import 'package:fcg_app/fcgapp/app.dart';
import 'package:fcg_app/fcgapp/components/loading/loading_admination.dart';
import 'package:fcg_app/fcgapp/main.dart';
import 'package:fcg_app/fcgapp/pages/setup/setup_class.dart';
import 'package:fcg_app/fcgapp/pages/setup/setup_courses.dart';
import 'package:fcg_app/fcgapp/pages/setup/setup_name.dart';
import 'package:flutter/cupertino.dart';

void openChangeClassFlow(BuildContext context) async {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => SetClassPage(onFinishEvent: (classContext, schoolClass) {

    Navigator.push(classContext, CupertinoPageRoute(builder: (context) => SetCoursesPage(selectedClass: schoolClass, onFinishEvent: (classContext, courseList) {

      Navigator.pushAndRemoveUntil(classContext, CupertinoPageRoute(builder: (context) => AppSetupLoadingAnimation(
          future: () async {

            bool success = false;

            device.updateDeviceClassName(schoolClass.shortName); ///Just the clear name for display on local device

            success = await device.updateDeviceClassId(schoolClass.id); ///Database change

            List<int> _finalCourseIdList = [];
            courseList.forEach((element) => _finalCourseIdList.add(element.id));

            success = await device.updateDeviceCourseList(_finalCourseIdList);  ///Database change

            return success;
          },
          loadingText: 'Wir ändern dein Stundenplan',
          errorText: 'Ein Fehler ist aufgetreten, klicke hier um es erneut zu versuchen',
          finishText: 'Dein Stundenplan wurde geändert',
          onLoadFinishEvent: (loadBuildContext, success) {
            print('[SETTINGS] Device class and courses were changed successfully');

            Navigator.pushAndRemoveUntil(loadBuildContext, CupertinoPageRoute(builder: (context) => DefaultStartApp()), (Route<dynamic> route) => false);
          }
      )), (Route<dynamic> route) => false);

    })));

  })));
}