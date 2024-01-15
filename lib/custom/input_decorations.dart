import 'package:flutter/material.dart';
import 'package:kirei/my_theme.dart';

class InputDecorations {
  static InputDecoration buildInputDecoration_1({hint_text = ""}) {
    return InputDecoration(
        hintText: hint_text,
        hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.textfield_grey),


        contentPadding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 18));
  }

  static InputDecoration buildInputDecoration_phone({hint_text = ""}) {
    return InputDecoration(
        hintText: hint_text,
        hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.textfield_grey),


        contentPadding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 18));
  }
}
