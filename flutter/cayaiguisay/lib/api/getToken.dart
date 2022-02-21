import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:draw/draw.dart';

const String clientToken = 'pTyE0JbYQtID4lTIRH66kA';
const String localhost = 'http://localhost';

class getToken extends StatefulWidget {
  getToken({Key? key,}) : super(key: key);

  @override
  getTokenState createState() => getTokenState();
}
class getTokenState extends State<getToken> {
  void postCode(code) async {
    final id = base64.encode(utf8.encode(clientToken + ':'));
    final response = await Dio().post(
        'https://www.reddit.com/api/v1/access_token',
        options: Options(headers: <String, dynamic>{
          'authorization': 'Basic $id',
          'content-type': "application/x-www-form-urlencoded"
        }),
        data:
            'grant_type=authorization_code&code=$code&redirect_uri=$localhost');
  }

  Widget build(BuildContext context) {
    return Container(
        child: WebView(
      initialUrl:
          'https://www.reddit.com/api/v1/authorize.compact?client_id=$clientToken&response_type=code&state=test&redirect_uri=$localhost&duration=permanent&scope=identity,edit,flair,history,modconfig,modflair,modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote,wikiedit,wikiread',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        controller = controller;
      },
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith("http://localhost")) {
          var pos = request.url.lastIndexOf('=');
          var code = (pos != -1)
              ? request.url.substring(pos + 1, request.url.length - 2)
              : request.url;
          postCode(code);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ));
  }
}
