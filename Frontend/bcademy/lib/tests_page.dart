import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/test_tile.dart';
import 'package:bcademy/api.dart';
import 'dart:async';

class TestsPage extends StatefulWidget {
  final onTestTap; // A function to call when tapping a test

  const TestsPage({@required this.onTestTap});
  
  @override
  _TestsPageState createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  // Just until we connect to the server...
  List<Test> tests;

  Future<void> _getAllTests() async {
    final tempTests = await Api().getAllTests(1);
    setState(() {
      tests = tempTests;
    });
  }

  /// Returns a [ListView] of [TestTile]s.
  Widget _buildTestsWidgetsList() {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return TestTile(test: tests[index], onTap: widget.onTestTap);
        },
        itemCount: tests == null ? 0 : tests.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (tests == null) {
      _getAllTests();
    }
    return Scaffold(
      body: _buildTestsWidgetsList(),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            title: Text("המבחנים שלי"),
            centerTitle: true,
            backgroundColor: Color(0xff29b6f6),
            elevation: 0.0,
          )
      ),
    );
    //_buildTestsWidgetsList();
  }
}