/// This page allows the user to see all his new messages, review them,
/// and thus save new files and tests sent to them by other users.
///
/// Developer: Gefen Hajaj

import 'package:flutter/material.dart';
import 'package:bcademy/api.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bcademy/view_message_page.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage();

  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  Map<String, dynamic> _messages;

  /// Get basic info about all the messages of the user
  void _getAllMessages() async {
    final tempMessages = await Api().getUserAllMessages();
    setState(() {
      _messages = tempMessages;
    });
  }

  void _goToMessagePage(int msgPk) {
     setState(() {
       Navigator.of(context).push(MaterialPageRoute<Null>(
           builder: (BuildContext context) {
             return MessagePage(msgPk: msgPk,);
           }
       ));
     });
  }

  /// Get the page
  Widget _getPage() {
    if (_messages.isEmpty) {
      return Align(
        alignment: Alignment(0, -0.2),
        child: SingleChildScrollView(
          child: Text("אין הודעות חדשות!",
            style: TextStyle(fontSize: 34.0),
            textDirection: TextDirection.rtl,),
        ),
      );
    }
    else {
      List<Widget> messagesWidgets = [];
      for (String pk in _messages.keys) {
        messagesWidgets.add(Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
          child: InkWell(
            onTap: () {_goToMessagePage(int.parse(pk));},
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
                    child: Icon(Icons.mail, size: 40.0,),
                  ),
                  Container(
                    height: 90 / 2,
                    width: MediaQuery.of(context).size.width/1.3,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: AutoSizeText(
                        "${_messages[pk]}", // description pf message
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
        ));
        messagesWidgets.add(Container(color: Colors.grey, height: 0.5,));
      }
      return ListView(children: messagesWidgets,);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_messages == null) {
      _getAllMessages();
      return Scaffold(
        body: Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
        appBar: AppBar(
          title: Text("ההודעות שלי",
            style: TextStyle(color: Colors.black),
            textDirection: TextDirection.rtl,),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
          title: Text("ההודעות שלי (${_messages.keys.length} הודעות חדשות)",
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