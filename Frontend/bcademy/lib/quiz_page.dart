import 'package:flutter/material.dart';
import 'package:bcademy/placeholder.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/api.dart';
import 'package:auto_size_text/auto_size_text.dart';

class QuizPage extends StatefulWidget {
  final Test test;

  const QuizPage({@required this.test}): assert(test != null);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List _questions; // [[question, [1, answer1], [2, answer2], [3, answer3], [4, answer4]], [question...]]
  int _questionIndex = 0;
  List<int> _pressedWrong= [];
  int _guessesNum = 0;
  int _correctNum = 0;
  bool _wrong = false;

  Future<void> _getAllQuestions() async {
    final allQuestions = await Api().getTestAllQuestions(widget.test.pk);
    setState(() {
      _questions = allQuestions;
    });
  }

  Widget _getQuestionBox(String text) {
    return Align(
      alignment: Alignment(0, -0.85),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 200.0,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Color(0xffb2ebf2),
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: Colors.black, width: 1.5)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: AutoSizeText(
                text,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 32.0),
                maxLines: 6,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getAnswerBox(int order, List answerData) {
    final int answerNum = answerData[0];
    String answerText = answerData[1];
    Color color;
    Alignment align;
    if (_pressedWrong.contains(answerNum)) {
      color = Colors.red;
      answerText = "לא התשובה הזאת...";
    }

    else {
      switch (order) {
        case 1:
          {
            color = Colors.purple;
          }
          break;
        case 2:
          {
            color = Colors.green;
          }
          break;
        case 3:
          {
            color = Colors.yellow;
          }
          break;
        case 4:
          {
            color = Colors.pinkAccent;
          }
          break;
      }
    }

    switch (order) {
      case 1:
        {
          align = Alignment(-0.8, 0.2);
        }
        break;
      case 2:
        {
          align = Alignment(-0.8, 0.75);
        }
        break;
      case 3:
        {
          align = Alignment(0.8, 0.2);
        }
        break;
      case 4:
        {
          align = Alignment(0.8, 0.75);
        }
        break;
    }

    return Align(
      alignment: align,
      child: Container(
        height: MediaQuery.of(context).size.width * 0.33,
        width: MediaQuery.of(context).size.width * 0.42,
        color: color,
        child: InkWell(
          onTap: () {_tryToAnswer(answerNum);},
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: AutoSizeText(
                answerText,
                style: TextStyle(fontSize: 28.0),
                maxLines: 4,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _tryToAnswer(int questionNum) {
    if (questionNum == 1) {
      setState(() {
        if (!_wrong) {
          _correctNum++;
        }
        _questionIndex++;
        _pressedWrong = [];
        _wrong = false;
      });
    }
    else {
      setState(() {
        _guessesNum++;
        if (!_pressedWrong.contains(questionNum)) {
          _pressedWrong.add(questionNum);
        }
        if (!_wrong) {
          _wrong = true;
        }
      });
    }
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  Widget _playQuiz() {
    if (_questions.isEmpty) {
      return Container(
        child: Center(
          child: Text("עדיין לא כתבנו שאלות לנושאי המבחן שלך.\nחזור בקרוב ונסה שוב!",
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 32),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    else if (_questionIndex == _questions.length) {
        return Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  Container(height: 40,),
                  Text("סיימנו!\nכל הכבוד!",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 48),
                  textAlign: TextAlign.center,
                  ),
                  Container(height: 150, child: Center(child: Text('🎉', style: TextStyle(fontSize: 100),),),),
                  Text("תשובות נכונות בניסיון ראשון: $_correctNum/${_questions.length}",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  Text("מספר ניחושים שגויים: $_guessesNum",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                  Container(height: 85,),
                  Align(
                    alignment: Alignment(0, 0.85),
                    child: Material(
                        elevation: 10.0,
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.transparent,
                        child: Container(
                          height: 75.0,
                          width: 300.0,
                          decoration: BoxDecoration(
                              color: Color(0xff18ffff),
                              borderRadius: BorderRadius.circular(50.0)
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50.0),
                            onTap: _goBack,
                            child: Center(
                              child: Text("חזור",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 28.0
                                ),
                              ),
                            ),
                          ),
                        )
                    ),
                  ),
                ]
              ),
            ),
          ),
        );
    }
    else {
      final question = _questions[_questionIndex];
      final text = question[0];
      List answers = question.sublist(1);
      if (_pressedWrong.isEmpty) {
        answers.shuffle();
        _questions[_questionIndex] = [text, answers[0], answers[1], answers[2], answers[3]];
      }
      return Stack(
        children: <Widget>[
          _getQuestionBox(text),
          _getAnswerBox(1, answers[0]),
          _getAnswerBox(2, answers[1]),
          _getAnswerBox(3, answers[2]),
          _getAnswerBox(4, answers[3])
        ],
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_questions == null) {
      _getAllQuestions();
      return new Container(
        child: CircularProgressIndicator(),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
          title: Text("שאלון למבחן ב${widget.test.subject.name}", style: TextStyle(color: Colors.black),),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Color(0xffb2ebf2),
        ),
        body: _playQuiz()
      );
    }
  }
}