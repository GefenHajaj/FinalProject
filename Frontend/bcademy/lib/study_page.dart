import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bcademy/test.dart';

class StudyPage extends StatefulWidget {
  final Test test;

  const StudyPage({@required this.test});

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {

  /// Small little page (for now!)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Study Page"),
        centerTitle: true,
      ),
      body: Center(
        child: InkWell(
            child: Text(widget.test != null ? widget.test.link : "No test was chosen"),
          onTap: () => print("Someone wants to see some material..."),
        ),
      ),
    );
  }
}