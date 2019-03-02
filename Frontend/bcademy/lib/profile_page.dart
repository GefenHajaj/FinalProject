import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bcademy/api.dart';
import 'package:bcademy/structures.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:open_file/open_file.dart';

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

  Widget _getPage() {
    final fileTiles = <Widget>[];
    for (String pk in _files.keys) {
      fileTiles.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {_goToFilePage(_files[pk]);},
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Colors.blue),
              child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  AutoSizeText("קובץ במקצוע:\n ${_files[pk]['subject_name']}", textDirection: TextDirection.rtl, style: TextStyle(fontSize: 24.0), textAlign: TextAlign.center,),
                  Container(height: 5.0,),
                  AutoSizeText(_files[pk]['info'], style: TextStyle(fontSize: 20.0),),
                  Container(height: 5.0,),
                  AutoSizeText("${_files[pk]['day']}.${_files[pk]['month']}.${_files[pk]['year']}", style: TextStyle(fontSize: 16.0),),
                  AutoSizeText("${_files[pk]['name']}", style: TextStyle(fontSize: 16.0), textAlign: TextAlign.center,)
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
      lastPart = [GridView.count(
        primary: true,
        shrinkWrap: true,
        crossAxisSpacing: 0,
        crossAxisCount: 2,
        children: fileTiles,
      )];
    }
    return ListView(
      shrinkWrap: true,
      primary: false,
      children: <Widget>[
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("שם משתמש", style: TextStyle(fontSize: 24.0),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.person),
            )
          ],
        ),
        Divider(height: 5.0,),
        Row(
          textDirection: TextDirection.rtl,
          children: <Widget>[Text("כל הקבצים שלי", style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),)],
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
              elevation: 0.0,
            )
        ),
      );
    }
  }
}

class FilePage extends StatefulWidget {
  final fileData;

  const FilePage({@required this.fileData});

  @override
  _FilePageState createState() => new _FilePageState();
}

class _FilePageState extends State<FilePage> {
  bool _afterDownload = false;
  String _filePath = '';

  Future<void> _downloadFile() async {
    String tempName = await Api().downloadFile(widget.fileData['pk'], widget.fileData['name']);
    setState(() {
      _filePath = tempName;
      _afterDownload = true;
    });
  }

  Future<void> _openFile() async {
    OpenFile.open(_filePath);
  }

  Widget _getButton() {
    double height = 75.0;
    double width = 300.0;
    Color color = Color(0xffa7ffeb);
    String text = "הורד קובץ";
    var func;

    if (_afterDownload) {
      height = 100.0;
      width = 350.0;
      color = Colors.lightGreenAccent;
      text = "הקובץ ירד!\nפתח אותו";
      func = _openFile;
    }
    else {
      func = _downloadFile;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            height: height,
            width: width,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(50.0)
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(50.0),
              onTap: func,
              child: Center(
                child: Text(text,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }

  Widget _getBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text("קובץ במקצוע ${widget.fileData['subject_name']}",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("שם הקובץ:\n${widget.fileData['name']}",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24.0)),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("תאריך הוספת הקובץ: " + "${widget.fileData['day']}.${widget.fileData['month']}.${widget.fileData['year']}",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 24.0)),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("מידע נוסף על הקובץ:\n${widget.fileData['info']}",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24.0)),
                ),
                Container(height: 100.0,),
                _getButton()
              ]
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4dd0e1),
        elevation: 0.0,
        centerTitle: true,
        title: Text("דף קובץ", textDirection: TextDirection.rtl, style: TextStyle(color: Colors.black, fontSize: 24.0),),
      ),
      body: _getBody()
    );
  }
}