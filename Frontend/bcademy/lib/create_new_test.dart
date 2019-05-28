/// This page allows the user to create a new test
///
/// developer: Gefen Hajaj

import 'package:flutter/material.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/api.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:async';

/// Choosing a subject for the new test.
class ChooseSubjectPage extends StatefulWidget {
  const ChooseSubjectPage();

  @override
  _ChooseSubjectPageState createState() => _ChooseSubjectPageState();
}

class _ChooseSubjectPageState extends State<ChooseSubjectPage> {
  final List<Subject> _subjects = Data.allSubjects;
  final _color = Color(0xffff5722);
  final _borderRadius = BorderRadius.circular(8.0);
  final _highlightColor = Colors.red;
  final _splashColor = Colors.red;
  final _subjectHeight = 100.0;
  final _fontSize = 36.0;
  final _appBarText = "מבחן חדש - בחר מקצוע";

  /// Go to the next step - choose small topics
  void _goToChooseTopics(String name, int pk) {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return ChooseSmallTopics(subjectName: name, subjectPk: pk);
          }
      ));
    });
  }

  /// Returns a list of subjects available in the app
  Widget _getSubjectsList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
          child: Material(
            color: _color,
            borderRadius: _borderRadius,
            child: InkWell(
              borderRadius: _borderRadius,
              onTap: () {_goToChooseTopics(_subjects[index].name,
                  _subjects[index].pk);},
              highlightColor: _highlightColor,
              splashColor: _splashColor,
              child: Container(
                alignment: Alignment.centerRight,
                height: _subjectHeight,
                child: Row(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(Data.getIcon(_subjects[index].name),
                        size: 50.0,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                          _subjects[index].name,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: _fontSize
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ),
          ),
        );
      },
      itemCount: _subjects.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffff3d00),
        elevation: 0.0,
        centerTitle: true,
        title: Text(_appBarText, textDirection: TextDirection.rtl,),
      ),
      body: _getSubjectsList()
    );
  }
}

/// Choosing small topics for a new test.
class ChooseSmallTopics extends StatefulWidget {
  final String subjectName;
  final int subjectPk;

  const ChooseSmallTopics({
    @required this.subjectName,
    @required this.subjectPk}
    ) : assert(subjectPk != null),
        assert(subjectName != null);

  @override
  _ChooseSmallTopicsState createState() => _ChooseSmallTopicsState();
}

class _ChooseSmallTopicsState extends State<ChooseSmallTopics> {
  List _smallTopics; // [(1, "decision 181"), (2, "the war"),]
  List<int> _chosenSmallTopics = [];
  final _notChosenColor = Color(0xff80deea);
  final _chosenColor = Color(0xff0097a7);
  final _borderRadius = BorderRadius.circular(8.0);
  final _highlightColor = Colors.lightBlueAccent;
  final _splashColor = Colors.lightBlueAccent;
  final _tileHeight = 100.0;
  final _fontSize = 24.0;
  var _buttonColor = Color(0xffffee58);
  var _buttonText = "סיימתי";
  var _buttonHeight = 75.0;
  var _buttonWidth = 300.0;
  var _normalButtonHeight = 75.0;
  var _normalButtonWidth = 300.0;
  var _warningButtonHeight = 100.0;
  var _warningButtonWidth = 325.0;
  var _normalButtonColor = Color(0xffffee58);
  var _normalButtonText = "סיימתי";
  var _warningButtonColor = Colors.red;
  var _warningButtonText = "אתה חייב לבחור\nלפחות נושא אחד";

  /// Get all the small topics for a specific subject from the server
  Future<void> _getAllSmallTopics() async {
    final tempSmallTopics = await Api().getAllSubjectSmallTopics(
        widget.subjectPk);
    setState(() {
      _smallTopics = tempSmallTopics;
    });
  }

  /// Update the list to show which topics were chosen (change in color)
  void _updateChosenList(int smallTopicPk) {
    _buttonText = _normalButtonText;
    _buttonColor = _normalButtonColor;
    _buttonWidth = _normalButtonWidth;
    _buttonHeight = _normalButtonHeight;
    // Remove small topic that was chosen and pressed on again
    if (_chosenSmallTopics.contains(smallTopicPk)) {
      setState(() {
        _chosenSmallTopics.remove(smallTopicPk);
      });
    }
    // Add small topic to chosen list
    else {
      setState(() {
        _chosenSmallTopics.add(smallTopicPk);
      });
    }
  }

  /// Move to the next step - pick a date for the test
  void _goToChooseDate() {
    // Make sure the user chose at least one topic. If not, change the color,
    // size and text of buton to tell the user he must pick at least one.
    if (_chosenSmallTopics.isEmpty) {
      setState(() {
        _buttonColor = _warningButtonColor;
        _buttonText = _warningButtonText;
        _buttonHeight = _warningButtonHeight;
        _buttonWidth = _warningButtonWidth;
      });
    }
    else {
      setState(() {
        Navigator.of(context).push(MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return ChooseDate(
                  subjectName: widget.subjectName,
                  subjectPk: widget.subjectPk,
                  smallTopics: _chosenSmallTopics
              );
            }
        ));
      });
    }
  }

  /// Get a list of all the small topics
  Widget _getSmallTopicsList() {
    // If there are no small topics for a subject
    if (_smallTopics.isEmpty) {
      return Container(
        child: Center(
          child: Text("עדיין אין נושאים למקצוע הזה.\nחזור בקרוב!",
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 28),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        if (index >= _smallTopics.length) {
          return Container(height: 75.0,);
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(8.0 ,4, 8, 4),
          child: Material(
            color: _chosenSmallTopics.contains(_smallTopics[index][0]) ?
            _chosenColor : _notChosenColor ,
            borderRadius: _borderRadius,
            child: InkWell(
              borderRadius: _borderRadius,
              onTap: () {_updateChosenList(_smallTopics[index][0]);},
              child: Container(
                  alignment: Alignment.centerRight,
                  height: _tileHeight,
                  child: Row(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(Icons.star, size: 20.0,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: _tileHeight,
                          width: MediaQuery.of(context).size.width/1.3,
                          child: Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: AutoSizeText(
                              _smallTopics[index][1],
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: _fontSize
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ),
        );
      },
      itemCount: _smallTopics.length + 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_smallTopics == null) {
      _getAllSmallTopics();
      return Scaffold(
        body: Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color(0xffff3d00),
          elevation: 0.0,
          centerTitle: true,
          title: Text("מבחן ב${widget.subjectName} - בחר נושאים",
            textDirection: TextDirection.rtl,),
        ),
      );
    }
    else {
      var body;
      if (_smallTopics.isEmpty) {
        body = _getSmallTopicsList();
      }
      else {
        body = Stack(
          children: <Widget>[
            _getSmallTopicsList(),
            Align(
              alignment: Alignment(0, 0.8),
              child: Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.transparent,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    height: _buttonHeight,
                    width: _buttonWidth,
                    decoration: BoxDecoration(
                        color: _buttonColor,
                        borderRadius: BorderRadius.circular(50.0)
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50.0),
                      onTap: _goToChooseDate,
                      child: Center(
                        child: Text(_buttonText,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0
                          ),
                        ),
                      ),
                    ),
                  )
              ),
            ),
          ],
        );
      }
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffff3d00),
            elevation: 0.0,
            centerTitle: true,
            title: Text("מבחן ב${widget.subjectName} - בחר נושאים",
              textDirection: TextDirection.rtl,),
          ),
          body: body
      );
    }
  }
}

/// Choosing the date for a new test
class ChooseDate extends StatefulWidget {
  final String subjectName;
  final int subjectPk;
  final List<int> smallTopics;

  const ChooseDate({
    @required this.subjectName,
    @required this.subjectPk,
    @required this.smallTopics
  });

  @override
  _ChooseDateState createState() => _ChooseDateState();
}

class _ChooseDateState extends State<ChooseDate> {
  var _selectedDate = DateTime.now();
  var _buttonColor = Color(0xffffee58);
  var _buttonText = "בחרתי!\nצור מבחן";
  var _buttonHeight = 75.0;
  var _buttonWidth = 300.0;
  var _normalButtonHeight = 75.0;
  var _normalButtonWidth = 300.0;
  var _warningButtonHeight = 100.0;
  var _warningButtonWidth = 325.0;
  var _normalButtonColor = Color(0xffffee58);
  var _normalButtonText = "בחרתי!\nצור מבחן";
  var _warningButtonColor = Colors.red;
  var _warningButtonText = "תאריך המבחן לא\nיכול להיות בעבר";
  var _datePickedColor = Color(0xbbb2ff59);
  var _normalDatePickedColor = Color(0xbbb2ff59);
  var _warningDatePickedColor = Colors.red;

  /// Change the date selected.
  void _selectDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = new DateTime(now.year, now.month, now.day - 1);
    // Return button to original state when changing the date again
    if (!date.isBefore(yesterday)) {
      setState(() {
        _datePickedColor = _normalDatePickedColor;
        _buttonText = _normalButtonText;
        _buttonColor = _normalButtonColor;
        _buttonWidth = _normalButtonWidth;
        _buttonHeight = _normalButtonHeight;
        _selectedDate = date;
      });
    }
    else {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  /// Finish creating a test. Make sure the date picked is in the future/today.
  void _finishCreatingTest() {
    final now = DateTime.now();
    final yesterday = new DateTime(now.year, now.month, now.day - 1);
    if (!_selectedDate.isBefore(yesterday)) {
      Api().createTest(
          widget.subjectPk,
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          widget.smallTopics
      );
      new Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pushNamedAndRemoveUntil('/tests',
              (Route<dynamic> route) => false);

    }
    // If the date is in the past - tell the user
    else {
      setState(() {
        _datePickedColor = _warningDatePickedColor;
        _buttonHeight = _warningButtonHeight;
        _buttonWidth = _warningButtonWidth;
        _buttonColor = _warningButtonColor;
        _buttonText = _warningButtonText;
      });
    }
  }

  /// Return the calender as a widget
  Widget _getCalender() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: CalendarCarousel(
        selectedDayButtonColor: _datePickedColor,
        selectedDayTextStyle: TextStyle(color: Colors.black),
        todayButtonColor: Color(0xfffff9c4),
        todayTextStyle: TextStyle(color: Colors.black),
        onDayPressed: (DateTime date, List lst) {_selectDate(date);},
        thisMonthDayBorderColor: Colors.grey,
        height: 420.0,
        selectedDateTime: _selectedDate,
        daysHaveCircularBorder: null,
      ),
    );
  }

  /// Get the body of the app, with the button and calender
  Widget _getBody() {
    return Stack(
      children: <Widget>[
        _getCalender(),
        // Button:
        Align(
          alignment: Alignment(0, 0.8),
          child: Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.transparent,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                height: _buttonHeight,
                width: _buttonWidth,
                decoration: BoxDecoration(
                    color: _buttonColor,
                    borderRadius: BorderRadius.circular(50.0)
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50.0),
                  onTap: _finishCreatingTest,
                  child: Center(
                    child: Text(_buttonText,
                      textAlign: TextAlign.center,
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffff3d00),
        elevation: 0.0,
        centerTitle: true,
        title: Text("מבחן ב${widget.subjectName} - בחר תאריך",
          textDirection: TextDirection.rtl,),
      ),
      body: _getBody()
    );
  }
}