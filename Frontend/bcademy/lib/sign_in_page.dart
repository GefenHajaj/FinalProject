/// This page is the sign in page. If the information the user enters is
/// invalid, the app prompts the user that he needs to re-enter the info.
/// In addition, new users can go to the registration page in case they don't
/// have a user.
/// This is the first screen the user sees when opening the app.
///
/// Developer: Gefen Hajaj

import 'package:flutter/material.dart';
import 'package:bcademy/api.dart';
import 'package:bcademy/home_page.dart';
import 'package:bcademy/sign_up_page.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';

/// Here, the user signs in to the app.
class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var _buttonColor = Color(0xff00e676);
  var _buttonText = "היכנס";
  var _buttonHeight = 50.0;
  var _normalButtonColor = Color(0xff00e676);
  var _normalButtonText = "היכנס";
  var _warningButtonColor = Colors.red;
  var _warningButtonText = "שם המשתמש או הססמא\nאינם נכונים!";
  var _valueNotFoundText = "אתה חייב להכניס\nשם משתמש וססמא!";

  String userName = "";
  String password = "";

  /// checks whether we can sign in
  void _trySignIn() {
    if (userName != "" && password != "") {
      _signIn();
    }
    else {
      setState(() {
        _buttonText = _valueNotFoundText;
        _buttonColor = _warningButtonColor;
      });
    }
  }

  /// Try to sign in. if the sign in process went successfully, the app
  /// moves to the home page (tests page). Else, tells the user that something
  /// went wrong (password or username incorrect).
  Future<void> _signIn() async {
    int result = await Api().register(
        {'user_name': userName, 'password': password}, true);
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

  /// Go to sign up page (for new users)
  void _goToSignUpPage() {
    setState(() {
      Navigator.of(context).pushReplacement(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return SignUpPage();
          }
      ));
    });
  }

  /// Get the entire page with all the widgets
  Widget _getPage() {
    return SingleChildScrollView(
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 50.0, 20.0, 0.0),
                  child: Text(
                    'ברוכים הבאים',
                    style: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(115.0, 145.0, 0.0, 0.0),
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
          SizedBox(height: 30.0,),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
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
              padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
              child: TextField(
                obscureText: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
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
          SizedBox(height: 50.0,),
          Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 8.0, 40.0, 8.0),
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
                    onTap: () {_trySignIn();},
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
              onTap: () {_goToSignUpPage();},
              child: Container(
                width: 150.0,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent,),
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.transparent
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("אין לי משתמש!",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: Colors.grey
                      )),
                ),),
            ),
          ),
          Container(height: 10.0,)
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