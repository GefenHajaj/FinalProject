import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:bcademy/structures.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

/// This class takes care of communicating with the server.
class Api {
  static final HttpClient _httpClient = HttpClient();
  static final String _url = "10.0.2.2:8000";

  /// Returns all subjects!
  Future<List<Subject>> getAllSubjects() async {
    final url = Uri.http(_url, "/bcademy/subjects/");
    final  response = await http.get(url);
    if (response.statusCode == 200) {
      final subjectsMap = json.decode(response.body);
      List<Subject> subjects = [];
      for (String pk in subjectsMap.keys) {
        subjects.add(Subject(pk: int.parse(pk), name: subjectsMap[pk]));
      }
      return subjects;
    }
    else {
      print("Error retreiving all subjects. Check the server...");
      return null;
    }
  }
  
  /// Returns a Test object of the specific pk.
  Future<Test> getTest(int testPk) async {
    final url = Uri.http(_url, '/bcademy/tests/$testPk/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final testInfo = json.decode(response.body);
      final dateCreatedUtc = testInfo['date_created'].split("-");
      final dateTakenUtc = testInfo['date_taken'].split("-");
      return Test(
          pk: testPk,
          subject: Data.getSubjectByPk(int.parse(testInfo['subject_pk'])),
          dateCreated: DateTime.utc(
              int.parse(dateCreatedUtc[0]), int.parse(dateCreatedUtc[1]), int.parse(dateCreatedUtc[2])),
          dateTaken: DateTime.utc(
              int.parse(dateTakenUtc[0]), int.parse(dateTakenUtc[1]), int.parse(dateTakenUtc[2])),
          smallTopicsPks: testInfo['small_topics'].cast<int>(),
          icon: Icons.grade
      );
    }
    else {
      print("Error getting test (pk = $testPk. Try to check the server.");
      return null;
    }
  }

  /// Returns all the tests for a given user.
  Future<List<Test>> getAllTests() async {
    final url = Uri.http(_url, '/bcademy/users/futuretests/${Data.userPk}/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final allTests = json.decode(response.body);
      List<Test> tests = [];
      for (String pk in allTests.keys) {
        tests.add(await getTest(int.parse(pk)));
      }
      return tests;
    }
    else {
      print("Something went wrong with getting all tests. Try to check the server.");
      return null;
    }
  }
  
  Future<Map<String, String>> getSmallTopic(int smallTopicPk) async {
    final url = Uri.http(_url, 'bcademy/smalltopics/$smallTopicPk/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final tempSmallTopic = json.decode(response.body);
      return {'title': tempSmallTopic['title'], 'info': tempSmallTopic['info']};
    }
    else {
      print("Something went wrong with getting small topic (pk) $smallTopicPk. Check the server.");
      return null;
    }
  }

  /// Returns all the small topics of a given test.
  Future<Map<String, String>> getAllSmallTopics(int testPk) async {
    final url = Uri.http(_url, '/bcademy/tests/$testPk/smalltopics/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final allSmallTopics = json.decode(response.body);
      Map<String, String> smallTopics = {};
      for (String pk in allSmallTopics.keys) {
        final tempSmallTopic = await getSmallTopic(int.parse(pk));
        smallTopics[tempSmallTopic['title']] = tempSmallTopic['info'];
      }
      return smallTopics;
    }
    else {
      print("Something went wrong with getting all topics for test (pk) $testPk. Check the server.");
      return null;
    }
  }

  /// Returns all the small topics of a given subject
  Future<List> getAllSubjectSmallTopics(int subjectPk) async {
    final url = Uri.http(_url, '/bcademy/subjects/$subjectPk/smalltopics/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final allSmallTopics = json.decode(response.body);
      List smallTopicsInfo = [];
      for (String pk in allSmallTopics.keys) {
        final tempTopicList = [int.parse(pk), allSmallTopics[pk]];
        smallTopicsInfo.add(tempTopicList);
      }
      return smallTopicsInfo;
    }
    else {
      print("Something went wrong with getting all subject's small topics.");
      return null;
    }
  }

  /// Creating a new test!
  Future<int> createTest(int subjectPk, int year, int month, int day, List smallTopicsList) async {
    final url = Uri.http(_url, '/bcademy/tests/create/');
    final testInfo = {
      'subject': subjectPk,
      'user': Data.userPk,
      'year': year,
      'month': month,
      'day': day,
      'small_topics': smallTopicsList
    };
    final response = await http.post(url, body: json.encode(testInfo));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    else {
      print("Sonething went wrong with creating that test...");
      return -1;
    }
  }
  
  Future<List> getQuestion(int qPk) async {
    final url = Uri.http(_url, '/bcademy/questions/$qPk/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final info = json.decode(response.body);
      final answer = [
        info['text'],
        [1, info['answer1']],
        [2, info['answer2']],
        [3, info['answer3']],
        [4, info['answer4']]
      ];
      return answer;
    }
    else {
      print("Something went wrong with getting question $qPk");
      return null;
    }
  }

  Future<List> getTestAllQuestions(int testPk) async {
    final url = Uri.http(_url, '/bcademy/tests/$testPk/questions/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final info = json.decode(response.body);
      List allQuestions = [];
      for (String pk in info.keys) {
        allQuestions.add(await getQuestion(int.parse(pk)));
      }
      return allQuestions;
    }
    else {
      print("Something went wrong with getting all questions for test $testPk");
      return null;
    }
  }

  /// Uploading a new file to server
  Future<void> uploadFile(int subjectPk, String path, String info, bool isPublic) async {
    final url = Uri.http(_url, '/bcademy/${Data.userPk}/$subjectPk/upload/');
    var request = http.MultipartRequest("POST", url);
    print((path));
    request.files.add(await http.MultipartFile.fromPath('file', path,));
    request.fields['info'] = info;
    request.fields['is_public'] = isPublic ? 'True' : 'False';
    request.fields['file_name'] = path.split('/').last;
    print(path.split('/').last);
    request.send().then((response) {
      if (response.statusCode == 200)
        print("Uploaded!");
    });
  }

  /// Getting info of all files of a specific user
  Future<Map> getUserFiles() async {
    final url = Uri.http(_url, '/bcademy/allfiles/${Data.userPk}/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    else {
      print("Something went wrong with getting all files of user ${Data.userPk}");
      return null;
    }
  }

  /// Download a file to the phone
  Future<String> downloadFile(filePk, fileName) async {
    final url = Uri.http(_url, '/bcademy/download/$filePk/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var fileNameParts = fileName.split(".");
      fileName = fileNameParts[0] + (Data.fileNum++).toString() + "." + fileNameParts[1];
      var bytes = response.bodyBytes;
      String dir = (await getExternalStorageDirectory()).path + '/Download';
      File file = new File('$dir/$fileName');
      await file.writeAsBytes(bytes);
      print("Check for hello!");
      return '$dir/$fileName';
    }
    else {
      print("Something ent wrong downloading the file.");
      return '';
    }
  }

  /// Search for small topics and get results
  Future<Map> searchTopics(String search) async {
    final url = Uri.http(_url, '/bcademy/search/topics/');
    var response = await http.post(url, body: json.encode({'search': search}));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    else {
      print('Something went wrong with searching small topics.');
      return null;
    }
  }

  /// Search for files and docs on the cloud and get results - your files and others'!
  Future<Map> searchFiles(String search) async {
    final url = Uri.http(_url, '/bcademy/search/files/');
    var response = await http.post(url, body: json.encode({'search': search}));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    else {
      print("Something went wrong with searchong for files");
      return null;
    }
  }
  
  /// Create new user
  /// return 1 for success. return 0 for failure.
  Future<int> register(Map userInfo, bool signIn) async {
    var url;
    signIn ? url = Uri.http(_url, 'bcademy/users/signin/') : url = Uri.http(_url, 'bcademy/users/create/');
    var response = await http.post(url, body: json.encode(userInfo));

    if (response.statusCode == 200) {
      var info = json.decode(response.body);
      Data.userName = info['name'];
      Data.userPk = info['pk'];
      return 1;
    }
    else {
      print("Could not create user");
      return 0;
    }
  }
  
  /// A function that gets all the quizzes for a user
  Future<Map> getQuizzes() async {
    final url = Uri.http(_url, 'bcademy/quiz/user/${Data.userPk}/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    else {
      print("could not get the quiz for the user.");
      return null;
    }
  }

  /// Gets all the info about a specific quiz.
  Future<Map> getQuiz(int quizPk) async {
    final url = Uri.http(_url, 'bcademy/quiz/$quizPk/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    else {
      print("could not get quiz $quizPk.");
      return null;
    }
  }

  /// Gets all the questions of a specific quiz.
  Future<List> getQuizQuestions(int quizPk) async {
    final url = Uri.http(_url, 'bcademy/quiz/$quizPk/questions/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    else {
      print("could not get quiz $quizPk questions.");
      return null;
    }
  }

  /// Set new scores for a quiz.
  Future<void> setQuizNewScore(int quizPk, usersPks, scores) async {
    final url = Uri.http(_url, 'bcademy/quiz/$quizPk/setscore/');
    var postBody = {'users': usersPks, 'scores': scores};
    http.post(url, body: json.encode(postBody));
  }

  /// Tell the server a specific user has played a specific quiz.
  Future<void> setQuizUser(int quizPk) async {
    final url = Uri.http(_url, 'bcademy/quiz/$quizPk/adduser/');
    var postBody = {'user_pk': Data.userPk};
    http.post(url, body: json.encode(postBody));
  }
}


/// This class saves data that's important for the entire app.
class Data {
  static List<Subject> allSubjects;
  static int fileNum = 0;
  static String userName = "גפן"; // remember to change this
  static int userPk = 1; // remember to change

  /// This function should be called when first opening the app.
  static void startApp() async {
    final api = Api();
    Data.allSubjects = await api.getAllSubjects();
  }

  /// Get a subject by its pk.
  static getSubjectByPk(int pk) {
    for (Subject subject in allSubjects) {
      if (subject.pk == pk)
        return subject;
    }
    return null;
  }
}