import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static const int Default = 0;
  static const int Kirei1 = 1;
  static const int Kirei2 = 2;
  static const int LightBlue = 3;
  static const int LightRed = 4;


  static String toStr(int themeId) {
    switch (themeId) {
      case Default:
        return "Default";
      case Kirei1:
        return "Kirei 1";

      case Kirei2:
        return "Kirei 2";


      case LightBlue:
        return "Light Blue";
      case LightRed:
        return "Light Red";


      default:
        return "Unknown";
    }
  }
}

final dark = ThemeData.dark();
final darkFABTheme = dark.floatingActionButtonTheme;






final themeCollection = ThemeCollection(themes: {
  //Default theme
  AppThemes.Default: ThemeData(
      primaryIconTheme: IconThemeData(color: Colors.white),
      colorScheme: ColorScheme.light(
        background: Colors.grey[100],
        primary: Colors.pink,
        secondary: Colors.deepOrangeAccent,

      ),


        buttonTheme: ButtonThemeData(
            colorScheme: ColorScheme.light(
              primary: Colors.red[900],
              background: Colors.red[600],
              secondaryVariant: Colors.pink,
              secondary: Colors.black,
            )),
      ),

  //Kirei_1 theme
  AppThemes.Kirei1: ThemeData(
      primaryIconTheme: IconThemeData(color: Colors.white),
      colorScheme: ColorScheme.light(
        background: Colors.grey[100],
        primary: Colors.red,
        secondary: Colors.blue,

      ),

        buttonTheme: ButtonThemeData(
            colorScheme: ColorScheme.light(
              primary: Colors.pink,
              background: Colors.indigo[600],
              secondaryVariant: Colors.red,
              secondary: Colors.black,
            )),
      ),

  //Kirei_2 theme
  AppThemes.Kirei2: ThemeData(
      primaryIconTheme: IconThemeData(color: Colors.white),
      colorScheme: ColorScheme.light(
        background: Colors.grey[100],
        primary: Colors.pinkAccent,
        secondary: Colors.blue,

      ),

        buttonTheme: ButtonThemeData(
            colorScheme: ColorScheme.light(
              primary: Colors.red,
              background: Colors.teal[600],
              secondaryVariant: Colors.deepOrange,
              secondary: Colors.black,
            )),
      ),


  // Light_Blue theme
  AppThemes.LightBlue: ThemeData(primarySwatch: Colors.blue,   accentColor: Colors.blue,
      buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.light(
            secondary: Colors.white,
          )),

      textTheme:TextTheme(
        bodyText1: TextStyle( color: Colors.white),
        bodyText2: TextStyle( color: Colors.white),
      )),

  // Light_Red theme
  AppThemes.LightRed: ThemeData(primarySwatch: Colors.red,   accentColor: Colors.red,
      buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.light(
            secondary: Colors.white,
          )),

      textTheme:TextTheme(
        bodyText1: TextStyle( color: Colors.white),
        bodyText2: TextStyle( color: Colors.white),
      )),


/*  AppThemes.DarkBlue: dark.copyWith(
      accentColor: Colors.blue,
      buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.light(

            secondary: Colors.white,
          )),

      textTheme:TextTheme(
        bodyText1: TextStyle( color: Colors.white),
        bodyText2: TextStyle( color: Colors.white),
      )
      ,
      floatingActionButtonTheme:
      darkFABTheme.copyWith(backgroundColor: Colors.blue)),*/



});
