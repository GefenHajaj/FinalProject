/// This page shows information about a file. It allows the user to download
/// the file directly to the phone.
///
/// Developer: Gefen Hajaj

import 'package:flutter/material.dart';
import 'package:bcademy/api.dart';
import 'dart:async';
import 'package:open_file/open_file.dart';

/// The page that shows info about a file and allows to download it
class ViewFilePage extends StatefulWidget {
  final int filePk;

  const ViewFilePage({@required this.filePk});

  @override
  _ViewFilePageState createState() => new _ViewFilePageState();
}

class _ViewFilePageState extends State<ViewFilePage> {
  bool _afterDownload = false;
  String _filePath = '';
  Map _fileData;

  /// Get file data
  void _getFile() async {
    final tempData = await Api().getFile(widget.filePk);
    setState(() {
      _fileData = tempData;
    });
  }

  /// Download the file.
  Future<void> _downloadFile() async {
    String tempName = await Api().downloadFile(widget.filePk,
        _fileData['name']);
    setState(() {
      _filePath = tempName;
      _afterDownload = true;
    });
  }

  /// Open the file - watch in on the phone
  Future<void> _openFile() async {
    OpenFile.open(_filePath);
  }

  /// Get a the button for downloading
  Widget _getButton() {
    double height = 75.0;             // height of button
    double width = 300.0;             // width of button
    Color color = Color(0xffa7ffeb);  // color of button
    String text = "הורד קובץ";        // text of button
    var func;                         // the func that'll execute on press

    // In case the download went successfully (after first press)
    if (_afterDownload && _filePath != '') {
      height = 100.0;
      width = 350.0;
      color = Colors.lightGreenAccent;
      text = "הקובץ ירד!\nפתח אותו";
      func = _openFile;
    }
    // In case download went wrong
    else if (_afterDownload && _filePath == '') {
      height = 100.0;
      width = 350.0;
      color = Colors.redAccent;
      text = "משהו לא הסתדר...\nנסה שוב!";
      func = _downloadFile;
    }
    // In case we did not press the button yet
    else {
      func = _downloadFile;
    }

    // The button widget itself:
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
          elevation: 5.0,
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
              onTap: func,  // on tap execute the function
              child: Center(
                child: Text(text,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
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

  /// Get the body of the page, including button and text
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
                  child: Text("קובץ במקצוע ${_fileData['subject_name']}",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 30.0,
                        fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("שם הקובץ:\n${_fileData['name']}",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24.0)),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("תאריך הוספת הקובץ: " +
                      "${_fileData['day']}."
                          "${_fileData['month']}."
                          "${_fileData['year']}",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24.0)),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("מידע נוסף על הקובץ:\n${_fileData['info']}",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24.0)),
                ),
                Container(height: 20.0,),
                _getButton()
              ]
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_fileData == null) {
      _getFile();
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff4dd0e1),
            elevation: 0.0,
            centerTitle: true,
            title: Text("דף קובץ", textDirection: TextDirection.rtl,
              style: TextStyle(color: Colors.black, fontSize: 24.0),),
          ),
          body: Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          ),
      );
    }
    else {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff4dd0e1),
            elevation: 0.0,
            centerTitle: true,
            title: Text("דף קובץ", textDirection: TextDirection.rtl,
              style: TextStyle(color: Colors.black, fontSize: 24.0),),
          ),
          body: _getBody()
      );
    }
  }
}