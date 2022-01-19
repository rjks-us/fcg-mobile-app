import 'dart:io';

import 'package:fcg_app/app/Storage.dart';
import 'package:fcg_app/app/Timetable.dart';
import 'package:fcg_app/fcgapp/app.dart';
import 'package:fcg_app/fcgapp/components/block_spacer.dart';
import 'package:fcg_app/fcgapp/components/default_background_design.dart';
import 'package:fcg_app/fcgapp/components/loading/loading_admination.dart';
import 'package:fcg_app/fcgapp/components/settings_option.dart';
import 'package:fcg_app/fcgapp/components/signature.dart';
import 'package:fcg_app/fcgapp/components/subtitle_of_element.dart';
import 'package:fcg_app/fcgapp/main.dart';
import 'package:fcg_app/fcgapp/pages/settings/options/app_aboutpage.dart';
import 'package:fcg_app/fcgapp/pages/settings/options/app_change_class.dart';
import 'package:fcg_app/fcgapp/pages/settings/options/app_change_courses.dart';
import 'package:fcg_app/fcgapp/pages/settings/options/app_change_name.dart';
import 'package:fcg_app/fcgapp/pages/settings/options/app_notificaions.dart';
import 'package:fcg_app/fcgapp/pages/settings/options/app_reset.dart';
import 'package:fcg_app/fcgapp/pages/settings/options/app_studienzeit.dart';
import 'package:fcg_app/fcgapp/pages/setup/setup_class.dart';
import 'package:fcg_app/fcgapp/pages/setup/setup_courses.dart';
import 'package:fcg_app/fcgapp/pages/setup/setup_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MainSettingContentPage extends StatefulWidget {
  const MainSettingContentPage({Key? key}) : super(key: key);

  @override
  _MainSettingContentPageState createState() => _MainSettingContentPageState();
}

class _MainSettingContentPageState extends State<MainSettingContentPage> {

  String _fullSubscribedClassName = '';
  String _username = '';

  void _refresh() {
    if(this.mounted) setState(() {});
  }

  Future<void> loadDeviceInformation() async {
    _username = await device.getDeviceUsername();
    _fullSubscribedClassName = await device.getDeviceClassName();
    _refresh();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadDeviceInformation();
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Die Website konnte nicht geöffnet werden"),
      ));
    }
  }

  String getPlatform() {
    if (kIsWeb) {
      return "web";
    } else {
      if(Platform.isAndroid) return "android";
      if(Platform.isFuchsia) return "fuchsia";
      if(Platform.isIOS) return "ios";
      if(Platform.isLinux) return "linux";
      if(Platform.isMacOS) return "macos";
      if(Platform.isWindows) return "windows";
    }
    return "-";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       extendBodyBehindAppBar: false,
        body: SingleChildScrollView(
          controller: ScrollController(),
          child: DefaultBackgroundDesign(
              child: SingleChildScrollView(
                controller: ScrollController(),
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
                              child: Text('$_fullSubscribedClassName', style: TextStyle(color: Colors.white, fontSize: 40),),
                            ),
                          ),
                        )
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 20.0, bottom: 5.0, right: 20.0),
                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Text('$_username', style: TextStyle(color: Colors.white, fontSize: 30),),
                              ),
                              IconButton(
                                  onPressed: () => openChangeNameFlow(context),
                                  icon: Icon(Icons.edit, color: Colors.white, size: 20,)
                              )
                            ],
                          )
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
                      child: Center(
                        child: Text('FCG-Schüler', style: TextStyle(color: Colors.grey, fontSize: 20),),
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SettingsOption(
                              title: 'Klasse/Stufe wechseln',
                              color: Colors.indigoAccent,
                              icon: Icons.school,
                              onClickEvent: () => openChangeClassFlow(context)
                          ),
                          SettingsOption(
                              title: 'Kurse wechseln', 
                              color: Colors.indigoAccent,
                              icon: Icons.list_alt_rounded, 
                              onClickEvent: () => openChangeCoursesFlow(context)
                          ),
                          SettingsOption(title: 'Studienzeit Woche', color: Colors.green, icon: Icons.swap_horiz, onClickEvent: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => StudienzeitSettingsPage())
                            );
                          }),
                          SettingsOption(title: 'Benachrichtigungen', color: Colors.green, icon: Icons.notifications_active_outlined, onClickEvent: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => NotificationSettingsPage())
                            );
                          }),
                          SettingsOption(
                              title: 'FCG-Website',
                              color: Colors.indigoAccent,
                              icon: Icons.web,
                              onClickEvent: () => launchURL("https://fcg-duesseldorf.de/")
                          ),
                          Line(title: 'Support', blurred: false),
                          SettingsOption(
                              title: 'Kontaktiere uns',
                              color: Colors.orange,
                              icon: Icons.contact_support,
                              onClickEvent: () => launchURL("https://fcg-app.de/support")
                          ),
                          SettingsOption(
                              title: 'Fehler melden',
                              color: Colors.orange,
                              icon: Icons.bug_report,
                              onClickEvent: () => launchURL("https://fcg-app.de/support")
                          ),
                          Line(title: 'Allgemein', blurred: false),
                          SettingsOption(
                              title: 'Bewerte diese App',
                              color: Colors.green,
                              icon: Icons.star_rate_sharp,
                              onClickEvent: () => launchURL("https://fcg-app.de/rate?platform=" + getPlatform())
                          ),
                          SettingsOption(
                              title: 'Über diese App',
                              color: Colors.indigo,
                              icon: Icons.location_history,
                              onClickEvent: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(builder: (context) => SettingsAboutPage())
                                );
                              }
                          ),
                          SettingsOption(
                              title: 'Entwickler',
                              color: Colors.indigo,
                              icon: Icons.link,
                              onClickEvent: () => launchURL("https://robertkratz.dev?redirect=fcg-app")
                          ),
                          Line(title: 'System Einstellungen', blurred: false),
                          SettingsOption(title: 'Anmelden', color: Colors.redAccent, icon: Icons.vpn_key, onClickEvent: () {

                          }),
                          SettingsOption(title: 'App reset', color: Colors.redAccent, icon: Icons.delete, onClickEvent: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => AppResetSettingsPage())
                            );
                          }),
                        ],
                      ),
                    ),
                    FullSignatureComponent(appInfo: device.appInfo), ///TODO: IMPORTANT, GET OBJECT FROM WHEN ITS CREATED FROM main.dart
                    BlockSpacer(height: 100)
                  ],
                ),
              )
          ),
        )
    );
  }
}