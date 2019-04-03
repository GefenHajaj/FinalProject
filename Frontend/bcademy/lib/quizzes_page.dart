import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/test_tile.dart';
import 'package:bcademy/api.dart';
import 'dart:async';
import 'package:bcademy/create_new_test.dart';
import 'package:bcademy/navigator_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bcademy/quiz_info_page.dart';

class QuizzesPage extends StatefulWidget {
  const QuizzesPage();

  @override
  _QuizzesPageState createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> {
  Map quizzes;
  final _rowHeight = 100.0;
  final _borderRadius = BorderRadius.circular(20.0);
  final _color = Color(0xff80deea);
  final _highlightColor = Colors.lightBlueAccent;
  final _splashColor = Colors.lightBlueAccent;

  Future<void> _getQuizzes() async {
    final tempQuizzes = await Api().getQuizzes();
    setState(() {
      quizzes = tempQuizzes;
    });
  }
  
  void _goToQuizInfoPage(int quizPk) {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return QuizInfoPage(quizPk: quizPk);
          }
      ));
    });
  }

  Widget _getPage() {
    if (quizzes.isEmpty) {
      return Center(child: Text("עדיין אין שאלונים שמתאימים לך!", style: TextStyle(fontSize: 30.0), textDirection: TextDirection.rtl,),);
    }
    else {
      final quizzesInfo = quizzes.values.toList();
      return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                color: _color,
                borderRadius: _borderRadius,
                child: InkWell(
                  borderRadius: _borderRadius,
                  onTap: () {_goToQuizInfoPage(int.parse(quizzes.keys.toList()[index]));},
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
                          child: Icon(Icons.help_outline, size: 40.0,),
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
                                  "${quizzesInfo[index][0]}",
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 22.0, fontFamily: 'Gisha'),
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
    if (quizzes == null) {
      _getQuizzes();
      return new Container(
        child: CircularProgressIndicator(),
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
              elevation: 0.0,
            )
        ),
      );
    }
  }
}