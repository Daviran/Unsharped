import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:get_it/get_it.dart';
import 'package:draw/draw.dart' as draw;
import './reddit_interface.dart';
import './subreddit.dart';
import './post.dart';
import './comment.dart';

class Redditor {
  final String bannerUrl;
  final String pictureUrl;
  final String displayName;
  final String name;

  String description;

  final int karma;
  final DateTime ancientness;
  final List<String> subscribedSubreddits;
  Map<String, dynamic> prefs;

  draw.Redditor drawInterface;

  Redditor.fromDRAW(
      {Key? key,
      required this.drawInterface,
      required this.subscribedSubreddits,
      required this.prefs})
      : description = HtmlUnescape()
            .convert(drawInterface.data!["subreddit"]["public_description"]),
        bannerUrl = HtmlUnescape()
            .convert(drawInterface.data!["subreddit"]["banner_img"]),
        pictureUrl = HtmlUnescape()
            .convert(drawInterface.data!["subreddit"]["icon_img"]),
        displayName = drawInterface.displayName,
        name = "u/" + drawInterface.fullname!,
        ancientness = drawInterface.createdUtc!,
        karma = drawInterface.awardeeKarma! +
            drawInterface.awarderKarma! +
            drawInterface.commentKarma!;

  Future<List<Subreddit>> getSubscribedSubreddits(
      {required bool loadPosts}) async {
    List<Subreddit> subs = [];
    for (var name in subscribedSubreddits) {
      subs.add(await GetIt.I<RedditInterface>()
          .getSubreddit(name, loadPosts: loadPosts));
    }
    return subs;
  }

  /// Get the posts from the user
  Future<List<Post>> getPosts() async {
    List<Post> posts = [];

    await for (var submission in drawInterface.submissions.hot()) {
      posts.add(Post.fromSubmission(submission as draw.Submission));
    }
    return posts;
  }

  /// Get the comments from the user
  Future<List<Comment>> getComments() async {
    List<Comment> comments = [];

    await for (var comment in drawInterface.comments.hot()) {
      comments.add(Comment.fromDraw(comment as draw.Comment));
    }
    return comments;
  }

  Future<void> pushPrefs(List<String> prefNames) async {
    Map<String, String> out = {};
    prefs.forEach((key, value) {
      if (prefNames.contains(key)) {
        out[key] = value.toString();
      }
    });
    return GetIt.I<RedditInterface>().patch('/api/v1/me/prefs', out);
  }

  bool autoPlayVideo() => prefs['video_autoplay'];
}
