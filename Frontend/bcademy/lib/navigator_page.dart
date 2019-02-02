import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/study_page.dart';
import 'package:bcademy/quiz_page.dart';


class NavigatorPage extends StatefulWidget {
  final Test test;

  const NavigatorPage({@required this.test}): assert(test != null);

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {

  String studyButtonText = "Time to Study!";
  Color studyButtonColor = Color(0xff00acc1);
  String quizButtonText = "Take a Quiz!";
  Color quizButtonColor = Color(0xff81c784);

  Color appBarColor = Color(0xff80d8ff);

  Widget _buildButton(Function onTapFunc, String text, Color buttonColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
      child: Material(
        color: buttonColor,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.43,
          child: InkWell(
            onTap: onTapFunc,
            child: Center(
              child: Text(text, style: TextStyle(fontSize: 60.0, fontFamily: 'PatrickHand'),),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getFullPage() {
    return Column(
      children: <Widget>[
        _buildButton(_onStudyTap, this.studyButtonText, this.studyButtonColor),
        _buildButton(_onQuizTap, this.quizButtonText, this.quizButtonColor)
      ],
    );
  }

  /// What happens when pressing on "Time to Study!" button
  void _onStudyTap() {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return StudyPage(test: widget.test);
          }
      ));
    });
  }

  /// When pressing on "Take a Quiz!" button.
  void _onQuizTap() {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return QuizPage();
          }
      ));
    });
  }

  /// Small little page (for now!)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffebee),
      appBar: AppBar(
        title: Text("מבחן ב${widget.test.subject.name}", style: TextStyle(color: Colors.black),),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body: _getFullPage()
    );
  }
}