import 'package:flutter/material.dart';

bool darkMode = false;

Color primaryBackground = darkMode ? darkPrimaryBackground : lightPrimaryBackground;
Color secondaryBackground = darkMode ? darkSecondaryBackground : lightSecondaryBackground;

Color primaryText = darkMode ? darkPrimaryText : lightPrimaryText;
Color secondaryText = darkMode ? darkSecondaryText : lightSecondaryText;

Color primaryIcon = darkMode ? darkPrimaryIcon : lightPrimaryIcon;
Color secondaryIcon = darkMode ? darkSecondaryIcon : lightSecondaryIcon;

Color actionOrange = darkMode ? darkActionOrange : lightActionOrange;
Color actionDarkBlue = darkMode ? darkActionDarkBlue : lightActionDarkBlue;

///Dark Theme

Color darkPrimaryBackground = Color.fromRGBO(54, 66, 106, 1);
Color darkSecondaryBackground = Color.fromRGBO(29, 29, 29, 1);

Color darkPrimaryText = Colors.white;
Color darkSecondaryText = Colors.grey;

Color darkPrimaryIcon = Colors.white;
Color darkSecondaryIcon = Colors.grey;

Color darkDefaultPrimaryPreBox = Colors.black;
Color darkDefaultSecondaryPreBox = Colors.black;

Color darkDefaultPrimaryBox = Colors.black;
Color darkDefaultSecondaryBox = Colors.black;

Color darkArticleText = Colors.white;
Color darkArticleLight = Color.fromRGBO(255, 255, 255, 0.53);
Color darkArticleDark = Color.fromRGBO(22, 22, 22, 1);
Color darkArticleDarkDark = Colors.black12;
Color darkArticleDarkGrey = Color.fromRGBO(29, 29, 29, 1);
Color darkArticleDarkBackground = Color.fromRGBO(255, 255, 255, 0.13);

Color darkActionPrimaryBox = Colors.black;
Color darkActionSecondaryBox = Colors.black;

Color darkActionDarkBlue = Colors.indigo;
Color darkActionLightBlueBlue = Colors.blue;
Color darkActionLimeGreen = Colors.indigo;
Color darkActionRed = Colors.red;
Color darkActionOrange = Colors.orange;

///Light Theme

Color lightPrimaryBackground = Color.fromRGBO(54, 66, 106, 1);
Color lightSecondaryBackground = Color.fromRGBO(29, 29, 29, 1);

Color lightPrimaryText = Colors.white;
Color lightSecondaryText = Colors.grey;

Color lightPrimaryIcon = Colors.white;
Color lightSecondaryIcon = Colors.grey;

Color lightDefaultPrimaryPreBox = Colors.black;
Color lightDefaultSecondaryPreBox = Colors.black;
Color lightDefaultPrimaryBox = Colors.black;
Color lightDefaultSecondaryBox = Colors.black;
Color lightActionPrimaryBox = Colors.black;
Color lightActionSecondaryBox = Colors.black;

Color lightActionDarkBlue = Colors.indigo;
Color lightActionLightBlueBlue = Colors.blue;
Color lightActionLimeGreen = Colors.indigo;
Color lightActionRed = Colors.red;
Color lightActionOrange = Colors.orange;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.lightBlue[800],

  fontFamily: 'Nunito-SemiBold',

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  ),
);

ThemeData darkTheme = ThemeData(
  // Define the default brightness and colors.
  brightness: Brightness.light,
  primaryColor: Colors.lightBlue[800],
  // Define the default font family.
  fontFamily: 'Georgia',

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  ),
);