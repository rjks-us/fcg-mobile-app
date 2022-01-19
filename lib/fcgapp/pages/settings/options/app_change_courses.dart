import 'package:fcg_app/app/Timetable.dart';
import 'package:fcg_app/fcgapp/app.dart';
import 'package:fcg_app/fcgapp/components/loading/loading_admination.dart';
import 'package:fcg_app/fcgapp/main.dart';
import 'package:fcg_app/fcgapp/pages/setup/setup_courses.dart';
import 'package:fcg_app/fcgapp/pages/setup/setup_name.dart';
import 'package:flutter/cupertino.dart';

void openChangeCoursesFlow(BuildContext context) async {
  int _classId = await device.getDeviceClassId();
  String _className = await device.getDeviceClassName();

  Navigator.push(context, CupertinoPageRoute(builder: (context) => SetCoursesPage(
      selectedClass: new SchoolClass({
        'id': _classId,
        'short': _className,
        'name': '',
        'teachers': []
      }),
      onFinishEvent: (classContext, courseList) {

        Navigator.pushAndRemoveUntil(classContext, CupertinoPageRoute(builder: (context) => AppSetupLoadingAnimation(
            future: () async {

              bool success = false;

              List<int> _finalCourseIdList = [];
              courseList.forEach((element) => _finalCourseIdList.add(element.id));

              success = await device.updateDeviceCourseList(_finalCourseIdList);  ///Database change

              return success;
            },
            loadingText: 'Wir ändern deine Kurse',
            errorText: 'Ein Fehler ist aufgetreten, klicke hier um es erneut zu versuchen',
            finishText: 'Deine Kurse wurde geändert',
            onLoadFinishEvent: (loadBuildContext, success) {
              print('[SETTINGS] Device courses were changed successfully');

              Navigator.pushAndRemoveUntil(loadBuildContext, CupertinoPageRoute(builder: (context) => DefaultStartApp()), (Route<dynamic> route) => false);
            }
        )), (Route<dynamic> route) => false);

      })));
}