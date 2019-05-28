/// This is a page that allows you to go study for a test or answer a quiz.
/// It also tells you the approximate time that you studied for a test.
///
/// Developer: Gefen Hajaj

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/study_page.dart';
import 'package:bcademy/quiz_page.dart';
import 'package:bcademy/api.dart';

/// The navigation page - go study or take a quiz
class NavigatorPage extends StatefulWidget {
  final Test test;

  const NavigatorPage({@required this.test}): assert(test != null);

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {

  String studyButtonText = "זמן ללמוד!";
  Color studyButtonColor = Color(0xff00e5ff);
  String quizButtonText = "שאלון!";
  Color quizButtonColor = Color(0xff00e676);

  Color appBarColor = Color(0xff80d8ff);

  /// Build a button that does something
  Widget _buildButton(Function onTapFunc, String text, Color buttonColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        color: buttonColor,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.36,
          child: InkWell(
            onTap: onTapFunc,
            child: Center(
              child: Text(text, textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 60.0,
                    fontFamily: 'VarelaRound'),),
            ),
          ),
        ),
      ),
    );
  }

  /// Get the full page - the main screen we see
  Widget _getFullPage() {
    return Column(
      children: <Widget>[
        SizedBox(height: 15,),
        Text(widget.test.millisecondsStudy != 0
            ? "זמן נלמד: ${(widget.test.millisecondsStudy/(1000.0 * 60)).
        toStringAsFixed(0)} דקות" :
        "עדיין לא למדת למבחן זה!",
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        _buildButton(_onStudyTap, this.studyButtonText, this.studyButtonColor),
        _buildButton(_onQuizTap, this.quizButtonText, this.quizButtonColor)
      ],
    );
  }

  /// Move to the study page
  void _onStudyTap() {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return StudyPage(test: widget.test);
          }
      ));
    });
  }

  /// Go and take a quiz
  void _onQuizTap() {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return QuizPage(test: widget.test,);
          }
      ));
    });
  }

  /// When pressing on the delete sign - delete a test
  void _deleteTest() {
    Api().deleteTest(widget.test.pk);
    Navigator.of(context).pushNamedAndRemoveUntil('/tests',
            (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffebee),
      appBar: AppBar(
        title: Text("מבחן ב${widget.test.subject.name}",
          style: TextStyle(color: Colors.black),),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: appBarColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete, color: Colors.black, size: 30,),
            onPressed: () {
              _deleteTest();
            },
          ),
        ],
      ),
      body: _getFullPage()
    );
  }
}