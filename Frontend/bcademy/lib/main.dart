import 'package:flutter/material.dart';
import 'package:bcademy/tests_page.dart';
import 'package:bcademy/placeholder.dart';
import 'package:bcademy/study_page.dart';
import 'package:bcademy/test.dart';

/// The function that's called when we run the app
void main() => runApp(BCademy());


class BCademy extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BCademy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

/// The home page of the app
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // The default page
  int _selectedPageIndex = 0;

  /// Changing the shown page
  void _onIconTap(int pageIndex) {
    setState(() {
      print(pageIndex);
      _selectedPageIndex = pageIndex;
    });
  }

  /// When tapping a test, we are sent to the studying page!
  void _onTestTap(Test test) {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return StudyPage(test: test);
        }
      ));
    });
  }

  /// All main pages in the app
  Widget _getPage(int index) {
    switch (index) {
      case 0: {
          return TestsPage(onTestTap: _onTestTap);
        }
        break;
      case 1: {
        return placeHolder("Feed Page");
      }
      break;
      case 2: {
        return placeHolder("Upload Page");
      }
      break;
      case 3: {
        return placeHolder("Profile Page");
      }
      break;
    }

    return Text("Got an index out of range 0-3. Woops!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BCademy', textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: _getPage(_selectedPageIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('Feed')),
            BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('Upload')),
            BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Profile')),
          ],
        currentIndex: _selectedPageIndex,
        fixedColor: Colors.blue,
        onTap: _onIconTap,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
