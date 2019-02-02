import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

/// A [Test] that holds the data for a test
class Test {
  int pk;
  Subject subject;
  DateTime dateCreated;
  DateTime dateTaken;
  List<int> smallTopicsPks; // List of small topics pks.
  IconData icon;

  Test({
    @required this.pk,
    @required this.subject,
    @required this.dateCreated,
    @required this.dateTaken,
    @required this.smallTopicsPks,
    @required this.icon
  }):   assert(pk != null),
        assert(subject != null),
        assert(dateCreated != null),
        assert(dateTaken != null),
        assert(smallTopicsPks != null);
}

/// A [Subject] class that holds data for a specific subject.
class Subject {
  int pk;
  String name;

  Subject({
    @required this.pk,
    @required this.name,
  })  : assert(pk != null),
        assert(name != null);
}

/// Holds data for a specific question.
class Question {
  String question;
  String rightAnswer;
  String wrong1;
  String wrong2;
  String wrong3;

  Question({
    @required this.question,
    @required this.rightAnswer,
    @required this.wrong1,
    @required this.wrong2,
    @required this.wrong3
  }) :  assert(question != null),
        assert(rightAnswer != null),
        assert(wrong1 != null),
        assert(wrong2 != null),
        assert(wrong3 != null);
}
