import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bcademy/api.dart';
import 'package:bcademy/structures.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage();

  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map files; // {pk: {info: ..., date_created,}, pk2: {}, }

  Future<void> _getAllFiles() async {
    final filesInfo = await Api().getUserFiles();
    setState(() {
      files = filesInfo;
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
    for (String pk in files.keys) {
      fileTiles.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {_goToFilePage(files[pk]);},
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Colors.blue),
              child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  AutoSizeText("קובץ במקצוע:\n ${files[pk]['subject_name']}", textDirection: TextDirection.rtl, style: TextStyle(fontSize: 24.0), textAlign: TextAlign.center,),
                  Container(height: 5.0,),
                  AutoSizeText(files[pk]['info'], style: TextStyle(fontSize: 20.0),),
                  Container(height: 5.0,),
                  AutoSizeText("${files[pk]['day']}.${files[pk]['month']}.${files[pk]['year']}", style: TextStyle(fontSize: 16.0),)
                ],
              )),
            ),
          ),
        )
      );
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
        GridView.count(
          primary: false,
          shrinkWrap: true,
          crossAxisSpacing: 0,
          crossAxisCount: 2,
          children: fileTiles,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (files == null) {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("דף קובץ"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("דף בו תוכלו להוריד את הקובץ הנבחר", style: TextStyle(fontSize: 36.0), textDirection: TextDirection.rtl, textAlign: TextAlign.center,),
      ),
    );
  }
}