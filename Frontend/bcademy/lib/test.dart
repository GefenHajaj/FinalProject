import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

/// A [Test] that holds the data for a test
/// TODO: add additioal fields
class Test {
  String subject;
  DateTime dateCreated;
  DateTime dateTaken;
  String link; // Link to a summerize in drive
  IconData iconData;

  Test({
    @required this.subject,
    @required this.dateCreated,
    @required this.dateTaken,
    @required this.link,
    @required this.iconData
  }): assert(subject != null),
      assert(dateCreated != null),
      assert(dateTaken != null),
      assert(link != null),
      assert(iconData != null);
}