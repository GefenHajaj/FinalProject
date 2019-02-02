import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:bcademy/structures.dart';

/// This class takes care of communicating with the server.
class Api {

  /// Returns all subjects!
  static List<Subject> getAllSubjects() {
    //TODO write this function (for real).
    return [
      Subject(pk: 1, name: 'אזרחות'),
      Subject(pk: 2, name: 'הסטוריה'),
      Subject(pk: 3, name: 'מתמטיקה')
    ];
  }

  /// Returns all the tests for a given user.
  static List<Test> getAllTests(int userPk) {
    //TODO write this function (for real).
    return [
      Test(pk: 1, subject: Data.getSubjectByPk(1), dateCreated: DateTime.utc(2019, 2, 2), dateTaken: DateTime.utc(2019, 2, 27), smallTopicsPks: [1, 2], icon: Icons.person),
      Test(pk: 2, subject: Data.getSubjectByPk(2), dateCreated: DateTime.utc(2019, 2, 2), dateTaken: DateTime.utc(2019, 3, 10), smallTopicsPks: [3, 4], icon: Icons.history),
      Test(pk: 3, subject: Data.getSubjectByPk(3), dateCreated: DateTime.utc(2019, 2, 2), dateTaken: DateTime.utc(2019, 3, 25), smallTopicsPks: [5, 6], icon: Icons.confirmation_number),
    ];
  }

  /// Returns all the small topics of a given test.
  static Map<String, String> getAllSmallTopics(int testPk) {
    // TODO write this function (for real).
    return {
      'החלטת האו"ם 181' : 'הייתה החלטה כזאת, יעני כ"ט בנובמבר...',
      'מגילת העצמאות' : 'אנו מכריזים בזאת!',
      'החלק ההסטורי של מגילת העצמאות' : 'הצדקות להקמת מדינת ישראל',
    };
  }
}


/// This class saves data that's important for the entire app.
class Data {
  static List<Subject> allSubjects;
  static List<Test> allTests;

  /// This function should be called when first opening the app.
  static void startApp({int userPk}) {
    Data.allSubjects = Api.getAllSubjects();
    Data.allTests = Api.getAllTests(userPk);
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