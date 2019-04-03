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
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // The default page
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    Data.startApp(userPk: 1);
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
        return TestsPage();
      }
      break;
      case 1: {
        return SearchPage();
      }
      break;
      case 2: {
        return QuizzesPage();
      }
      case 3: {
        return UploadFilePage();
      }
      break;
      case 4: {
        return ProfilePage();
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
        elevation: 0.0,
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
