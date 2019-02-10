import 'package:flutter/material.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/api.dart';

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

  Widget _getSubjectsList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: _color,
            borderRadius: _borderRadius,
            child: InkWell(
              borderRadius: _borderRadius,
              onTap: () {_goToChooseTopics(_subjects[index].name, _subjects[index].pk);},
              highlightColor: _highlightColor,
              splashColor: _splashColor,
              child: Container(
                alignment: Alignment.centerRight,
                height: _subjectHeight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      _subjects[index].name,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontSize: _fontSize
                    ),
                  ),
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
        title: Text(_appBarText, textDirection: TextDirection.ltr,),
      ),
      body: _getSubjectsList()
    );
  }
}

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffff3d00),
          elevation: 0.0,
          centerTitle: true,
          title: Text("מבחן ב${widget.subjectName} - בחר נושאים", textDirection: TextDirection.ltr,),
        ),
        body: Container()
    );
  }
}