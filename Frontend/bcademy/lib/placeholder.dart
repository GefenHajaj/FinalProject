import 'package:flutter/material.dart';

/// A placeholder - not used
Widget placeHolder(String title) {
  const _padding = EdgeInsets.all(16.0);

  return SingleChildScrollView(
    child: Container(
      constraints: BoxConstraints.expand(height: 400, width: 800),
      margin: _padding,
      padding: _padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.blue,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.build,
              size: 180.0,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "$title\nUnder Construction!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}