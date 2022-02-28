import 'package:flutter/material.dart';
import 'package:draw/draw.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  var loggedIn = null;
  var redditUser = null;
  var pseudo = null;
  List subredditList = [];
  var profilPic = null;

  void logout() {
    setState(() {
      loggedIn = null;
    });
  }

  Future<Redditor> authenticate() async {
    final userAgent = 'CayPasSiAiguisay';

    // Create a `Reddit` instance using a configuration file in the
    // current directory.
    final reddit = Reddit.createInstalledFlowInstance(
        clientId: 'ck2GOET4npgAai16Xwzcog',
        userAgent: userAgent,
        redirectUri: Uri.parse('unsharp://reddit-redirect'),
        tokenEndpoint: Uri.parse('https://www.reddit.com/api/v1/access_token'),
        authEndpoint: Uri.parse('https://www.reddit.com/api/v1/authorize'));

    // Build the URL used for authentication. See `WebAuthenticator`
    // documentation for parameters.
    final auth_url = reddit.auth.url(['*'], 'foobar');
    print(auth_url);
    final result = await FlutterWebAuth.authenticate(
        url: auth_url.toString(), callbackUrlScheme: 'unsharp');
    print(result);
    String? auth_code = Uri.parse(result).queryParameters['code'];
    print(auth_code);

    // ...
    // Complete authentication at `auth_url` in the browser and retrieve
    // the `code` query parameter from the redirect URL.
    // ...

    // Assuming the `code` query parameter is stored in a variable
    // `auth_code`, we pass it to the `authorize` method in the
    // `WebAuthenticator`.
    await reddit.auth.authorize(auth_code.toString());

    // If everything worked correctly, we should be able to retrieve
    // information about the authenticated account.
    print(await reddit.user.me());
    List friendsUsers = await reddit.user.friends();

    Stream<Subreddit> subreddit = reddit.user.subreddits();
    subredditList = await subreddit.toList();
    var userRedditor = await reddit.user.me();
    setState(() {
      redditUser = reddit.user;
      loggedIn = userRedditor;
      pseudo = userRedditor?.displayName;
      subredditList = subredditList;
    });

    return (userRedditor as Redditor);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Redditech oauth2')),
        body: Center(
          child: loggedIn == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      child: Text('Authenticate'),
                      onPressed: () {
                        authenticate();
                      },
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Subreddits'),
                    Text('Hello ' + pseudo),
                    //Image(image: loggedIn?.icon_img),
                    ElevatedButton(
                      child: Text('logout'),
                      onPressed: () {
                        logout();
                      },
                    ),
                    ...subredditList
                        .map((el) => ListView(
                              children: <Widget>[
                                Text(el.title),
                              ],
                            ))
                        .toList()
                  ],
                ),
        ),
      ),
    );
  }
}
