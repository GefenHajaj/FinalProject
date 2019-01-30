import 'package:flutter/material.dart';
import 'package:bcademy/placeholder.dart';

class QuizPage extends StatefulWidget {
  const QuizPage();

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Page"),
      ),
      body: Center(
        child: placeHolder("Quiz Page"),
      ),
    );
  }
}