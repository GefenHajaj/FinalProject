import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bcademy/test.dart';
import 'package:bcademy/test_tile.dart';

class TestsPage extends StatefulWidget {
  const TestsPage();
  
  @override
  _TestsPageState createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  // Just until we connect to the server...
  var _demoTests = [
    Test(
        subject: "אזרחות",
        dateCreated: DateTime.now(),
        dateTaken: DateTime.utc(2019, 1, 29),
        link: "https://drive.google.com/open?id=0B6KYqL7wjzm0YW1BTmZScHJORm8",
        iconData: Icons.person),
    Test(
        subject: "היסטוריה",
        dateCreated: DateTime.now(),
        dateTaken: DateTime.utc(2019, 1, 25),
        link: "https://drive.google.com/open?id=0B6KYqL7wjzm0YW1BTmZScHJORm8",
        iconData: Icons.history),
  ];

  /// Returns a [ListView] of [TestTile]s.
  Widget _buildTestsWidgetsList() {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return TestTile(test: _demoTests[index], onTap: null);
        },
        itemCount: _demoTests.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTestsWidgetsList();
  }
}