import '../controllers/subreddit_page.dart';
import '../models/subreddit.dart';
import 'loading_widget.dart';
import 'package:flutter/material.dart';
import './unsharp_page.dart';
import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart';
import 'package:get_it/get_it.dart';
import '../models/reddit_interface.dart';
import 'subreddit_widget.dart';

class SearchPageView extends StatelessWidget {
  const SearchPageView({Key? key}) : super(key: key);

  Future<List<Subreddit>> _searchSubreddits(String? name) {
    return GetIt.I<RedditInterface>()
        .searchSubreddits(name != null ? name.trim() : "");
  }

  @override
  Widget build(BuildContext context) {
    // return UnsharpPage(
    //   title: "Subreddits...",
    //   body:
    return SafeArea(
      child: SearchBar<Subreddit>(
        searchBarPadding: const EdgeInsets.symmetric(horizontal: 20),
        onSearch: _searchSubreddits,
        textStyle: const TextStyle(),
        onError: (Error? error) {
          return Row(
              children: const [
                Text("Une erreur est survenue...",
                    style: TextStyle(fontSize: 20), textAlign: TextAlign.center)
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center);
        },
        cancellationWidget: const Text("Annuler"),
        loader: const LoadingWidget(),
        emptyWidget: Row(
            children: const [
              Text("Aucun Subreddit correspondant...",
                  style: TextStyle(fontSize: 20), textAlign: TextAlign.center)
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center),
        onCancelled: () {},
        onItemFound: (Subreddit? subreddit, int index) {
          if (subreddit == null) {
            return Container();
          }
          Subreddit sub = subreddit;
          return TextButton(
            style: TextButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/subreddit',
                  arguments: SubredditPageArguments(sub.displayName));
            },
            child: SubredditWidget(subreddit: sub),
          );
        },
      ),
      //),
    );
  }
}
