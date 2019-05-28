/// This page allows the user to send an email to himself/a friend that contains
/// all the material for a specific test, Useful if someone want to send it to
/// another person or print it.
///
/// Developer: Gefen Hajaj

import 'package:flutter/material.dart';
import 'package:bcademy/api.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

/// Page that allows you to send an email with all the material of a specific
/// test
class SendEmailPage extends StatefulWidget {
  final String info;
  final String subjectName;

  const SendEmailPage({
    @required this.info,
    @required this.subjectName
  }): assert(info != null), assert(subjectName != null);

  @override
  _SendEmailPageState createState() => _SendEmailPageState();
}

class _SendEmailPageState extends State<SendEmailPage> {
  String _emailAddress = "";
  String _buttonText = "שלח אימייל";
  String _normalButtonText = "שלח אימייל";
  String _warningButtonText = "כתובת אימייל אינה תקינה!";
  Color _buttonColor = Colors.blue;
  Color _normalButtonColor = Colors.blue;
  Color _warningButtonColor = Colors.red;
  double _buttonHeight = 75;
  double _normalButtonHeight = 75;
  double _warningButtonHeight = 100;

  /// Checks whether a string is a valid email.
  bool _isEmail(String email) {
    String regExString = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:["
        r"a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,2"
        r"53}[a-zA-Z0-9])?)*$";
    RegExp regExp = new RegExp(regExString);
    return regExp.hasMatch(email);
  }

  /// If the email the user typed in is valid, the app sends the email.
  /// else, it prompts the user that the email is invalid.
  void _trySendEmail() async {
    if (_isEmail(_emailAddress)) {
      String subject = "חומר למבחן ב${widget.subjectName} שנשלח "
          "לך על ידי ${Data.userName} מאפליקציית BCademy";
      List<String> recipients = [_emailAddress];
      final MailOptions email = MailOptions(
        body: widget.info + "\n\nנוצר על ידי אפליקציית BCademy",
        subject: subject,
        recipients: recipients,
        isHTML: false
      );
      await FlutterMailer.send(email);
      Navigator.of(context).pop();
    }
    else {
      setState(() {
        _buttonText = _warningButtonText;
        _buttonColor = _warningButtonColor;
        _buttonHeight = _warningButtonHeight;
      });
    }
  }

  /// Get the entire page - text that tells the user to enter the email address,
  /// a text input widget and a button (send email).
  Widget _getPage() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          textDirection: TextDirection.rtl,
          children: <Widget>[
            SizedBox(height: 75,),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "שלח את חומר המבחן באימייל:",
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28.0),
              ),
            ),
            SizedBox(height: 50,),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                child: TextField(
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  decoration: const InputDecoration(
                      labelText: 'כתובת אימייל',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)
                      ),
                      border: OutlineInputBorder()
                  ),
                  textDirection: TextDirection.ltr,
                  maxLength: 100,
                  onChanged: (input) {
                    setState(() {
                      _emailAddress = input;
                      _buttonText = _normalButtonText;
                      _buttonColor = _normalButtonColor;
                      _buttonHeight = _normalButtonHeight;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 75,),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
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
                      onTap: () {_trySendEmail();},
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xff00acc1),
          centerTitle: true,
          title: Text("שליחת חומר",
            style: TextStyle(fontSize: 22.0,),),
        ),
        body: _getPage()
    );
  }
}