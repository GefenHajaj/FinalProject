import 'package:flutter/material.dart';
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
  Map _files;
  String lastSearchTopics = '';
  String lastSearchFiles = '';
  String _search = '';
  int mode = 0; // 0 - topics. 1 - files.
  Map<int, Widget> modeMap = {
    0: Text('חפש נושאים', style: TextStyle(fontFamily: 'Montserrat',),),
    1: Text('חפש קבצים', style: TextStyle(fontFamily: 'Montserrat',),)};

  final _rowHeight = 100.0;
  final _borderRadius = BorderRadius.circular(10.0);
  final _color = Color(0xff80deea);
  final _highlightColor = Colors.lightBlueAccent;
  final _splashColor = Colors.lightBlueAccent;

  /// Search for topics
  Future<void> _getTopicsResults() async {
    var tempResult = await Api().searchTopics(_search);
    setState(() {
      topics = tempResult;
    });
  }
  
  /// Search for files
  Future<void> _getFilesResults() async {
    var tempResult = await Api().searchFiles(_search);
    setState(() {
      _files = tempResult;
    });
  }
  
  /// The main search function
  void _searchResults() {
    if (mode == 0 && lastSearchTopics != _search) {
      _getTopicsResults();
    }
    else if (mode == 1 && lastSearchFiles != _search) {
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

  /// Get a grid of all the files suitable to the search word
  Widget _getFileResultsPage() {
    // In case the user did not search for anything
    if (_search == '' || _files == null) {
      // Text that tells the user to search
      return Expanded(
        child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            children: [
              SizedBox(height: 200.0,),
              Center(child:
              Text("נסה לחפש משהו...",
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28.0),),),
            ]
        ),
      );
    }
    // In case there's nothing suitable for the user's search word
    else if (_files.isEmpty) {
      // Tell the user we could not find anything :(
      return Expanded(
        child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            children: [
              Container(height: 200.0,),
              Center(child:
              Text("לא מצאנו קבצים מתאימים\n😧",
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28.0),),),
            ]
        ),
      );
    }
    // In case we found some results - show them to the user
    else {
      try {
        // Make the list of results (will be used in the grid view):
        final fileTiles = <Widget>[];
        for (String pk in _files.keys) {
          Map file = _files[pk];
          fileTiles.add(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(8.0),
                  child: InkWell(
                    // This function will be called when pressed on a file tile:
                    onTap: () {
                      _goToFilePage(file);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Color(0xff80deea)),
                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        textDirection: TextDirection.rtl,
                        // Some info about the file:
                        children: <Widget>[
                          AutoSizeText("${file['subject_name']}",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,),
                          SizedBox(height: 5.0,),
                          AutoSizeText(file['info'],
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0,),
                          AutoSizeText("${file['day']}."
                              "${file['month']}.${file['year']}",
                            style: TextStyle(fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0,),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0),
                            child: AutoSizeText("${file['name']}",
                              style: TextStyle(fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              minFontSize: 12.0,
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              )
          );
        }
        // Return the grid view
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
      catch (e) {
          return Expanded(
            child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                children: [
                  SizedBox(height: 200.0,),
                  Center(child:
                  Text("הייתה תקלה בקריאת המידע על הקבצים :(",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28.0),),),
                ]
            ),
          );
      }
    }
  }

  Widget _getTopicsPageResults() {
    if (_search == '' || topics == null) {
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
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
            child: Material(
              elevation: 3.0,
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
                        child: Icon(Data.getIcon(topics[pk][1]), size: 40.0,),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: _rowHeight / 2.5,
                            width: MediaQuery.of(context).size.width/1.3,
                            child: Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: AutoSizeText(
                                "${topics[pk][0]}", // name of topic
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 22.0, fontFamily: 'Gisha', fontWeight: FontWeight.bold),
                              ),
                            ),
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
                  _search = input;
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
            elevation: 5.0,
          )
      ),
      body: _getPage(),
    );
  }
}