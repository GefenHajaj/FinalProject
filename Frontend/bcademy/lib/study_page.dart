/// This page shows the user all the material for a test in a convenient way -
/// in cards that let the user study step by step. From here, the user can go
/// to the page where he can send all the material via email to someone.
///
/// Developer: Gefen Hajaj

import 'package:flutter/material.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/api.dart';
import 'dart:async';
import 'package:quiver/iterables.dart';
import 'send_email_page.dart';

/// The study page, where a user can read all the material for a test
class StudyPage extends StatefulWidget {
  final Test test;

  const StudyPage({
    @required this.test
  }): assert(test != null);

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  // Map<String, String> _smallTopics;
  bool _gotInfo = false; // if we got the info (material)
  List _infoCards = [];  // the card widgets
  int _index = 0;        // index of current card
  String _allInfo = "";   // all the info in one long string (for email)
  Stopwatch stopwatch = Stopwatch();  // calculate the time a student studies

  @override
  void initState() {
    super.initState();
    stopwatch.start();
  }

  /// Get all small topics for a test from the server and make a list of cards -
  /// each card is one topic.
  Future<void> _getAllSmallTopics() async {
    final smallTopics = await Api().getAllSmallTopics(widget.test.pk);
    setState(() {
      _gotInfo = true;
      if (smallTopics != null && smallTopics.isNotEmpty) {
        // Saving the titles and the info of each topic in a convenient way:
        for (var titleData in zip([smallTopics.keys, smallTopics.values])) {
          _allInfo += titleData[0] + "\n\n" + titleData[1] + "\n\n\n";
          _infoCards.add(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 8.0,
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.transparent,
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.85,
                    decoration: BoxDecoration(
                        color: Color(0xffb2ebf2),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.black, width: 1.5)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      child: Center(
                        child: Column(
                          textDirection: TextDirection.rtl,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              titleData[0],
                              textAlign: TextAlign.start,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 26.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              titleData[1],
                              textAlign: TextAlign.start,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
          );
        }
        _infoCards.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.transparent,
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.85,
                  decoration: BoxDecoration(
                      color: Color(0xffb2ebf2),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.black, width: 1.5)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: Center(
                      child: Column(
                        textDirection: TextDirection.rtl,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "סיימת!",
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 26.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "כל הכבוד! רק לא לשכוח לתרגל...",
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
        );
      }
      else {  // should never come here
        return _infoCards.add(
            Center(child: Container(child: Text("Something went wrong..."),),)
        );
      }
    });
  }

  /// Present a card with some of the material. The user can go to the
  /// next/previous cards by pressing arrow buttons.
  Widget _getSummary() {
    // Make sure we have some topics (should be)
    if (_infoCards.isNotEmpty && _index >= 0 && _index < _infoCards.length) {
      // return all the widgets organized
      return Stack(
          children: <Widget>[
            // tells us what number of card we're watching
            // out of the total number of cards
            Align(
                alignment: Alignment(0, -0.95), // location on screen (x, y)
                child: Text("${_index + 1 < _infoCards.length ? _index + 1
                    : _index}/${_infoCards.length - 1}",
                  style: TextStyle(fontSize: 16.0),)
            ),
            // the card with the material itself
            Align(
              alignment: Alignment(0, 0),  // location on screen (x, y)
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 35.0, bottom: 10.0),
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(12.0, 0, 12, 12),
                        child:_infoCards[_index] // the correct card
                    ),
                  )
                ),
              ),
            ),
            // a right arrow sign. press to move to the next card (if possible)
            Align(
              alignment: Alignment(1.07, 0),
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.grey[800],),
                onPressed: () {
                  setState(() {
                    // increase number of card we're looking at if possible
                    if (_index < _infoCards.length - 1)
                      _index++;
                  });
                },
              ),
            ),
            // a left arrow sign. press to move to the previous card
            // (if possible)
            Align(
              alignment: Alignment(-1.07, 0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.grey[800],),
                onPressed: () {
                  setState(() {
                    // decrease number of card we're looking at if possible
                    if (_index > 0)
                      _index--;
                  });
                },
              ),
            ),
        ]
      );
    }
    // in case there are no topics, return text that tells the user that
    // something went wrong (there are small topics in each test).
    else {  // should never come here
      return Center(child: Container(child: Text("Something went wrong..."),),);
    }
  }

  /// Go to the page where you can send all the material to the test via email.
  void _goToEmailPage() {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return SendEmailPage(info: _allInfo,
                subjectName: widget.test.subject.name);
          }
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_gotInfo) {
      _getAllSmallTopics();
      return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Color(0xff00acc1),
            centerTitle: true,
            title: Text("לומדים למבחן ב${widget.test.subject.name}",
              style: TextStyle(fontSize: 22.0,),),
          ),
          body: Center(
            child: Container(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          )
      );
    }
    else {
      return Scaffold(
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              // When pressing back, let the app know that the student
              // studied more time and how much time:
              onPressed: () async {
                stopwatch.stop();
                int newTime = stopwatch.elapsedMilliseconds +
                    widget.test.millisecondsStudy;
                await Api().updateTestStudyTime(newTime, widget.test.pk);
                Navigator.of(context).pop();
                },
            ),
            elevation: 0.0,
            backgroundColor: Color(0xff00acc1),
            centerTitle: true,
            title: Text("לומדים למבחן ב${widget.test.subject.name}",
              style: TextStyle(fontSize: 22.0,),),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.email, color: Colors.white, size: 30,),
                onPressed: () {
                  _goToEmailPage();
                },
              ),
            ],
          ),
          body: _getSummary(),
      );
    }
  }
}

/// View a specific topic (get here from topic search results)
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

  /// Get the info of the topic from the server
  Future<void> _getTopic() async {
    var tempInfo = await Api().getSmallTopic(widget.topicPk);
    setState(() {
      topicInfo = tempInfo;
    });
  }

  /// Show the text to the user and allow him to read it
  Widget _getPage() {
    if (topicInfo != null) {
      return Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
            child: Text(topicInfo['title'], textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 26.0),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
      return Scaffold(
        body: Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xff00acc1),
          centerTitle: true,
          title: Text("צפייה בחומר",
            style: TextStyle(fontSize: 22.0,),),
        ),
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