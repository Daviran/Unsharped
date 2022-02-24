import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

// final authorizationEndpoint =
//     Uri.parse('https://www.reddit.com/api/v1/authorize');
// final tokenEndpoint = Uri.parse('https://www.reddit.com/api/v1/access_token');
// final clientId = 'ck2GOET4npgAai16Xwzcog';
// final identifier = 'CayPasSiAiguisay';
// final redirectUrl = Uri.parse('unsharp://reddit-redirect');
// final Iterable<String> scopesReddit = ['identity,  mysubreddits'];

// var responseUrl;
// StreamSubscription? _sub;

// Future<void> listenUri(Uri redirectRedditUri) async {
//   if (!kIsWeb) {
//     _sub = uriLinkStream.listen((Uri? uri) {
//       if (uri.toString().startsWith(redirectRedditUri.toString())) {}
//       responseUrl = uri;
//     });
//   }
// }

// Future<void> redirect(Uri uri) async {
//   if (await canLaunch(uri.toString())) {
//     await launch(uri.toString());
//   }
// }

// Future<oauth2.Client> createClient() async {
//   var grant = oauth2.AuthorizationCodeGrant(
//       clientId, authorizationEndpoint, tokenEndpoint);

//   var authorizationUrl = grant.getAuthorizationUrl(redirectUrl,
//       scopes: scopesReddit, state: 'test2');

//   await redirect(authorizationUrl);
//   await listenUri(redirectUrl);
//   print(responseUrl);

//   return await grant.handleAuthorizationResponse(responseUrl.queryParameters);

// var codeReddit = authorizationUrl.queryParameters['code_challenge'];
// grant.handleAuthorizationCode(codeReddit.toString());
// print(grant.handleAuthorizationCode(codeReddit.toString()));

// print('HEYYYOOO ');
// print(codeReddit);

// var authHeaders = 'ck2GOET4npgAai16Xwzcog:';
// final bytes = utf8.encode(authHeaders);
// final base64AuthHeaders = base64.encode(bytes);

// final bytesCode = utf8.encode(codeReddit.toString());
// final decodedCode = base64.encode(bytesCode);
// print(decodedCode);

// var url = Uri.parse('https://www.reddit.com/api/v1/access_token');
// var response = await http.post(url, body: {
//   'grant_type': 'authorization_code',
//   'code': decodedCode,
//   'redirect_uri': redirectUrl.toString()
// }, headers: {
//   'Authorization': 'Basic ' + base64AuthHeaders
// });
// print('Response status: ${response.statusCode}');
// print('Response body: ${response.body}');
//}

class RedditAuthTry extends StatefulWidget {
  @override
  State<RedditAuthTry> createState() => _RedditAuthTryState();
}

class _RedditAuthTryState extends State<RedditAuthTry> {
  String _status = '';
  String _token = '';

  Future<void> getToken() async {
    final clientId = 'ck2GOET4npgAai16Xwzcog';
    final redirectUrl = 'unsharp://reddit-redirect';
    final tokenEndpoint =
        Uri.parse('https://www.reddit.com/api/v1/access_token');

    final url = Uri.https('reddit.com', '/api/v1/authorize', {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': redirectUrl,
      'state': 'test2',
      'scope': 'identity'
    });

    print(url);

    try {
      final result = await FlutterWebAuth.authenticate(
          url: url.toString(), callbackUrlScheme: redirectUrl);
      print(result);
      // final code = Uri.parse(result).queryParameters['code'];

      // final response = await http.post(tokenEndpoint, body: {
      //   'client_id': clientId,
      //   'redirect_uri': redirectUrl,
      //   'grant_type': 'authorization_code',
      //   'code': code
      // });

      // final accessToken = jsonDecode(response.body)['access_token'] as String;
      // print("BKOP");
      setState(() {
        _status = 'Got result: $result';
        //_token = 'Got AT: $accessToken';
      });
    } on PlatformException catch (e) {
      setState(() {
        _status = 'Got error: $e';
        _token = 'Got error: $e';
      });
    }
    //print(result);
    //print(code);

    //print(response);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Status: $_status\n'),
        Text('Token: $_token\n'),
        ElevatedButton(
          child: Text('Connexion Reddit'),
          onPressed: getToken,
        ),
      ],
    );
  }
}
