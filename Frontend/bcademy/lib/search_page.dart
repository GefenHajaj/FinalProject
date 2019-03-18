import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/test_tile.dart';
import 'package:bcademy/api.dart';
import 'dart:async';
import 'package:bcademy/create_new_test.dart';
import 'package:bcademy/placeholder.dart';

class SearchPage extends StatefulWidget {
  const SearchPage();

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map topics;
  Map files;
  String search;
  int mode = 0; // 0 - topics. 1 - files.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            title: Text("חיפוש"),
            centerTitle: true,
            backgroundColor: Color(0xff29b6f6),
            elevation: 0.0,
          )
      ),
      body: Center(child: placeHolder('Search Page')),
    );
  }
}