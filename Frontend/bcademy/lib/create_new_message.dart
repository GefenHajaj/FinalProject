/// This page allows the user to create a new message
///
/// developer: Gefen Hajaj

import 'package:flutter/material.dart';
import 'package:bcademy/api.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FindUserPage extends StatefulWidget {
  final int contentPk;
  final bool isTest;
  final String subject;

  const FindUserPage({
    @required this.contentPk,
    @required this.isTest,
    @required this.subject
  });

  @override
  _FindUserPageState createState() => _FindUserPageState();
}

class _FindUserPageState extends State<FindUserPage> {
  String _search = '';
  Map _users;

  void _searchResults() async {
    var tempResult = await Api().searchUsers(_search);
    setState(() {
      _users = tempResult;
    });
  }

  void _goToCreateMessagePage(int userPk, String userName) {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return CreateNewMessagePage(contentPk: widget.contentPk,
                isTest: widget.isTest,
                receiverPk: userPk,
                receiverName: userName,
                subject: widget.subject);
          }
      ));
    });
  }

  Widget _getUsersResults() {
    if (_search == '' || _users == null) {
      return Expanded(
        child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            children: [
              Container(height: 150.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(
                  "חפשו משתמש אליו תרצו לשלוח!",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0),),),
              ),
            ]
        ),
      );
    }
    else {
      if (_users.isEmpty) {
        return Expanded(
          child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              children: [
                Container(height: 200.0,),
                Center(child: Text(
                  "לא מצאנו משתמשים מתאימים",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28.0),),),
              ]
          ),
        );
      }
      else {
        var listOfResults = <Widget>[];
        for (String pk in _users.keys) {
          listOfResults.add(Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
            child: InkWell(
              onTap: () {_goToCreateMessagePage(int.parse(pk), _users[pk]);},
              highlightColor: Colors.grey,
              splashColor: Colors.grey,
              child: Container(
                height: 90,
                child: Row(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Icon(Icons.person, size: 40.0,),
                    ),
                    Container(
                      height: 90 / 2,
                      width: MediaQuery.of(context).size.width/1.3,
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: AutoSizeText(
                          "${_users[pk]}", // name of user
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 22.0,
                              fontFamily: 'Gisha',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          );
          listOfResults.add(Container(color: Colors.grey, height: 0.5,));
        }
        return Expanded(
          child: ListView(
            shrinkWrap: true,
            primary: true,
            children: listOfResults,
          ),
        );
      }
    }
  }

  Widget _getPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'השם של המשתמש',
                labelText: 'למי לשלוח?',
              ),
              textDirection: TextDirection.rtl,
              onFieldSubmitted: (input) {
                setState(() {
                  _search = input;
                  _searchResults();
                });
              },
            ),
          ),
        ),
        _getUsersResults()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffebee),
        appBar: AppBar(
          title: Text("למי לשלוח את ההודעה?",
            style: TextStyle(color: Colors.black),
          textDirection: TextDirection.rtl,),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        body: _getPage()
    );
  }
}



class CreateNewMessagePage extends StatefulWidget {
  final int contentPk;
  final bool isTest;
  final int receiverPk;
  final String receiverName;
  final String subject;

  const CreateNewMessagePage({
    @required this.contentPk,
    @required this.isTest,
    @required this.receiverPk,
    @required this.receiverName,
    @required this.subject
    });

  @override
  _CreateNewMessagePageState createState() => _CreateNewMessagePageState();
}

class _CreateNewMessagePageState extends State<CreateNewMessagePage> {
  String _text = '';

  void _sendMessage() async {
    String msgText = _text != '' ? _text :
    (widget.isTest ? "היי! שיתפתי איתך מבחן!" : "היי! שיתפתי איתך קובץ!");
    await Api().createMessage(widget.receiverPk, widget.isTest,
        widget.contentPk, msgText);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

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
                  "שתף ${widget.isTest ? "מבחן" : "קובץ"}"
                      " במקצוע ${widget.subject}",
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
                  "נמען: ${widget.receiverName}",
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
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    style: TextStyle(fontSize: 18),
                    maxLength: 1000,
                    decoration: InputDecoration(
                        labelText: 'תוכן ההודעה',
                        labelStyle: TextStyle(fontSize: 18.0),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)
                        )
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    textDirection: TextDirection.rtl,
                    onChanged: (value) => setState(() => _text = value),
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Material(
                    // elevation: 10.0,
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.transparent,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        height: 75,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.cyan,
                            borderRadius: BorderRadius.circular(50.0)
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50.0),
                          onTap: () {_sendMessage();},
                          child: Center(
                            child: Text("שליחה",
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24
                              ),
                            ),
                          ),
                        ),
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffebee),
        appBar: AppBar(
          title: Text("שליחת הודעה!",
            textDirection: TextDirection.rtl,
            style: TextStyle(color: Colors.black),),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        body: _getPage()
    );
  }
}