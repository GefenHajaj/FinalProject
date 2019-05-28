/// This page shows the user a list of all the quizzes he didn't yet answer.
/// Let's him choose one and answer it.
///
/// Developer: Gefen Hajaj

import 'package:flutter/material.dart';
import 'package:bcademy/api.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bcademy/quiz_info_page.dart';

/// Shows a list of all playable quizzes
class QuizzesPage extends StatefulWidget {
  const QuizzesPage();

  @override
  _QuizzesPageState createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> {
  Map _quizzes;
  final _rowHeight = 90.0;
  final _borderRadius = BorderRadius.circular(10.0);
  final _color = Color(0xff80deea);
  final _highlightColor = Colors.lightBlueAccent;
  final _splashColor = Colors.lightBlueAccent;

  /// Get info about all quizzes
  Future<void> _getQuizzes() async {
    final tempQuizzes = await Api().getQuizzes();
    setState(() {
      _quizzes = tempQuizzes;
    });
  }

  /// When pressing on quiz - go to quiz page.
  void _goToQuizInfoPage(int quizPk) {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return QuizInfoPage(quizPk: quizPk);
          }
      ));
    });
  }

  /// Get the entire page - a list of quizzes
  Widget _getPage() {
    if (_quizzes.isEmpty) {
      return Center(
        child: Text(
          "אנחנו עובדים על עוד שאלונים...\nחכו עוד קצת!",
          style: TextStyle(fontSize: 25.0),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        ),);
    }
    else {
      final quizzesInfo = _quizzes.values.toList();
      return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                elevation: 3.0,
                color: _color,
                borderRadius: _borderRadius,
                child: InkWell(
                  borderRadius: _borderRadius,
                  onTap: () {_goToQuizInfoPage(int.parse(
                      _quizzes.keys.toList()[index]));},
                  highlightColor: _highlightColor,
                  splashColor: _splashColor,
                  child: Container(
                    height: _rowHeight,
                    child: Row(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Icon(Data.getIcon(
                              quizzesInfo[index][1]), size: 40.0,),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              height: _rowHeight / 2.5,
                              width: MediaQuery.of(context).size.width/1.3,
                              child: Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: AutoSizeText(
                                  "${quizzesInfo[index][0]}", // name of quiz
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontFamily: 'Gisha',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Text(
                              "מקצוע: ${quizzesInfo[index][1]}",
                              style: TextStyle(fontSize: 16.0),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: quizzesInfo.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_quizzes == null) {
      _getQuizzes();
      return Scaffold(
        body: Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: AppBar(
              title: Text("שאלונים תחרותיים"),
              centerTitle: true,
              backgroundColor: Color(0xff29b6f6),
              elevation: 5.0,
            )
        ),
      );
    }
    else {
      return Scaffold(
        body: _getPage(),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: AppBar(
              title: Text("שאלונים תחרותיים"),
              centerTitle: true,
              backgroundColor: Color(0xff29b6f6),
              elevation: 5.0,
            )
        ),
      );
    }
  }
}