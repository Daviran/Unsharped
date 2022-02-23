import 'package:flutter/material.dart';
// import './question.dart';
// import './answer.dart';
import './reddit.dart';
import './newReddit.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;

  void _answerQuestion() {
    setState(() {
      _questionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var questions = [
      'Quelle est votre couleur préférée ?',
      'Quel est votre animal préféré ?'
    ];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Redditech'),
        ),
        body: Column(
          children: <Widget>[
            // Question(questions[_questionIndex]),
            // Answer(_answerQuestion),
            // Answer(_answerQuestion),
            // Answer(_answerQuestion),
            RedditAuthTry(),
          ],
        ),
      ),
    );
  }
}
