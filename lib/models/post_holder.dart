// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:draw/draw.dart' as draw;
import 'post.dart';
import 'package:flutter/material.dart';
import './../views/posts_list.dart';

enum PostSort { hot, top, newest, rising, random }

enum PostTopSort { hour, day, week, month, year, all }

class PostHolder {
  PostSort sortingMethod = PostSort.hot;
  PostTopSort? topSortingMethod;
  var drawInterface;
  List<Post> posts;

  PostHolder({Key? key, required this.posts, required this.drawInterface});

  Future<void> refreshPosts() async {
    var refreshedPosts = fetch(limit: posts.length);

    posts = [
      await for (var post in refreshedPosts)
        Post.fromSubmission(post as draw.Submission)
    ];
  }

  Future<void> fetchMorePosts() async {
    String? lastPage = posts.isNotEmpty ? posts.last.fullName : null;
    var fetchedPosts = fetch(after: lastPage);

    posts.addAll([
      await for (var post in fetchedPosts)
        Post.fromSubmission(post as draw.Submission)
    ]);
  }

  Stream fetch({int limit = PostsList.pageSize, String? after}) {
    switch (sortingMethod) {
      case PostSort.hot:
        return drawInterface.hot(limit: limit, after: after);
      case PostSort.top:
        switch (topSortingMethod) {
          case PostTopSort.hour:
            return drawInterface.top(
                limit: limit, after: after, timeFilter: draw.TimeFilter.hour);
          case PostTopSort.day:
            return drawInterface.top(
                limit: limit, after: after, timeFilter: draw.TimeFilter.day);
          case PostTopSort.week:
            return drawInterface.top(
                limit: limit, after: after, timeFilter: draw.TimeFilter.week);
          case PostTopSort.month:
            return drawInterface.top(
                limit: limit, after: after, timeFilter: draw.TimeFilter.month);
          case PostTopSort.year:
            return drawInterface.top(
                limit: limit, after: after, timeFilter: draw.TimeFilter.year);
          case PostTopSort.all:
            return drawInterface.top(
                limit: limit, after: after, timeFilter: draw.TimeFilter.all);
          case null:
            return drawInterface.top(
                limit: limit, after: after, timeFilter: draw.TimeFilter.all);
        }
      case PostSort.newest:
        return drawInterface.newest(limit: limit, after: after);
      case PostSort.random:
        return drawInterface.randomRising(limit: limit, after: after);
      case PostSort.rising:
        return drawInterface.rising(limit: limit, after: after);
    }
  }
}
