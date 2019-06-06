/// This page shows the small topics in a test
///
/// Developer: Gefen Hajaj

import 'package:flutter/material.dart';
import 'package:bcademy/api.dart';
import 'package:bcademy/study_page.dart';
import 'package:auto_size_text/auto_size_text.dart';

/// The page that shows info about a file and allows to download it
class ViewTestPage extends StatefulWidget {
  final int testPk;

  const ViewTestPage({@required this.testPk});

  @override
  _ViewTestPageState createState() => new _ViewTestPageState();
}

class _ViewTestPageState extends State<ViewTestPage> {
  Map _smallTopics;

  /// Get small topics list
  void _getSmallTopics() async {
    final tempData = await Api().getSmallTopicsOfTest(widget.testPk);
    setState(() {
      _smallTopics = tempData;
    });
  }

  /// Go to view a topic
  void _viewSmallTopic(int pk) {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return ViewTopic(topicPk: pk,);
          }
      ));
    });
  }

  Widget _getPage() {
    List<Widget> smallTopicsWidget = [];
    for (String pk in _smallTopics.keys) {
      smallTopicsWidget.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
          child: Material(
            elevation: 3.0,
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(10.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () {_viewSmallTopic(int.parse(pk));},
              highlightColor: Colors.blue,
              splashColor: Colors.blue,
              child: Container(
                height: 90.0,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Center(
                  child: AutoSizeText(
                    _smallTopics[pk],
                    style: TextStyle(fontSize: 25.0),
                  ),
                )
              ),
            ),
          ),
        ),
      );
    }
    return ListView(children: smallTopicsWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_smallTopics == null) {
      _getSmallTopics();
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff4dd0e1),
          elevation: 0.0,
          centerTitle: true,
          title: Text("כל הנושאים במבחן", textDirection: TextDirection.rtl,
            style: TextStyle(color: Colors.black, fontSize: 24.0),),
        ),
        body: Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    else {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff4dd0e1),
            elevation: 0.0,
            centerTitle: true,
            title: Text("כל הנושאים במבחן", textDirection: TextDirection.rtl,
              style: TextStyle(color: Colors.black, fontSize: 24.0),),
          ),
          body: _getPage()
      );
    }
  }
}