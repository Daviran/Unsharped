import 'loading_widget.dart';
import 'package:flutter/material.dart';
import './../models/post.dart';
import 'post_widget.dart';
import './unsharp_page.dart';
import './../models/comment.dart';
import './comment_widget.dart';

class PostPageView extends StatefulWidget {
  final Post? post;

  const PostPageView({Key? key, required this.post}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PostPageViewState();
}

class _PostPageViewState extends State<PostPageView> {
  @override
  Widget build(BuildContext context) {
    if (widget.post == null) {
      return const UnsharpPage(title: "", body: LoadingWidget());
    }
    Post post = widget.post as Post;
    return UnsharpPage(
        title: post.title,
        body: ListView(
            children: <Widget>[
                  PostWidget(post: post, preview: false, displaySubName: true)
                ] +
                [
                  for (Comment comment in post.comments)
                    CommentWidget(comment: comment)
                ]));
  }
}
