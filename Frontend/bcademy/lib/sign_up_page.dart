/// Sign up page. Here, new users can create new accounts. In addition, they
/// can go back to the sign in page.
///
/// Developer: Gefen Hajaj

import 'package:flutter/material.dart';
import 'package:bcademy/api.dart';
import 'package:bcademy/home_page.dart';
import 'package:bcademy/sign_in_page.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';

/// The sign up page
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var _buttonColor = Color(0xff00e676);
  var _buttonText = "הירשם";
  var _buttonHeight = 50.0;
  var _normalButtonColor = Color(0xff00e676);
  var _normalButtonText = "הירשם";
  var _warningButtonColor = Colors.red;
  var _warningButtonText = "שם המשתמש\nכבר בשימוש!";
  var _valueNotFoundText = "אתה חייב להכניס\nשם מלא, שם משתמש וססמא!";

  String userName = "";
  String password = "";
  String name = "";

  /// Try to sign up (if the user entered all the needed info).
  void _trySignUp() {
    if (userName != "" && password != "" && name != "") {
      _signUp();
    }
    else {
      setState(() {
        _buttonText = _valueNotFoundText;
        _buttonColor = _warningButtonColor;
      });
    }
  }

  /// Sign up. if username taken - tells the user that it's taken and orders him
  /// to enter a new and a different one. In case everything's fine - go to the
  /// home page (tests page).
  Future<void> _signUp() async {
    int result = await Api().register(
        {'user_name': userName, 'password': password, 'name': name}, false);
    if (result == 1) {
      setState(() {
        Navigator.of(context).pushReplacement(MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return HomePage();
            }
        ));
      });
    }
    else {
      setState(() {
        _buttonText = _warningButtonText;
        _buttonColor = _warningButtonColor;
      });
    }
  }

  /// Go to sign in page
  void _goToSignInPage() {
    setState(() {
      Navigator.of(context).pushReplacement(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return SignInPage();
          }
      ));
    });
  }

  /// Get the entire page with all the widgets
  Widget _getPage() {
    return SingleChildScrollView(
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(135.0, 35.0, 20.0, 0.0),
                  child: Text(
                    'בואו\nנירשם',
                    style: TextStyle(fontSize: 80.0,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(120.0, 130.0, 0.0, 0.0),
                  child: Text(
                    '.',
                    style: TextStyle(
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5.0,),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 8),
              child: TextField(
                decoration: const InputDecoration(
                    labelText: 'שם מלא',
                    labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)
                  )
                ),
                textDirection: TextDirection.rtl,
                maxLength: 100,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                onChanged: (input) {
                  setState(() {
                    name = input;
                    _buttonText = _normalButtonText;
                    _buttonColor = _normalButtonColor;
                  });
                },
              ),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: TextField(
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                decoration: const InputDecoration(
                    labelText: 'שם משתמש',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)
                    )
                ),
                textDirection: TextDirection.rtl,
                maxLength: 100,
                onChanged: (input) {
                  setState(() {
                    userName = input;
                    _buttonText = _normalButtonText;
                    _buttonColor = _normalButtonColor;
                  });
                },
              ),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
              child: TextField(
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'סיסמא',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)
                    )
                ),
                textDirection: TextDirection.rtl,
                maxLength: 100,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                onChanged: (input) {
                  setState(() {
                    password = input;
                    _buttonText = _normalButtonText;
                    _buttonColor = _normalButtonColor;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20.0,),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
            child: Material(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.transparent,
                child: AnimatedContainer(
                  height: _buttonHeight,
                  duration: Duration(milliseconds: 100),
                  decoration: BoxDecoration(
                      color: _buttonColor,
                      borderRadius: BorderRadius.circular(25.0)
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25.0),
                    onTap: () {_trySignUp();},
                    child: Center(
                      child: AutoSizeText(_buttonText,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontFamily: 'Montserrat'
                        ),
                      ),
                    ),
                  ),
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {_goToSignInPage();},
              child: Container(
                width: 150.0,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent,),
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.transparent
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("כבר יש לי משתמש!",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: Colors.grey),),
                ),),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _getPage()
    );
  }
}