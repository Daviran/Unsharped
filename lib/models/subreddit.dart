import 'package:html_unescape/html_unescape.dart';
import './post_holder.dart';
import './post.dart';
import 'package:get_it/get_it.dart';
import './reddit_interface.dart';

class Subreddit extends PostHolder {
  final String displayName;
  int membersCount = 0;
  String description = "";
  final String link;
  String bannerUrl = "";
  final String pictureUrl;
  bool subscribed;

  Subreddit.fromDRAW(var drawInterface, List<Post> posts)
      : displayName = drawInterface.displayName,
        pictureUrl = drawInterface.iconImage.toString(),
        link = 'https://www.reddit.com/r/' + drawInterface.displayName,
        subscribed = GetIt.I<RedditInterface>()
            .loggedRedditor
            .subscribedSubreddits
            .contains(drawInterface.displayName),
        super(posts: posts, drawInterface: drawInterface) {
    var unescape = HtmlUnescape();
    if (drawInterface.data == null) {
      return;
    }
    membersCount = drawInterface.data!['subscribers'];
    description =
        unescape.convert(drawInterface.data!['public_description'].toString());
    if (drawInterface.data!['mobile_banner_image'].toString() != "") {
      bannerUrl = unescape
          .convert(drawInterface.data!['mobile_banner_image'].toString());
    } else {
      bannerUrl = unescape
          .convert(drawInterface.data!['banner_background_image'].toString());
    }
    description = HtmlUnescape().convert(description);
  }

  Future<void> subscribe() async {
    await drawInterface.subscribe();
    GetIt.I<RedditInterface>()
        .loggedRedditor
        .subscribedSubreddits
        .add(displayName);
  }

  Future<void> unsubscribe() async {
    await drawInterface.unsubscribe();
    GetIt.I<RedditInterface>()
        .loggedRedditor
        .subscribedSubreddits
        .remove(displayName);
  }
}
