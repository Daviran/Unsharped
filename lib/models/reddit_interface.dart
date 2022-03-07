import 'dart:convert';
import 'dart:typed_data';
import 'package:draw/draw.dart' as draw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import './redditor.dart';
import './subreddit.dart';
import './post.dart';
import './post_holder.dart';
import './../views/posts_list.dart';

class RedditInterface {
  bool connected = false;
  late Redditor loggedRedditor;
  late draw.Reddit reddit;

  Future<Redditor> _fetchLoggedRedditor() async {
    var loggedUser = await reddit.user.me();
    final subredditsStream = reddit.user.subreddits();
    List<String> subredditSubscribed = [];
    Map<String, dynamic> prefs = {};

    await for (var sub in subredditsStream) {
      subredditSubscribed.add(sub.displayName);
    }

    prefs = Map<String, dynamic>.from(await reddit.get('/api/v1/me/prefs',
        params: {"raw_json": "1"}, objectify: false));

    final subSubredditStream = reddit.user.subreddits();
    List<draw.Subreddit> subs = [];
    await for (var sub in subSubredditStream) {
      subs.add(sub);
    }

    loggedRedditor = Redditor.fromDRAW(
        drawInterface: loggedUser as draw.Redditor,
        subscribedSubreddits: subredditSubscribed,
        subSubreddits: subs,
        prefs: prefs);
    return loggedRedditor;
  }

  Future<List<Subreddit>> searchSubreddits(String name) async {
    var searchRes = await reddit.subreddits.searchByName(name);
    List<Subreddit> sublist = [];

    for (var sub in searchRes) {
      var populated = await sub.populate();
      sublist.add(Subreddit.fromDRAW(populated, []));
    }
    return sublist;
  }

  Future<Subreddit> getSubreddit(String name, {bool loadPosts = true}) async {
    draw.SubredditRef subRef = reddit.subreddit(name);
    draw.Subreddit sub = await subRef.populate();
    List<Post> posts = [];

    if (loadPosts) {
      await for (var post in sub.hot(limit: PostsList.pageSize)) {
        posts.add(Post.fromSubmission(post as draw.Submission));
      }
    }
    return Subreddit.fromDRAW(sub, posts);
  }

  // Future<void> restoreAPIConnection() async {
  //   String? clientId = dotenv.env['UNSHARP_API_KEY'];

  //   try {
  //     final file = File('./credentials.json');
  //     final cred = await file.readAsString();
  //     if (cred == "") {
  //       throw Exception("Aucun identifiant...");
  //     }
  //     reddit = draw.Reddit.restoreInstalledAuthenticatedInstance(cred,
  //         clientId: clientId, userAgent: "CayPasSiAiguisay");
  //     await _fetchLoggedRedditor();
  //     connected = true;
  //   } catch (e) {
  //     return;
  //   }
  // }

  // Future<File> getCredentialsFile() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final path = directory.path;
  //   return File('$path/credentials.json');
  // }

  Future<PostHolder> getFrontPage() async {
    List<Post> posts = [];
    await for (var post
        in draw.FrontPage(reddit).hot(limit: PostsList.pageSize)) {
      posts.add(Post.fromSubmission(post as draw.Submission));
    }

    return PostHolder(posts: posts, drawInterface: draw.FrontPage(reddit));
  }

  Future<void> createAPIConnection() async {
    String? clientId = dotenv.env['UNSHARP_API_KEY'];
    //final file = await getCredentialsFile();

    if (clientId == null) {
      throw Exception("La clef UNSHARP n'a pas été trouvée...");
    }
    reddit = draw.Reddit.createInstalledFlowInstance(
        clientId: clientId,
        userAgent: "CayPasSiAiguisay",
        redirectUri: Uri.parse("unsharp://reddit-redirect"));
    final result = await FlutterWebAuth.authenticate(
      url: reddit.auth.url(["*"], "unsharp", compactLogin: true).toString(),
      callbackUrlScheme: "unsharp",
    );

    final code = Uri.parse(result).queryParameters['code'];

    await reddit.auth.authorize(code.toString());
    //await file.writeAsString(reddit.auth.credentials.toJson());
    await _fetchLoggedRedditor();
    connected = true;
  }

  Future<void> stopAPIConnection() async {
    // File credentials = await getCredentialsFile();

    // if (credentials.existsSync()) {
    //   await credentials.delete();
    // }
    connected = false;
  }

  Future get(String api,
      {Map<String, String?>? params,
      bool objectify = true,
      bool followRedirects = false}) {
    return reddit.get(api,
        params: params, objectify: objectify, followRedirects: followRedirects);
  }

  Future post(String api, Map<String, String> body,
      {Map<String, Uint8List?>? files,
      Map? params,
      bool discardResponse = false,
      bool objectify = true}) {
    return reddit.post(api, body,
        files: files,
        params: params,
        discardResponse: discardResponse,
        objectify: objectify);
  }

  Future put(String api, {Map<String, String>? body}) {
    return reddit.put(api, body: body);
  }

  Future patch(String api, Map<String, String> out) {
    return http.patch(Uri.parse("https://oauth.reddit.com$api"),
        body: json.encode(out),
        headers: {
          "Authorization": "Bearer " + reddit.auth.credentials.accessToken,
        });
  }
}
