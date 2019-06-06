/// This page allows the user to view a specific message and save/delete its
/// content.
///
/// Developer: Gefen Hajaj

import 'package:flutter/material.dart';
import 'package:bcademy/api.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bcademy/view_file_page.dart';
import 'package:bcademy/view_test_page.dart';

class MessagePage extends StatefulWidget {
  final int msgPk;

  const MessagePage({@required this.msgPk});

  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  Map _msgInfo;

  /// Get all info of the message
  void _getMessage() async {
    final tempMessage = await Api().getMessage(widget.msgPk);
    setState(() {
      _msgInfo = tempMessage;
    });
  }

  /// Accept content
  void _acceptContent() async {
    if (_msgInfo['is_test']) {
      await Api().addTestToUser(_msgInfo['content_pk']);
    }
    else {
      await Api().addDocToUser(_msgInfo['content_pk']);
    }
    await Api().deleteMessage(widget.msgPk);
    Navigator.of(context).pop();
  }

  /// Do not accept content
  void _doNotAcceptContent() async {
    await Api().deleteMessage(widget.msgPk);
    Navigator.of(context).pop();
  }

  /// View the content
  void _viewContent() {
    if (_msgInfo['is_test']) {
      setState(() {
        Navigator.of(context).push(MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return ViewTestPage(testPk: _msgInfo['content_pk']);
            }
        ));
      });
    }
    else {
      setState(() {
        Navigator.of(context).push(MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return ViewFilePage(filePk: _msgInfo['content_pk'],);
            }
        ));
      });
    }
  }

  /// Get the page of the message
  Widget _getPage() {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          child: Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 8.0),
                child: Text(
                  "נשלח על ידי: ${_msgInfo['sender_name']}",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 7.0,),
              Container(color: Colors.grey, height: 1.0,),
              SizedBox(height: 7.0,),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "התוכן: ${_msgInfo['is_test'] ? "מבחן" : "קובץ"}"
                      " ב${_msgInfo['subject']}",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 7.0,),
              Container(color: Colors.grey, height: 1.0,),
              SizedBox(height: 7.0,),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "תוכן ההודעה שנשלחה ב-${"${_msgInfo['day']}."
                      "${_msgInfo['month']}."
                      "${_msgInfo['year']}"}",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  _msgInfo['text'],
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 7.0,),
              Container(color: Colors.grey, height: 1.0,),
              SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                child: Material(
                  elevation: 3.0,
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(10.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () {_viewContent();},
                    highlightColor: Colors.blue,
                    splashColor: Colors.blue,
                    child: Container(
                      height: 90.0,
                      child: Row(
                        textDirection: TextDirection.rtl,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0,
                                right: 8.0),
                            child: Icon(Data.getIcon(_msgInfo['subject']),
                              size: 40.0,),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                height: 90.0 / 2.5,
                                width: MediaQuery.of(context).size.width/1.3,
                                child: Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: AutoSizeText(
                                    "${_msgInfo['is_test'] ? 'מבחן' :
                                    'קובץ'} חדש!", // what is it
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontFamily: 'Gisha',
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "מקצוע: ${_msgInfo['subject']}",
                                style: TextStyle(fontSize: 16.0),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.0,),
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0, 10.0, 0),
                    child: Material(
                      elevation: 3.0,
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.0),
                        onTap: () {_acceptContent();},
                        highlightColor: Colors.cyan,
                        splashColor: Colors.cyan,
                        child: Container(
                          height: 70.0,
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: Center(
                            child: Text(
                              "שמירה",
                              style: TextStyle(fontSize: 30.0),
                            ),
                          )
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: Material(
                      elevation: 3.0,
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.0),
                        onTap: () {_doNotAcceptContent();},
                        highlightColor: Colors.redAccent,
                        splashColor: Colors.redAccent,
                        child: Container(
                          height: 70.0,
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: Center(
                            child: Text(
                              "מחיקה",
                              style: TextStyle(fontSize: 30.0),
                            ),
                          )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_msgInfo == null) {
      _getMessage();
      return Scaffold(
        body: Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
        appBar: AppBar(
          title: Text("צפייה בהודעה",
            style: TextStyle(color: Colors.black),
            textDirection: TextDirection.rtl,),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
      );
    }
    else if (_msgInfo.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("צפייה בהודעה",
            style: TextStyle(color: Colors.black),
            textDirection: TextDirection.rtl,),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        body: Center(child: Text("הודעה זו נצפתה ונענתה!",
          style: TextStyle(fontSize: 30),
          textDirection: TextDirection.rtl,),),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
          title: Text("צפייה בהודעה",
            style: TextStyle(color: Colors.black),
            textDirection: TextDirection.rtl,),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        body: _getPage(),
      );
    }
  }
}