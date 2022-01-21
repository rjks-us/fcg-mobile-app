import 'package:fcg_app/app/Device.dart';
import 'package:fcg_app/app/Timetable.dart';
import 'package:fcg_app/fcgapp/app.dart';
import 'package:fcg_app/fcgapp/components/loading/loading_admination.dart';
import 'package:fcg_app/fcgapp/pages/setup/setup_class.dart';
import 'package:fcg_app/fcgapp/pages/setup/setup_courses.dart';
import 'package:fcg_app/fcgapp/pages/setup/setup_name.dart';
import 'package:fcg_app/fcgapp/pages/setup/setup_overview.dart';
import 'package:fcg_app/fcgapp/pages/setup/setup_permission.dart';
import 'package:fcg_app/fcgapp/pages/splash/splash_screen.dart';
import 'package:fcg_app/pages/splash/splashscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

Device device = new Device();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent
      )
  );

  ///await device.loadAssets();

  runApp(Main());
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  bool _isDeviceRegistered = false;

  Future<void> _initApp() async {
    await Init.instance.initialize();

    await device.loadAssets();

    _isDeviceRegistered = await device.isRegistered();

    // print('aaa');
    // print(appSetting.getHost());

    //RequestHandler.init(appSetting.getHost());
    // RequestHandler.init("http://localhost:8080");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initApp(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FCG App',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
            ),
            home: NativeSplashScreen(),
          );
        } else {
          if(_isDeviceRegistered) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'FCG App',
              theme: ThemeData(
                primarySwatch: Colors.indigo,
              ),
              home: DefaultStartApp()
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'FCG App',
              theme: ThemeData(
                primarySwatch: Colors.indigo,
              ),
              home: SetClassPage(
                  onFinishEvent: (classBuildContext, schoolClass) {
                    PreRegisteredDevice _preRegisteredDevice = new PreRegisteredDevice();

                    print('[SETUP] User selected class ${schoolClass.longName} #${schoolClass.id}');

                    _preRegisteredDevice.setClassId(schoolClass.id);
                    _preRegisteredDevice.setClassName(schoolClass.shortName);

                    Navigator.push(classBuildContext, CupertinoPageRoute(builder: (context) => SetCoursesPage(
                        selectedClass: schoolClass,
                        onFinishEvent: (courseBuildContext, courseList) {
                          List<int> _finalCourseIdList = [];
                          courseList.forEach((element) => _finalCourseIdList.add(element.id));

                          print('[SETUP] User selected following courses: $_finalCourseIdList');

                          _preRegisteredDevice.setCourseList(_finalCourseIdList);

                          Navigator.push(courseBuildContext, CupertinoPageRoute(builder: (context) => SetUsernamePage(
                            buttonText: 'Nächster Schritt',
                            onFinishEvent: (usernameBuildContext, username) {
                              print('[SETUP] Username was set to $username');

                              _preRegisteredDevice.setUsername(username);

                              Navigator.push(usernameBuildContext, CupertinoPageRoute(builder: (context) => SetPermissionPage(
                                  username: username,
                                  onFinishEvent: (permissionBuildContext, allowed) {
                                    print('[SETUP] User set notifications to: $allowed');

                                    _preRegisteredDevice.pushNotification = allowed;

                                    Navigator.push(permissionBuildContext, CupertinoPageRoute(builder: (context) => SetUpConfirmPage(
                                        username: username,
                                        className: schoolClass.shortName,
                                        preSelectedCourses: courseList,
                                        onFinishEvent: (confirmBuildContext, finalSchoolCourses) {
                                          _preRegisteredDevice.setCourseList(_finalCourseIdList);

                                          print('[SETUP] User updated to following courses: $_finalCourseIdList');

                                          Navigator.pushAndRemoveUntil(confirmBuildContext, CupertinoPageRoute(builder: (context) => AppSetupLoadingAnimation(
                                              future: () async {

                                                bool success = await _preRegisteredDevice.checkout();

                                                return success;
                                              },
                                              loadingText: 'Wir bauen deinen Stundenplan zusammen',
                                              errorText: 'Ein Fehler ist aufgetreten, klicke hier um es erneut zu versuchen',
                                              finishText: 'Fertig!',
                                              onLoadFinishEvent: (loadBuildContext, success) {
                                                print('[SETUP] Setup done, device has been successfully registered');

                                                Navigator.pushAndRemoveUntil(loadBuildContext, CupertinoPageRoute(builder: (context) => DefaultStartApp()), (Route<dynamic> route) => false);

                                              }
                                          )), (Route<dynamic> route) => false);
                                        }
                                    )));
                                  }
                              )));
                            },
                          )));
                        }
                    )));
                  }
              ),
            );
          }
        }
      },
    );
  }
}