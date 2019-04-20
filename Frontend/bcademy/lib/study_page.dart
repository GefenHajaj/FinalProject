import 'package:flutter/material.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/api.dart';
import 'dart:async';
import 'package:quiver/iterables.dart';

class StudyPage extends StatefulWidget {
  final Test test;

  const StudyPage({
    @required this.test
  }): assert(test != null);

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  Map<String, String> _smallTopics;

  Future<void> _getAllSmallTopics() async {
    final tempSmallTopics = await Api().getAllSmallTopics(widget.test.pk);
    setState(() {
      _smallTopics = tempSmallTopics;
    });
  }

  /// Gets a list of all the info about the test - summary
  Widget _getSummary() {
    // Make sure we have some topics (should be)
    if (_smallTopics != null && _smallTopics.isNotEmpty) {
      // Saving the titles and the info of each topic in a convenient way:
      List<String> titles = [];
      List<String> info = [];
      for (var titleData in zip([_smallTopics.keys, _smallTopics.values])) {
        titles.add(titleData[0]);
        info.add(titleData[1]);
      }

      // The page itself:
      return Padding(
        padding: const EdgeInsets.all(8.0),
        // Creating a list of widgets
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            // Each item in the list is a column
            return Column(
              // Each column contains a title and the suitable info
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // The title:
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    titles[index],
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // The info:
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    info[index],
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 18.0),),
                )
              ],
            );
          },
          itemCount: titles.length,  // how many columns (same as info.length)
        ),
      );
    }
    else {  // should never come here
      return Center(child: Container(child: Text("Something went wrong..."),),);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_smallTopics == null) {
      _getAllSmallTopics();
      return Container(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(),
      );
    }
    else {
      return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Color(0xff00acc1),
            centerTitle: true,
            title: Text("לומדים למבחן ב${widget.test.subject.name}",
              style: TextStyle(fontSize: 22.0,),),
          ),
          body: _getSummary()
      );
    }
  }
}


class ViewTopic extends StatefulWidget {
  final int topicPk;

  const ViewTopic({
    @required this.topicPk
  }): assert(topicPk != null);

  @override
  _ViewTopicState createState() => _ViewTopicState();
}

class _ViewTopicState extends State<ViewTopic> {
  var topicInfo;

  Future<void> _getTopic() async {
    var tempInfo = await Api().getSmallTopic(widget.topicPk);
    setState(() {
      topicInfo = tempInfo;
    });
  }

  /// Gets a list of all the info
  Widget _getPage() {
    if (topicInfo != null) {
      return Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(topicInfo['title'], textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 26.0),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(topicInfo['info'], textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 18.0),),
          )
        ],
      );
    }
    else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (topicInfo == null) {
      _getTopic();
      return Container(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(),
      );
    }
    else {
      return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Color(0xff00acc1),
            centerTitle: true,
            title: Text("צפייה בחומר",
              style: TextStyle(fontSize: 22.0,),),
          ),
          body: _getPage()
      );
    }
  }
}