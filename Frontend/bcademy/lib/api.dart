/// This file manages the communication of the app with the server.
/// It includes all the functions needed to get/post info from/to the server.
///
/// Developer: Gefen Hajaj

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bcademy/structures.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// This class takes care of communicating with the server.
class Api {
  //static final String _url = "10.0.2.2:8000";  // avd
  //static final String _url = "172.20.10.2:8000";  // through hotspot
  static final String _url = "192.168.1.30:8000";  // for android

  /// Returns all subjects!
  Future<List<Subject>> getAllSubjects() async {
    final url = Uri.http(_url, "/bcademy/subjects/",);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final subjectsMap = json.decode(response.body);
      List<Subject> subjects = [];
      for (String pk in subjectsMap.keys) {
        subjects.add(Subject(pk: int.parse(pk), name: subjectsMap[pk]));
      }
      return subjects;
    } else {
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
      final subject = Data.getSubjectByPk(testInfo['subject_pk']);
      return Test(
          pk: testPk,
          subject: subject,
          dateCreated: DateTime.utc(
              int.parse(dateCreatedUtc[0]),
              int.parse(dateCreatedUtc[1]), int.parse(dateCreatedUtc[2])
          ),
          dateTaken: DateTime.utc(
              int.parse(dateTakenUtc[0]),
              int.parse(dateTakenUtc[1]), int.parse(dateTakenUtc[2])
          ),
          smallTopicsPks: testInfo['small_topics'].cast<int>(),
          icon: Data.getIcon(subject.name),
          millisecondsStudy: testInfo['study_time']
      );

    } else {
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

    } else {
      print(
          "Something went wrong with getting all tests. "
              "Try to check the server.");
      return null;
    }
  }

  Future<Map<String, String>> getSmallTopic(int smallTopicPk) async {
    final url = Uri.http(_url, 'bcademy/smalltopics/$smallTopicPk/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final tempSmallTopic = json.decode(response.body);
      return {'title': tempSmallTopic['title'], 'info': tempSmallTopic['info']};

    } else {
      print(
          "Something went wrong with getting small topic "
              "(pk) $smallTopicPk. Check the server.");
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
    } else {
      print(
          "Something went wrong with getting all topics "
              "for test (pk) $testPk. Check the server.");
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
    } else {
      print("Something went wrong with getting all subject's small topics.");
      return null;
    }
  }

  /// Creating a new test!
  Future<int> createTest(
      int subjectPk, int year, int month, int day, List smallTopicsList) async {
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
    } else {
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
    } else {
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
    } else {
      print("Something went wrong with getting all questions for test $testPk");
      return null;
    }
  }

  /// Uploading a new file to server
  Future<void> uploadFile(
      int subjectPk, String path, String info, bool isPublic) async {
    final url = Uri.http(_url, '/bcademy/${Data.userPk}/$subjectPk/upload/');
    var request = http.MultipartRequest("POST", url);
    print((path));
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      path,
    ));
    request.fields['info'] = info;
    request.fields['is_public'] = isPublic ? 'True' : 'False';
    request.fields['file_name'] = path.split('/').last;
    print(path.split('/').last);
    request.send().then((response) {
      if (response.statusCode == 200) print("Uploaded!");
    });
  }

  /// Getting info of all files of a specific user
  Future<Map> getUserFiles() async {
    final url = Uri.http(_url, '/bcademy/allfiles/${Data.userPk}/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(
          "Something went wrong with getting all files of user ${Data.userPk}");
      return null;
    }
  }

  /// Download a file to the phone
  Future<String> downloadFile(filePk, fileName) async {
    try {
      // Get all file info (bytes) from the server
      final url = Uri.http(_url, '/bcademy/download/$filePk/');
      var response = await http.get(url);

      // Make sure we got an OK
      if (response.statusCode == 200) {
        var bytes = response.bodyBytes;  // file data
        String dir = (await getExternalStorageDirectory()).path + '/Download';
        File file = new File('$dir/$fileName');
        await file.writeAsBytes(bytes);  // write to the file
        return '$dir/$fileName';         // return the path to the new file
      } else {
        print("Something went wrong getting the file $fileName.");
        print(response.body);
        return '';
      }
    } catch (e) {  // in case of error
      print("Something went wrong with saving the file $fileName. " +
          e.toString());
      return '';
    }
  }

  /// Search for small topics and get results
  Future<Map> searchTopics(String search) async {
    final url = Uri.http(_url, '/bcademy/search/topics/');
    var response = await http.post(url, body: json.encode({'search': search}));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Something went wrong with searching small topics.');
      return null;
    }
  }

  /// Search for files and docs on the cloud and get results -
  /// your files and others'!
  Future<Map> searchFiles(String search) async {
    final url = Uri.http(_url, '/bcademy/search/files/');
    var response = await http.post(url, body: json.encode({'search': search}));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Something went wrong with searchong for files");
      return null;
    }
  }

  /// Create new user
  /// return 1 for success. return 0 for failure.
  Future<int> register(Map userInfo, bool signIn) async {
    var url;
    signIn
        ? url = Uri.http(_url, 'bcademy/users/signin/')
        : url = Uri.http(_url, 'bcademy/users/create/');
    var response = await http.post(url, body: json.encode(userInfo));

    if (response.statusCode == 200) {
      var info = json.decode(response.body);
      Data.userName = info['name'];
      Data.userPk = info['pk'];
      return 1;
    } else {
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
    } else {
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
    } else {
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
    } else {
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
    await http.post(url, body: json.encode(postBody));
  }

  /// Delete a test
  Future<void> deleteTest(int testPk) async {
    final url = Uri.http(_url, 'bcademy/tests/delete/$testPk/${Data.userPk}/');
    var response = await http.get(url);
    if (response.statusCode != 200) {
      print('Could not delete test $testPk.');
    }
  }

  /// Delete a file
  Future<void> deleteFile(int filePk) async {
    final url = Uri.http(_url, 'bcademy/files/delete/$filePk/${Data.userPk}/');
    var response = await http.get(url);
    if (response.statusCode != 200) {
      print('Could not delete file $filePk.');
    }
  }

  /// Update the time that was studied for a test
  Future<void> updateTestStudyTime(int milliseconds, int pk) async {
    final url = Uri.http(_url, 'bcademy/tests/updatetime/');
    final postBody = {'pk': pk, 'time': milliseconds};
    await http.post(url, body: json.encode(postBody));
  }

  /// Search for existing users
  Future<Map> searchUsers(String search) async {
    final url = Uri.http(_url, '/bcademy/search/users/');
    var response = await http.post(url, body: json.encode({'search': search}));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Something went wrong with searchong for users");
      return null;
    }
  }

  /// Add a test to a user list
  Future<void> addTestToUser(int testPk) async {
    final url = Uri.http(
        _url, '/bcademy/addtesttouser/${Data.userPk}/$testPk/');
    var response = await http.get(url);
    if (response.statusCode != 200) {
      print("Something went wrong with adding test to user");
    }
  }

  /// Add a test to a user list
  Future<void> addDicToUser(int docPk) async {
    final url = Uri.http(
        _url, '/bcademy/adddoctouser/${Data.userPk}/$docPk/');
    var response = await http.get(url);
    if (response.statusCode != 200) {
      print("Something went wrong with adding test to user");
    }
  }

  /// Create a new message
  Future<void> createMessage(int receiverPk, bool isTest,
      int contentPk, String text) async {
    final url = Uri.http(_url, '/bcademy/newmsg/');
    final msgInfo = {
      'receiver_pk': receiverPk,
      'sender_name': Data.userName,
      'is_test': isTest,
      'content_pk': contentPk,
      'text': text
    };
    final response = await http.post(url, body: json.encode(msgInfo));
    if (response.statusCode != 200) {
      print("Something went wrong with creating a message");
    }
  }

  /// Delete a message
  Future<void> deleteMessage(int msgPk) async {
    final url = Uri.http(_url, '/bcademy/deletemsg/$msgPk/');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      print('Could not delete message $msgPk.');
    }
  }

  /// Get all messages of a user
  Future<Map> getUserAllMessages() async {
    final url = Uri.http(_url, '/bcademy/users/${Data.userPk}/getmsgs/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Something went wrong with getting user messages.');
      return null;
    }
  }

  /// Get all messages of a user
  Future<Map> getMessage(int msgPk) async {
    final url = Uri.http(_url, '/bcademy/getmsg/$msgPk/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Something went wrong with getting message $msgPk.');
      return null;
    }
  }
}

/// This class saves data that's important for the entire app.
class Data {
  static List<Subject> allSubjects;
  static String userName;
  static int userPk;

  /// This function should be called when first opening the app.
  static void startApp() async {
    final api = Api();
    Data.allSubjects = await api.getAllSubjects();
  }

  /// Get a subject by its pk.
  static getSubjectByPk(int pk) {
    for (Subject subject in allSubjects) {
      if (subject.pk == pk) return subject;
    }
    return null;
  }

  /// Get a suitable icon according to the subject name
  static IconData getIcon(String subject) {
    IconData icon;
    switch (subject) {
      case "אזרחות":
        icon = Icons.group;
        break;
      case "היסטוריה":
        icon = Icons.account_balance;
        break;
      case "מתמטיקה":
        icon = Icons.iso;
        break;
      case "פיזיקה":
        icon = Icons.lightbulb_outline;
        break;
      case "מדעי המחשב":
        icon = Icons.keyboard;
        break;
      case "סייבר":
        icon = Icons.computer;
        break;
      default:
        icon = Icons.grade;
    }
    return icon;
  }
}
