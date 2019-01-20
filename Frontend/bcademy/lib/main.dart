import 'package:flutter/material.dart';
import 'package:bcademy/tests_page.dart';
import 'package:bcademy/placeholder.dart';

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
  int _selectedPageIndex = 1;

  // All main pages in the app
  final _mainPages = [
    TestsPage(),
    placeHolder("Feed Page"),
    placeHolder("Upload Page"),
    placeHolder("Study Page"),
    placeHolder("Profile Page"),
  ];



  // Changing the shown page
  void _onIconTap(int pageIndex) {
    setState(() {
      _selectedPageIndex = pageIndex;
    });
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
        child: _mainPages[_selectedPageIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('Feed')),
            BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('Upload')),
            BottomNavigationBarItem(icon: Icon(Icons.book), title: Text('Study')),
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
