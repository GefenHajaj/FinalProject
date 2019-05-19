import 'package:flutter/material.dart';
import 'package:bcademy/home_page.dart';
import 'package:bcademy/sign_in_page.dart';

/// The function that's called when we run the app
void main() => runApp(BCademy());


class BCademy extends StatelessWidget {
  // The root of the application.
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
      home: SignInPage(), // the starting page
      // routes (pages) we use in the app
      routes: <String, WidgetBuilder> {
        '/tests': (BuildContext context) => new HomePage(),
        '/quizzes': (BuildContext context) => new HomePage(startPage: 2,),
        '/profile': (BuildContext context) => new HomePage(startPage: 4,),
      },
    );
  }
}

