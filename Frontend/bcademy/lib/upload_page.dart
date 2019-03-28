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

  var _color = Color(0xff81d4fa);
  var _text = "העלה קובץ נבחר";
  var _height = 70.0;
  var _width = 240.0;
  var _size = 24.0;

  final Color _buttonColor = Color(0xff81d4fa);
  final Color _warningColor = Colors.red;
  final String _buttonText = "העלה קובץ נבחר";
  final String _warningText = "לא נבחר קובץ!";
  final double _buttonHeight = 70.0;
  final double _warningHeight = 90.0;
  final double _buttonWidth = 240.0;
  final double _warningWidth = 250.0;
  final double _fontSize = 24.0;
  final double _warningFont = 28.0;

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
        _color = _buttonColor;
        _height = _buttonHeight;
        _width = _buttonWidth;
        _size = _fontSize;
        _text = _buttonText;
      });
    }
  }

  void _uploadFile() {
    if (_path != '') {
      if (_info == '') {
        if (_pickingType == FileType.IMAGE || _pickingType == FileType.CAMERA)
          _info = "תמונה";
        else if (_pickingType == FileType.VIDEO)
          _info = "סרטון";
        else
          _info = "קובץ";
      }
      Api().uploadFile(_subjectPk, _path, _info, _isPublic);
      setState(() {
        _text = "הקובץ עלה!\nהעלה קובץ נוסף";
        _color = Color(0xff32CD32);
        _height = _warningHeight;
        _width = _warningWidth;
        _path = '';
        _info = '';
        _fileName = 'לא נבחר קובץ';
      });
    }
    else {
      setState(() {
        _color = _warningColor;
        _height = _warningHeight;
        _width = _warningWidth;
        _size = _warningFont;
        _text = _warningText;
      });
    }
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
                            color: Color(0xffb3e5fc),
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
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      maxLength: 100,
                      decoration: InputDecoration(labelText: 'מידע נוסף על הקובץ (לא חובה)', labelStyle: TextStyle()),
                      keyboardType: TextInputType.text,
                      textDirection: TextDirection.rtl,
                      onFieldSubmitted: (value) => setState(() => _info = value),
                    ),
                  ),
                ),
                Divider(height: 15.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(value: _isPublic, onChanged: (value) => setState(() => _isPublic = value)),
                    Text('לפרסם באופן פומבי', textDirection: TextDirection.rtl, style: TextStyle(fontSize: 16.0),)
                  ],
                ),
                Divider(height: 20.0,),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.transparent,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        height: _height,
                        width: _width,
                        decoration: BoxDecoration(
                            color: _color,
                            borderRadius: BorderRadius.circular(50.0)
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50.0),
                          onTap: () {_uploadFile();},
                          child: Center(
                            child: Text(_text,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: _size
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