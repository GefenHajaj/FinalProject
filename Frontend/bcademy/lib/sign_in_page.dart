import 'package:flutter/material.dart';
import 'package:bcademy/tests_page.dart';
import 'package:bcademy/placeholder.dart';
import 'package:bcademy/navigator_page.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/api.dart';
import 'package:bcademy/upload_page.dart';
import 'package:bcademy/profile_page.dart';
import 'package:bcademy/search_page.dart';
import 'package:bcademy/home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage();

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var _buttonColor = Color(0xffffee58);
  var _buttonText = "סיימתי";
  var _buttonHeight = 75.0;
  var _buttonWidth = 300.0;
  var _normalButtonHeight = 75.0;
  var _normalButtonWidth = 300.0;
  var _warningButtonHeight = 100.0;
  var _warningButtonWidth = 325.0;
  var _normalButtonColor = Color(0xffffee58);
  var _normalButtonText = "סיימתי";
  var _warningButtonColor = Colors.red;
  var _warningButtonText = "אתה חייב לבחור\nלפחות נושא אחד";

  String userName = "";
  String password = "";


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}