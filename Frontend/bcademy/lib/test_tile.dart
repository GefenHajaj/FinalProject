import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bcademy/structures.dart';

const _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(20.0);
final _color = Color(0xff29b6f6);
final _highlightColor = Colors.lightBlue;
final _splashColor = Colors.lightBlueAccent;

/// A test tile to represent a test
class TestTile extends StatelessWidget {
  final Test test;
  final ValueChanged<Test> onTap;

  // Constructor
  const TestTile({
    @required this.test,
    @required this.onTap
  }) :  assert(test != null);

  /// Builds a test tile to show a preview of a test
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        color: _color,
        borderRadius: _borderRadius,
        child: InkWell(
          borderRadius: _borderRadius,
          onTap: () {this.onTap(this.test);},
          highlightColor: _highlightColor,
          splashColor: _splashColor,
          child: Container(
            height: _rowHeight,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(this.test.icon, size: 50.0,),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "מבחן ב${this.test.subject.name}",
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24.0, fontFamily: 'Gisha'),
                        ),
                        Text(
                          "${this.test.dateTaken.day}.${this.test.dateTaken.month}.${this.test.dateTaken.year}",
                          style: TextStyle(fontSize: 16.0),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}