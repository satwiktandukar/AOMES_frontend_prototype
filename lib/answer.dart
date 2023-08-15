import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  var answer;

  Answer(this.answer);
  @override
  Widget build(BuildContext context) {
    return Text(
      answer,
      style: TextStyle(fontSize: 20, color: Colors.white),
    );
  }
}
