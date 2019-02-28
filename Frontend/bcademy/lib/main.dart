import 'package:flutter/material.dart';
import 'package:bcademy/tests_page.dart';
import 'package:bcademy/placeholder.dart';
import 'package:bcademy/navigator_page.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/api.dart';
import 'package:bcademy/upload_page.dart';
import 'package:bcademy/profile_page.dart';

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
        backgroundColor: Color(0xffffebee),
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
        return UploadFilePage();
      }
      break;
      case 3: {
        return ProfilePage();
      }
      break;
    }

    return Text("Got an index out of range 0-3. Woops!");
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
