import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bcademy/api.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bcademy/file_page.dart';
import 'package:bcademy/study_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage();

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map topics;
  Map files;
  String lastSearchTopics = '';
  String lastSearchFiles = '';
  String search = '';
  int mode = 0; // 0 - topics. 1 - files.
  Map<int, Widget> modeMap = {0: Text('חפש נושאים'), 1: Text('חפש קבצים')};

  final _rowHeight = 100.0;
  final _borderRadius = BorderRadius.circular(20.0);
  final _color = Color(0xff80deea);
  final _highlightColor = Colors.lightBlueAccent;
  final _splashColor = Colors.lightBlueAccent;

  /// Search for topics
  Future<void> _getTopicsResults() async {
    var tempResult = await Api().searchTopics(search);
    setState(() {
      topics = tempResult;
    });
  }
  
  /// Search for files
  Future<void> _getFilesResults() async {
    var tempResult = await Api().searchFiles(search);
    setState(() {
      files = tempResult;
    });
  }
  
  /// The main search function
  void _searchResults() {
    if (mode == 0 && lastSearchTopics != search) {
      _getTopicsResults();
    }
    else if (mode == 1 && lastSearchFiles != search) {
      _getFilesResults();
    }
  }
  
  /// Go the the page where you can view and download a file
  void _goToFilePage(Map fileData) {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return FilePage(fileData: fileData);
          }
      ));
    });
  }

  void _goToStudyPage(int wantedTopicPk) {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return ViewTopic(topicPk: wantedTopicPk);
          }
      ));
    });
  }

  Widget _getFileResultsPage() {
    if (search == '' || files == null) {
      return Expanded(
        child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            children: [
              Container(height: 200.0,),
              Center(child: Text("נסה לחפש משהו...", textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 28.0),),),
            ]
        ),
      );
    }
    else {
      final fileTiles = <Widget>[];
      for (String pk in files.keys) {
        fileTiles.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  _goToFilePage(files[pk]);},
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Color(0xff80deea)),
                  child: Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      AutoSizeText("${files[pk]['subject_name']}", textDirection: TextDirection.rtl, style: TextStyle(fontSize: 30.0), textAlign: TextAlign.center,),
                      Container(height: 5.0,),
                      AutoSizeText(files[pk]['info'], textDirection: TextDirection.rtl, style: TextStyle(fontSize: 20.0),),
                      Container(height: 5.0,),
                      AutoSizeText("${files[pk]['name']}", style: TextStyle(fontSize: 14.0), textAlign: TextAlign.center,),
                      Container(height: 8.0,),
                      AutoSizeText("${files[pk]['day']}.${files[pk]['month']}.${files[pk]['year']}", style: TextStyle(fontSize: 14.0),),
                    ],
                  )),
                ),
              ),
            )
        );
      }

      if (fileTiles.isEmpty) {
        return Expanded(
          child: ListView(
              physics: const NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            children: [
              Container(height: 200.0,),
              Center(child: Text("לא מצאנו קבצים מתאימים\n😧", textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 28.0),),),
            ]
          ),
        );
      }
      else {
        return Expanded(
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
        );
      }
    }
  }

  Widget _getTopicsPageResults() {
    if (search == '' || topics == null) {
      return Expanded(
        child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            children: [
              Container(height: 200.0,),
              Center(child: Text("נסה לחפש משהו...", textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 28.0),),),
            ]
        ),
      );
    }
    else {
      if (topics.isEmpty) {
        return Expanded(
          child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              children: [
                Container(height: 200.0,),
                Center(child: Text("לא מצאנו נושאים מתאימים\n😧", textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 28.0),),),
              ]
          ),
        );
      }
      else {
        var listOfResults = <Widget>[];
        for (String pk in topics.keys) {
          listOfResults.add(Padding(
            padding: const EdgeInsets.all(10.0),
            child: Material(
              color: _color,
              borderRadius: _borderRadius,
              child: InkWell(
                borderRadius: _borderRadius,
                onTap: () {_goToStudyPage(int.parse(pk));},
                highlightColor: _highlightColor,
                splashColor: _splashColor,
                child: Container(
                  height: _rowHeight,
                  child: Row(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Icon(Icons.star, size: 40.0,),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          AutoSizeText(
                            "${topics[pk][0]}",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22.0, fontFamily: 'Gisha'),
                          ),
                          Text(
                            "מקצוע: ${topics[pk][1]}",
                            style: TextStyle(fontSize: 16.0),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          );
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
                hintText: 'מילת החיפוש',
                labelText: 'מה תרצה לחפש?',
              ),
              textDirection: TextDirection.rtl,
              onFieldSubmitted: (input) {
                setState(() {
                  search = input;
                  _searchResults();
                });
                },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: CupertinoSegmentedControl<int>(
            children: modeMap,
            onValueChanged: (int newValue) {setState(() {
              mode = newValue;
              _searchResults();
            });},
            selectedColor: Colors.blue,
            groupValue: mode,
          ),
        ),
        mode == 0 ? _getTopicsPageResults() : _getFileResultsPage(),
      ],
    );
  }

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
      body: _getPage(),
    );
  }
}