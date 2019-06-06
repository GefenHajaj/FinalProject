/// This is the profile page of a user. Here, he can see all his files,
/// download them and even sign out of the app.
///
/// Developer: Gefen Hajaj

import 'package:flutter/material.dart';
import 'package:bcademy/api.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:async';
import 'package:bcademy/file_page.dart';
import 'package:bcademy/sign_in_page.dart';
import 'package:bcademy/messages_page.dart';

/// The profile page
class ProfilePage extends StatefulWidget {
  const ProfilePage();

  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map _files; // {pk: {info: ..., date_created,}, pk2: {}, }
  int _howManyMessages;

  /// Get info about all the files of a user from the server
  Future<void> _getAllFiles() async {
    final filesInfo = await Api().getUserFiles();
    final hasMsg = await Api().howManyMessages();
    setState(() {
      _files = filesInfo;
      _howManyMessages = hasMsg;
    });
  }

  /// When pressing on a file tab - go to the file page (show info, download)
  void _goToFilePage(Map fileData) {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return FilePage(fileData: fileData, myFile: true,);
          }
      ));
    });
  }

  /// Sign out of the app - go to sign in page.
  void _goToSignInPage() {
    setState(() {
      Navigator.of(context).pushReplacement(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return SignInPage();
          }
      ));
    });
  }

  void _goToMessagesPage()
  {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return MessagesPage();
          }
      ));
    });
  }

  /// Get the entire page - all the tabs, titles and images
  Widget _getPage() {
    final fileTiles = <Widget>[];
    for (String pk in _files.keys) {
      fileTiles.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 2.0,
            borderRadius: BorderRadius.circular(8.0),
            child: InkWell(
              onTap: () {_goToFilePage(_files[pk]);},
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color(0xffe3f2fd),
                    border: Border.all(color: Color(0xbbb1bfca))
                ),
                child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      AutoSizeText("${_files[pk]['subject_name']}",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 26.0,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,),
                      SizedBox(height: 5.0,),
                      AutoSizeText(_files[pk]['info'],
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        maxLines: 3, style: TextStyle(fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0,),
                      AutoSizeText("${_files[pk]['day']}."
                          "${_files[pk]['month']}."
                          "${_files[pk]['year']}",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0,),
                      AutoSizeText("${_files[pk]['name']}",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        maxLines: 1, minFontSize: 14.0,),
                    ],
                  ),
                )),
              ),
            ),
          ),
        )
      );
    }

    var lastPart;
    // Tell the user he has no files in case he has none...
    if (fileTiles.isEmpty) {
      lastPart = [
        Container(height: 150,),
        Center(child: Text(
          "עדיין אין שום קבצים 😧",
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28.0),),)];
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
              child: IconButton(
                icon: Icon(_howManyMessages > 0 ? Icons.mail :
                Icons.mail_outline, size: 36.0),
                onPressed: () {_goToMessagesPage();},
              ),
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
                      borderRadius: BorderRadius.circular(5.0),
                    color: Colors.red
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text("התנתק", style: TextStyle(
                        fontWeight: FontWeight.bold),),
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
            child: Text("כל הקבצים שלי", style: TextStyle(
                fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          )],
        ),
        Divider(height: 10.0,),
      ] + lastPart,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_files == null || _howManyMessages == null) {
      _getAllFiles();
      return Scaffold(
        body: Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
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
    else {
      return Scaffold(
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