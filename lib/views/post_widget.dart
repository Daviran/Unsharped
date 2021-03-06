import './../controllers/post_page.dart';
import './../controllers/subreddit_page.dart';
import './../views/widgets/postContent/post_content.dart';
import 'package:flutter/material.dart';
import './../models/post.dart';
import 'package:time_elapsed/time_elapsed.dart';
import 'package:share/share.dart';
import 'vote_widget.dart';
import 'widgets/postContent/post_content.dart';

class PostWidget extends StatelessWidget {
  const PostWidget(
      {Key? key,
      required this.post,
      required this.displaySubName,
      required this.preview})
      : super(key: key);
  final Post post;
  final bool displaySubName;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    Widget title = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            post.title,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        displaySubName
            ? Expanded(
                flex: 1,
                child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                    child: Text("r/" + post.parent,
                        style: const TextStyle(fontSize: 15),
                        textAlign: TextAlign.end),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/subreddit',
                          arguments: SubredditPageArguments(post.parent));
                    }))
            : Container()
      ],
    );

    Widget otherContent =
        Row(children: [PostContentWidget(post: post, preview: preview)]);
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextButton(
                child: title,
                style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  if (preview) {
                    Navigator.of(context)
                        .pushNamed('/post', arguments: PostPageArguments(post));
                  }
                }),
            Container(padding: const EdgeInsets.all(5)),
            otherContent,
            Container(
              padding: const EdgeInsets.all(10),
            ),
            Row(
              children: [
                const Icon(Icons.access_time_outlined),
                Container(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(TimeElapsed.fromDateTime(post.createdTime),
                        style: const TextStyle(fontSize: 15))),
                Expanded(
                    child: Text("u/" + post.authorName,
                        style: const TextStyle(fontSize: 15),
                        textAlign: TextAlign.end))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(flex: 3, child: VoteWidget(post: post)),
                preview
                    ? Expanded(
                        child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/post',
                              arguments: PostPageArguments(post));
                        },
                        icon: const Icon(Icons.mode_comment),
                      ))
                    : Container(),
                Expanded(
                    child: IconButton(
                  onPressed: () {
                    Share.share(post.link);
                  },
                  icon: const Icon(Icons.share),
                )),
              ],
            ),
            const Divider(),
          ],
        ));
  }
}
