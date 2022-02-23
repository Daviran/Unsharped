import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RedditAuth extends StatefulWidget {
  const RedditAuth({Key? key}) : super(key: key);

  @override
  State<RedditAuth> createState() => _RedditAuthState();
}

class _RedditAuthState extends State<RedditAuth> {
  String response = ' ';

  void codeGrantAuth() {
    setState(() async {
      try {
        var response = await Dio().get(
            'https://www.reddit.com/api/v1/authorize?client_id=ck2GOET4npgAai16Xwzcog&response_type=code&state=test&redirect_uri=unsharp://reddit-redirect&duration=permanent&scope=identity');
        print(response);
      } catch (e) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          child: Text('Connexion Reddit'),
          onPressed: codeGrantAuth,
        ),
        Text(response)
      ],
    );
  }
}
