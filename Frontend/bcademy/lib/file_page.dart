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