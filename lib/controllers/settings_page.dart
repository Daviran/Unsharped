import 'package:flutter/material.dart';
import './../views/settings_page.dart';
import 'package:get_it/get_it.dart';
import './../models/reddit_interface.dart';

class SettingsPageController extends StatelessWidget {
  const SettingsPageController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, String> settings = {
      'email_post_reply':
          "Recevoir un email quand votre post reçoit une réponse.",
      'email_username_mention':
          "Recevoir un email lorsqu'un redditor vous mentionne.",
      'email_comment_reply':
          "Recevoir un email quand votre commentaire reçoit une réponse.",
      'over_18': "Autoriser les contenus interdits aux mineurs",
      'video_autoplay': "Lecture automatique des vidéos",
      'search_include_over_18':
          "Afficher les subreddits interdits aux moins de 18 ans dans les recherches.",
      'nightmode': "Mode nuit."
    };
    return SettingsPageView(
        user: GetIt.I<RedditInterface>().loggedRedditor, settings: settings);
  }
}
