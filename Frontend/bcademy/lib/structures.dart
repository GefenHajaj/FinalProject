/// This file defines the [Test] class and [Subject] class used throughout the
/// app.
///
/// Developer: Gefen Hajaj
import 'package:flutter/material.dart';

/// A [Test] that holds the data for a test
class Test {
  int pk;
  Subject subject;
  DateTime dateCreated;
  DateTime dateTaken;
  List<int> smallTopicsPks; // List of small topics pks.
  IconData icon;
  int millisecondsStudy;

  Test({
    @required this.pk,
    @required this.subject,
    @required this.dateCreated,
    @required this.dateTaken,
    @required this.smallTopicsPks,
    @required this.icon,
    @required this.millisecondsStudy
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
