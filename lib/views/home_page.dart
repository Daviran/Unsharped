// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import './unsharp_page.dart';
import './posts_list.dart';
import './../models/subreddit.dart';
import './../models/post_holder.dart';

class HomePageView extends StatelessWidget {
  const HomePageView(
      {Key? key,
      required this.frontPageFetcher,
      required this.subscribedSubredditsFetcher})
      : super(key: key);

  final Future<PostHolder> Function() frontPageFetcher;

  final Map<String, Future<Subreddit> Function()> subscribedSubredditsFetcher;

  @override
  Widget build(BuildContext context) {
    // return UnsharpPage(
    //   title: "Accueil",
    //   body:
    return PostsList(
      holderFetcher: frontPageFetcher,
      displaySubredditName: true,
      // ),
    );
  }
}
