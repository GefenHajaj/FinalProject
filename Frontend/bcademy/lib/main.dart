import 'package:flutter/material.dart';

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
    Text('Index 0: Home'),
    Text('Index 1: Feed'),
    Text('Index 2: Upload'),
    Text('Index 3: Study'),
    Text('Index 4: Profile')
  ];

  void _onIconTap(int pageIndex) {
    setState(() {
      _selectedPageIndex = pageIndex;
    });
  }

  Widget _placeHolder(String title) {
    const _padding = EdgeInsets.all(16.0);

    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints.expand(height: 400, width: 800),
        margin: _padding,
        padding: _padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.blue,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.build,
                size: 180.0,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "$title\nUnder Construction!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BCademy', textAlign: TextAlign.center,),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Center(
        child: _placeHolder(_mainPages[_selectedPageIndex].data),
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
