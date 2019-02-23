import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bcademy/api.dart';
import 'package:bcademy/structures.dart';

class UploadFilePage extends StatefulWidget {
  const UploadFilePage();

  @override
  _UploadFilePageState createState() => new _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  String _fileName = 'לא נבחר קובץ';
  String _path = '';
  String _info = '';
  bool _isPublic = true;
  int _subjectPk = 4;
  String _extension;
  bool _hasValidMime = false;
  FileType _pickingType;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      try {
        _path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension);
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }

      if (!mounted) return;

      setState(() {
        _fileName = _path != null ? _path.split('/').last : 'סוג קובץ נבחר לא תקין';
      });
    }
  }

  void _uploadFile() {
    Api().uploadFile(_subjectPk, _path, _info, _isPublic);
  }

  List<DropdownMenuItem> _getSubjectsList() {
    List<DropdownMenuItem> allSubjects = [];
    for (Subject subject in Data.allSubjects) {
      allSubjects.add(DropdownMenuItem(child: Text(subject.name), value: subject.pk,));
    }
    return allSubjects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            title: Text("העלאת קובץ"),
            centerTitle: true,
            backgroundColor: Color(0xff29b6f6),
            elevation: 0.0,
          )
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            child: Column(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: DropdownButton(
                    isExpanded: false,
                      hint: Text('מאיפה לבחור את הקובץ?', textDirection: TextDirection.rtl,),
                      value: _pickingType,
                      items: <DropdownMenuItem>[
                        DropdownMenuItem(
                          child: Text('צלם תמונה'),
                          value: FileType.CAMERA,
                        ),
                        DropdownMenuItem(
                          child: Text('בחר תמונה'),
                          value: FileType.IMAGE,
                        ),
                        DropdownMenuItem(
                          child: Text('בחר סרטון'),
                          value: FileType.VIDEO,
                        ),
                        DropdownMenuItem(
                          child: Text('כל הקבצים'),
                          value: FileType.ANY,
                        ),
                        DropdownMenuItem(
                          child: Text('פורמט אחר'),
                          value: FileType.CUSTOM,
                        ),
                      ],
                      onChanged: (value) => setState(() => _pickingType = value)),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 150.0),
                  child: _pickingType == FileType.CUSTOM
                      ? TextFormField(
                    maxLength: 20,
                    autovalidate: true,
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'הכנס סוג קובץ', labelStyle: TextStyle()),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      RegExp reg = RegExp(r'[^a-zA-Z0-9]');
                      if (reg.hasMatch(value)) {
                        _hasValidMime = false;
                        return 'Invalid format';
                      }
                      _hasValidMime = true;
                    },
                  )
                      : Container(height: 0.5,),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.transparent,
                      child: Container(
                        height: 50.0,
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: Color(0xffffeb3b),
                            borderRadius: BorderRadius.circular(50.0)
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50.0),
                          onTap: _openFileExplorer,
                          child: Center(
                            child: Text("פתח את בוחר הקבצים",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0
                              ),
                            ),
                          ),
                        ),
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'שם הקובץ:',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text(
                  _fileName,
                  textAlign: TextAlign.center,
                ),
                Divider(height: 15.0,),
                Container(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 8.0, 25.0, 8.0),
                      child: DropdownButton(
                          value: _subjectPk,
                          items: _getSubjectsList(),
                          onChanged: (value) => setState(() => _subjectPk = value)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 45.0),
                      child: Text('בחר נושא מתאים:', textDirection: TextDirection.rtl, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
                Divider(height: 15.0,),
                Padding(
                  padding: const EdgeInsets.only(right: 60.0, left: 60.0),
                  child: TextFormField(
                    maxLength: 100,
                    decoration: InputDecoration(labelText: '                    מידע נוסף על הקובץ (לא חובה)', labelStyle: TextStyle()),
                    keyboardType: TextInputType.text,
                    textDirection: TextDirection.rtl,
                    onFieldSubmitted: (value) => setState(() => _info = value),
                  ),
                ),
                Divider(height: 15.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(value: _isPublic, onChanged: (value) => setState(() => _isPublic = value)),
                    Text('לפרסם באופן פובמי', textDirection: TextDirection.rtl, style: TextStyle(fontSize: 16.0),)
                  ],
                ),
                Divider(height: 0.0,),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.transparent,
                      child: Container(
                        height: 60.0,
                        width: 220.0,
                        decoration: BoxDecoration(
                            color: Color(0xffffff00),
                            borderRadius: BorderRadius.circular(50.0)
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50.0),
                          onTap: () {_uploadFile();},
                          child: Center(
                            child: Text("העלה קובץ נבחר",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24.0
                              ),
                            ),
                          ),
                        ),
                      )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}