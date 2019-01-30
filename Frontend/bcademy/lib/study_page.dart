import 'package:flutter/material.dart';
import 'package:bcademy/placeholder.dart';

class StudyPage extends StatefulWidget {
  const StudyPage();

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Study Page"),
      ),
      body: Center(
        child: placeHolder("Study Page"),
      ),
    );
  }
}