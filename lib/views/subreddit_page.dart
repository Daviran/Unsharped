import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/subreddit.dart';
import './unsharp_page.dart';
import 'loading_widget.dart';
import 'image_header.dart';
import 'posts_list.dart';
import 'package:share/share.dart';

class SubredditPageView extends StatefulWidget {
  final Subreddit? subreddit;
  const SubredditPageView({Key? key, required this.subreddit})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubredditPageViewState();
}

class _SubredditPageViewState extends State<SubredditPageView> {
  @override
  Widget build(BuildContext context) {
    if (widget.subreddit == null) {
      return const LoadingWidget();
    }

    Subreddit sub = widget.subreddit as Subreddit;
    return UnsharpPage(
        title: sub.displayName,
        body: ListView(children: [
          ImageHeader(
              bannerUrl: sub.bannerUrl,
              pictureUrl: sub.pictureUrl,
              title: 'r/' + sub.displayName),
          Row(children: [
            Container(
                padding: const EdgeInsets.only(left: 20),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (sub.subscribed == true) {
                        sub.unsubscribe();
                      } else {
                        sub.subscribe();
                      }
                      sub.subscribed = !sub.subscribed;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      onPrimary: sub.subscribed == false
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      primary: sub.subscribed == false
                          ? Colors.grey
                          : Theme.of(context).scaffoldBackgroundColor,
                      side: sub.subscribed
                          ? const BorderSide(width: 2.0, color: Colors.grey)
                          : null),
                  child: Row(children: [
                    sub.subscribed
                        ? const Text('Rejoint')
                        : const Text('Rejoindre')
                  ]),
                )),
            Expanded(
                flex: 2,
                child: Text(
                    NumberFormat.compact().format(sub.membersCount).toString() +
                        " membres",
                    textAlign: TextAlign.center)),
            Expanded(
                child: IconButton(
              onPressed: () => Share.share(sub.link),
              icon: const Icon(Icons.share),
            )),
          ]),
          Container(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 20, left: 15, right: 15),
              child: Wrap(
                children: [Text(sub.description)],
              )),
          const Divider(),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.80,
              child: PostsList(
                holder: sub,
                displaySubredditName: false,
              ))
        ]));
  }
}
