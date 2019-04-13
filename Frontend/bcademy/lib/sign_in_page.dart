import 'package:flutter/material.dart';
import 'package:bcademy/api.dart';
import 'package:bcademy/home_page.dart';
import 'package:bcademy/sign_up_page.dart';
import 'dart:async';

class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var _buttonColor = Color(0xff98ee99);
  var _buttonText = "היכנס";
  var _buttonHeight = 75.0;
  var _buttonWidth = 300.0;
  var _normalButtonHeight = 75.0;
  var _normalButtonWidth = 300.0;
  var _warningButtonHeight = 100.0;
  var _warningButtonWidth = 325.0;
  var _normalButtonColor = Color(0xff98ee99);
  var _normalButtonText = "היכנס";
  var _warningButtonColor = Colors.red;
  var _warningButtonText = "שם המשתמש או הססמא\nאינם נכונים!";
  var _valueNotFoundText = "אתה חייב להכניס\nשם משתמש וססמא!";

  String userName = "";
  String password = "";

  void _trySignIn() {
    if (userName != "" && password != "") {
      _signIn();
    }
    else {
      setState(() {
        _buttonWidth = _warningButtonWidth;
        _buttonText = _valueNotFoundText;
        _buttonColor = _warningButtonColor;
        _buttonHeight = _warningButtonHeight;
      });
    }
  }

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
        _buttonWidth = _warningButtonWidth;
        _buttonText = _warningButtonText;
        _buttonColor = _warningButtonColor;
        _buttonHeight = _warningButtonHeight;
      });
    }
  }

  void _goToSignUpPage() {
    setState(() {
      Navigator.of(context).pushReplacement(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return SignUpPage();
          }
      ));
    });
  }

  Widget _getPage() {
    return SingleChildScrollView(
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(height: 75.0,),
          Center(child: Text("ברוכים הבאים!", style: TextStyle(fontSize: 44.0), textDirection: TextDirection.rtl,)),
          Container(height: 75.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("שם משתמש: ",style: TextStyle(fontSize: 24.0), textDirection: TextDirection.rtl,),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 8, 8),
                    child: TextField(
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      decoration: const InputDecoration(
                        hintText: 'השם שלי',
                      ),
                      textDirection: TextDirection.rtl,
                      maxLength: 100,
                      onChanged: (input) {
                        setState(() {
                          userName = input;
                          _buttonWidth = _normalButtonWidth;
                          _buttonText = _normalButtonText;
                          _buttonColor = _normalButtonColor;
                          _buttonHeight = _normalButtonHeight;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(height: 50.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("סיסמא: ",style: TextStyle(fontSize: 24.0), textDirection: TextDirection.rtl,),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 8, 8),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'הסיסמא הסודית שלי',
                      ),
                      textDirection: TextDirection.rtl,
                      maxLength: 100,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      onChanged: (input) {
                        setState(() {
                          password = input;
                          _buttonWidth = _normalButtonWidth;
                          _buttonText = _normalButtonText;
                          _buttonColor = _normalButtonColor;
                          _buttonHeight = _normalButtonHeight;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(height: 140.0,),
          Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.transparent,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                height: _buttonHeight,
                width: _buttonWidth,
                decoration: BoxDecoration(
                    color: _buttonColor,
                    borderRadius: BorderRadius.circular(50.0)
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50.0),
                  onTap: () {_trySignIn();},
                  child: Center(
                    child: Text(_buttonText,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.0
                      ),
                    ),
                  ),
                ),
              )
          ),
          Container(height: 20.0),
          Material(
            elevation: 17.0,
            shadowColor: Colors.blue,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {_goToSignUpPage();},
                child: Container(
                  width: 150.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent,),
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.lightBlue[600]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("אין לי משתמש!", textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,)),
                  ),),
              ),
            ),
          ),
          Container(height: 50.0,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.05, 0.3, 0.7, 0.9],
          colors: [
            Colors.lightBlue[400],
            Colors.lightBlue[500],
            Colors.lightBlue[600],
            Colors.lightBlue[700],
          ],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _getPage()
      ),
    );
  }
}