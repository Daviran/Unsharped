import 'package:flutter/material.dart';
import 'dart:io';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:http/http.dart' as http;
import 'dart:convert';

class RedditAuthTry extends StatelessWidget {
  final authorizationEndpoint =
      Uri.parse('https://www.reddit.com/api/v1/authorize');
  final tokenEndpoint = Uri.parse('https://www.reddit.com/api/v1/access_token');
  final clientId = 'ck2GOET4npgAai16Xwzcog';
  final identifier = 'ck2GOET4npgAai16Xwzcog';
  final redirectUrl = Uri.parse('unsharp://redirect');
  final Iterable<String> scopesReddit = ['identity,  mysubreddits'];

  void createClient() async {
    var grant = oauth2.AuthorizationCodeGrant(
        identifier, authorizationEndpoint, tokenEndpoint);

    print(grant);

    var authorizationUrl = grant.getAuthorizationUrl(redirectUrl,
        scopes: scopesReddit, state: 'test2');

    var codeReddit = authorizationUrl.queryParameters['code_challenge'];

    print('HEYYYOOO ');
    print(codeReddit);

    var authHeaders = 'ck2GOET4npgAai16Xwzcog:';
    final bytes = utf8.encode(authHeaders);
    final base64AuthHeaders = base64.encode(bytes);

    final bytesCode = utf8.encode(codeReddit.toString());
    final decodedCode = base64.encode(bytesCode);
    print(decodedCode);

    var url = Uri.parse('https://www.reddit.com/api/v1/access_token');
    var response = await http.post(url, body: {
      'grant_type': 'authorization_code',
      'code': decodedCode,
      'redirect_uri': redirectUrl.toString()
    }, headers: {
      'Authorization': 'Basic ' + base64AuthHeaders
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          child: Text('Connexion Reddit'),
          onPressed: createClient,
        ),
        Text('response')
      ],
    );
  }
}
