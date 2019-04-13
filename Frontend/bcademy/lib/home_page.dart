import 'package:flutter/material.dart';
import 'package:bcademy/tests_page.dart';
import 'package:bcademy/placeholder.dart';
import 'package:bcademy/navigator_page.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/api.dart';
import 'package:bcademy/upload_page.dart';
import 'package:bcademy/profile_page.dart';
import 'package:bcademy/search_page.dart';
import 'package:bcademy/quizzes_page.dart';

/// The home page of the app
class HomePage extends StatefulWidget {
  final int startPage;
  HomePage({Key key, this.startPage}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // The default page
  int _selectedPageIndex = 0;
  final _testsPage = TestsPage();
  final _searchPage = SearchPage();
  final _quizzesPage = QuizzesPage();
  final _uploadPage = UploadFilePage();
  final _profilePage = ProfilePage();

  @override
  void initState() {
    super.initState();
    if (widget.startPage != null) {
      _selectedPageIndex = widget.startPage;
    }
    Data.startApp();
  }

  /// Changing the shown page
  void _onIconTap(int pageIndex) {
    setState(() {
      print(pageIndex);
      _selectedPageIndex = pageIndex;
    });
  }

  /// All main pages in the app
  Widget _getPage(int index) {
    switch (index) {
      case 0: {
        return _testsPage;
      }
      break;
      case 1: {
        return _searchPage;
      }
      break;
      case 2: {
        return _quizzesPage;
      }
      case 3: {
        return _uploadPage;
      }
      break;
      case 4: {
        return _profilePage;
      }
      break;
    }

    return Text("Got an index out of range 0-4. Woops!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BCademy', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontFamily: 'Norican', fontSize: 30.0),),
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Color(0xff80d8ff),
      ),
      body: Center(
        child: _getPage(_selectedPageIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('Search')),
          BottomNavigationBarItem(icon: Icon(Icons.help_outline), title: Text('Quizzes')),
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
