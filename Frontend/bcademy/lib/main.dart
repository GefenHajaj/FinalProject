import 'package:flutter/material.dart';
import 'package:bcademy/tests_page.dart';
import 'package:bcademy/placeholder.dart';
import 'package:bcademy/navigator_page.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/api.dart';
import 'package:bcademy/upload_page.dart';
import 'package:bcademy/profile_page.dart';
import 'package:bcademy/search_page.dart';
import 'package:bcademy/home_page.dart';
import 'package:bcademy/sign_in_page.dart';

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
      home: SignInPage(),
    );
  }
}

