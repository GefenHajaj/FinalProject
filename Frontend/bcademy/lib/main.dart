import 'package:flutter/material.dart';
import 'package:bcademy/home_page.dart';

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
        fontFamily: 'Rubik',
      ),
      home: HomePage(), // remember to change
      routes: <String, WidgetBuilder> {
        '/tests': (BuildContext context) => new HomePage(),
        '/quizzes': (BuildContext context) => new HomePage(startPage: 2,),
      },
    );
  }
}

