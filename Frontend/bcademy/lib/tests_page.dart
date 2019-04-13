import 'package:flutter/material.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/test_tile.dart';
import 'package:bcademy/api.dart';
import 'dart:async';
import 'package:bcademy/create_new_test.dart';
import 'package:bcademy/navigator_page.dart';

class TestsPage extends StatefulWidget {
  const TestsPage();
  
  @override
  _TestsPageState createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  // Just until we connect to the server...
  List<Test> tests;

  Future<void> _getAllTests() async {
    final tempTests = await Api().getAllTests();
    setState(() {
      tests = tempTests;
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

  /// Returns a [ListView] of [TestTile]s.
  Widget _buildTestsWidgetsList() {
    if (tests.isNotEmpty) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          if (index != tests.length) {
            return TestTile(test: tests[index], onTap: _onTestTap);
          }
          else {
            // Another blank tile to be able to see the last test.
            return Container(height: 130.0,);
          }
        },
        itemCount: tests == null ? 0 : tests.length + 1,
      );
    }
    else {
      return Align(
        alignment: Alignment(0, -0.2),
        child: SingleChildScrollView(
          child: Text("עדיין לא יצרת מבחנים!", style: TextStyle(fontSize: 34.0), textDirection: TextDirection.rtl,),
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
    if (tests == null) {
      _getAllTests();
      return new Container(
        child: CircularProgressIndicator(),
      );
    }
    else {
      return Scaffold(
        body: Stack(
            children: <Widget>[
              _buildTestsWidgetsList(),
              Align(
                alignment: Alignment(0, 0.8),
                child: Material(
                    elevation: 10.0,
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.transparent,
                    child: Container(
                      height: 75.0,
                      width: 300.0,
                      decoration: BoxDecoration(
                          color: Color(0xffff3d00),
                          borderRadius: BorderRadius.circular(50.0)
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50.0),
                        onTap: _createNewTest,
                        child: Center(
                          child: Text("צור מבחן חדש",
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
            )
        ),
      );
      //_buildTestsWidgetsList();
    }
  }
}