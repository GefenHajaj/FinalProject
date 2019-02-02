import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/test_tile.dart';
import 'package:bcademy/api.dart';

class TestsPage extends StatefulWidget {
  final onTestTap; // A function to call when tapping a test

  const TestsPage({@required this.onTestTap});
  
  @override
  _TestsPageState createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  // Just until we connect to the server...
  var _demoTests = Data.allTests;

  /// Returns a [ListView] of [TestTile]s.
  Widget _buildTestsWidgetsList() {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return TestTile(test: _demoTests[index], onTap: widget.onTestTap);
        },
        itemCount: _demoTests.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTestsWidgetsList();
  }
}