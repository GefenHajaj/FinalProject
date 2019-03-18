import 'package:flutter/material.dart';
import 'package:bcademy/structures.dart';
import 'package:bcademy/api.dart';

class StudyPage extends StatefulWidget {
  final Test test;

  const StudyPage({
    @required this.test
  }): assert(test != null);

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  Map<String, String> smallTopics;

  Future<void> _getAllSmallTopics() async {
    final tempSmallTopics = await Api().getAllSmallTopics(widget.test.pk);
    setState(() {
      smallTopics = tempSmallTopics;
    });
  }

  /// Gets a list of all the info
  Widget _getSummary() {
    List<String> titles = [];
    if (smallTopics != null) {
      for (String title in smallTopics.keys) {
        titles.add(title);
      }
      List<String> info = [];
      for (String data in smallTopics.values) {
        info.add(data);
      }
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Column(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(titles[index], textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 24.0),),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(info[index], textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 18.0),),
                )
              ],
            );
          },
          itemCount: titles.length,
        ),
      );
    }
    else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (smallTopics == null) {
      _getAllSmallTopics();
      return Container(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(),
      );
    }
    else {
      return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Color(0xff00acc1),
            centerTitle: true,
            title: Text("לומדים למבחן ב${widget.test.subject.name}",
              style: TextStyle(fontSize: 22.0,),),
          ),
          body: _getSummary()
      );
    }
  }
}