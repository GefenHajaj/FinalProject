import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/test_tile.dart';
import 'package:bcademy/api.dart';
import 'dart:async';
import 'package:bcademy/create_new_test.dart';
import 'package:bcademy/navigator_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bcademy/quiz_page.dart';

class QuizInfoPage extends StatefulWidget {
  final int quizPk;

  const QuizInfoPage({@required this.quizPk}) : assert(quizPk != null);

  @override
  _QuizInfoPageState createState() => _QuizInfoPageState();
}

class _QuizInfoPageState extends State<QuizInfoPage> {
  Map quizInfo;

  Future<void> _getQuizInfo() async {
    final tempQuizInfo = await Api().getQuiz(widget.quizPk);
    setState(() {
      quizInfo = tempQuizInfo;
    });
  }

  void _goToQuizPage() {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return QuizPage(quizPk: quizInfo['pk'], subject: quizInfo['subject'],
              topThreeUsersPks: quizInfo['top_three_users'], topThreeUsersScores: quizInfo['top_three_scores'],);
          }
      ));
    });
  }

  String _getTopScoresText() {
    List topThreeNames = quizInfo['top_three_names'];
    List topThreeScores = quizInfo['top_three_scores'];
    String text = 'השחקנים הכי טובים:\n';
    for (int i = 0; i < topThreeNames.length; i++) {
      text += topThreeNames[i] + ' עם תוצאה של ' + topThreeScores[i].toString() + ' שניות\n';
    }
    if (text == 'השחקנים הכי טובים:\n') {
      text = 'עדיין לא שיחקו בשאלון הזה!\nתהיו הראשונים לשחק!';
    }
    return text;
  }

  Widget _getButton() {
    double height = 75.0;
    double width = 300.0;
    Color color = Color(0xffa7ffeb);
    String text = "התחל בשאלון!";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            height: height,
            width: width,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(50.0)
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(50.0),
              onTap: () {_goToQuizPage();},
              child: Center(
                child: Text(text,
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
    );
  }

  Widget _getPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text("${quizInfo['title']}",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("שאלון במקצוע ${quizInfo['subject']}",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24.0)),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("מספר שאלות: ${quizInfo['num_questions']}",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 24.0)),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(_getTopScoresText(),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                ),
                Container(height: 100.0,),
                _getButton()
              ]
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (quizInfo == null) {
      _getQuizInfo();
      return new Container(
        child: CircularProgressIndicator(),
      );
    }
    else {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff4dd0e1),
            elevation: 0.0,
            centerTitle: true,
            title: Text("דף שאלון", textDirection: TextDirection.rtl, style: TextStyle(color: Colors.black, fontSize: 24.0),),
          ),
          body: _getPage()
      );
    }
  }
}