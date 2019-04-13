import 'package:flutter/material.dart';
import 'package:bcademy/api.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:async';
import 'package:bcademy/file_page.dart';
import 'package:bcademy/sign_in_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage();

  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map _files; // {pk: {info: ..., date_created,}, pk2: {}, }

  Future<void> _getAllFiles() async {
    final filesInfo = await Api().getUserFiles();
    setState(() {
      _files = filesInfo;
    });
  }

  void _goToFilePage(Map fileData) {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return FilePage(fileData: fileData);
          }
      ));
    });
  }

  void _goToSignInPage() {
    setState(() {
      Navigator.of(context).pushReplacement(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return SignInPage();
          }
      ));
    });
  }

  Widget _getPage() {
    final fileTiles = <Widget>[];
    for (String pk in _files.keys) {
      fileTiles.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {_goToFilePage(_files[pk]);},
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Color(0xff80deea)),
              child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  AutoSizeText("${_files[pk]['subject_name']}", textDirection: TextDirection.rtl, style: TextStyle(fontSize: 30.0), textAlign: TextAlign.center,),
                  Container(height: 5.0,),
                  AutoSizeText(_files[pk]['info'], textDirection: TextDirection.rtl, style: TextStyle(fontSize: 20.0),),
                  Container(height: 5.0,),
                  AutoSizeText("${_files[pk]['name']}", style: TextStyle(fontSize: 14.0), textAlign: TextAlign.center,),
                  Container(height: 8.0,),
                  AutoSizeText("${_files[pk]['day']}.${_files[pk]['month']}.${_files[pk]['year']}", style: TextStyle(fontSize: 14.0),),
                ],
              )),
            ),
          ),
        )
      );
    }

    var lastPart;
    if (fileTiles.isEmpty) {
      lastPart = [Container(height: 200,), Center(child: Text("עדיין אין שום קבצים 😧", textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 28.0),),)];
    }
    else {
      lastPart = [Expanded(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: GridView.count(
            primary: true,
            shrinkWrap: true,
            crossAxisSpacing: 0,
            crossAxisCount: 2,
            children: fileTiles,
          ),
        ),
      )];
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.person, size: 36.0,),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(Data.userName, style: TextStyle(fontSize: 24.0),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                onTap: () {_goToSignInPage();},
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent,),
                      borderRadius: BorderRadius.circular(10.0),
                    color: Colors.redAccent
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("התנתק", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),),
              ),
            ),
          ],
        ),
        Container(color: Colors.black, height: 1.0,),
        Divider(height: 5.0,),
        Row(
          textDirection: TextDirection.rtl,
          children: <Widget>[Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text("כל הקבצים שלי", style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
          )],
        ),
        Divider(height: 10.0,),
      ] + lastPart,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_files == null) {
      _getAllFiles();
      return new Container(
        child: CircularProgressIndicator(),
      );
    }
    else {
      return new Scaffold(
        body: _getPage(),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: AppBar(
              title: Text("הפרופיל שלי"),
              centerTitle: true,
              backgroundColor: Color(0xff29b6f6),
              elevation: 5.0,
            )
        ),
      );
    }
  }
}