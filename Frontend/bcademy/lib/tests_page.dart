/// This is where the user sees all his tests in one place. He can press on one
/// and go to a navigation page. From there he can take a quiz about it, read
/// the material of the test and even send it via email to someone.
/// One of the main screens in the app.
///
/// Developer: Gefen Hajaj

import 'package:flutter/material.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/test_tile.dart';
import 'package:bcademy/api.dart';
import 'dart:async';
import 'package:bcademy/create_new_test.dart';
import 'package:bcademy/navigator_page.dart';

/// The tests page - home screen
class TestsPage extends StatefulWidget {
  const TestsPage();
  
  @override
  _TestsPageState createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  // Just until we connect to the server...
  List<Test> _tests;

  /// Get basic info about all the tests from the server
  Future<void> _getAllTests() async {
    final tempTests = await Api().getAllTests();
    setState(() {
      _tests = tempTests;
    });
  }

  /// When tapping a test, we are sent to the studying page!
  void _onTestTap(Test test) {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return NavigatorPage(test: test);
          }
      ));
    });
  }

  /// refresh app
  void _onRefresh() {
    setState(() {
      _tests = null;
    });
  }

  /// Returns a [ListView] of [TestTile]s. Basically a list of all the tests.
  Widget _buildTestsWidgetsList() {
    if (_tests.isNotEmpty) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              textDirection: TextDirection.rtl,
              children: <Widget>[
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    "המבחן הקרוב: בעוד ${_tests[index].dateTaken.
                    difference(DateTime.now()).inDays} ימים",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5,),
                TestTile(test: _tests[index], onTap: _onTestTap),
              ],
            );
          }
          else if (index != _tests.length && index == 1) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              textDirection: TextDirection.rtl,
              children: <Widget>[
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    "המבחנים הבאים:",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5,),
                TestTile(test: _tests[index], onTap: _onTestTap),
              ],
            );
          }
          else if (index != _tests.length) {
            return TestTile(test: _tests[index], onTap: _onTestTap);
          }
          else {
            // Another blank tile to be able to see the last test.
            return Container(height: 130.0,);
          }
        },
        itemCount: _tests == null ? 0 : _tests.length + 1,
      );
    }
    else {
      return Align(
        alignment: Alignment(0, -0.2),
        child: SingleChildScrollView(
          child: Text("עדיין לא יצרת מבחנים!",
            style: TextStyle(fontSize: 34.0),
            textDirection: TextDirection.rtl,),
        ),
      );
    }
  }

  /// Go to create a new test!
  void _createNewTest() {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return ChooseSubjectPage();
          }
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_tests == null) {
      _getAllTests();
      return Scaffold(
        body: Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: AppBar(
              title: Text("המבחנים שלי"),
              centerTitle: true,
              backgroundColor: Color(0xff29b6f6),
              elevation: 5.0,
            )
        ),
      );
    }
    else {
      return Scaffold(
        body: Stack(
            children: <Widget>[
              _buildTestsWidgetsList(),
              // Button to create a new test
              Align(
                alignment: Alignment(0, 0.85),
                child: Material(
                    // elevation: 10.0,
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.transparent,
                    child: Container(
                      height: 60.0,
                      width: 250.0,
                      decoration: BoxDecoration(
                          color: Color(0xffff3d00),
                          borderRadius: BorderRadius.circular(50.0)
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50.0),
                        onTap: _createNewTest,
                        child: Center(
                          child: Text("מבחן חדש",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0
                            ),
                          ),
                        ),
                      ),
                    )
                ),
              ),
            ],
        ),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: AppBar(
              title: Text("המבחנים שלי"),
              centerTitle: true,
              backgroundColor: Color(0xff29b6f6),
              elevation: 5.0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.white, size: 20,),
                  onPressed: () {
                    _onRefresh();
                  },
                ),
              ],
            )
        ),
      );
      //_buildTestsWidgetsList();
    }
  }
}