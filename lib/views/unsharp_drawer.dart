import 'package:draw_flutt_test/models/subreddit.dart';
import 'package:draw_flutt_test/views/loading_widget.dart';
import 'package:flutter/material.dart';
import './../models/redditor.dart';
import './../models/reddit_interface.dart';
import 'package:get_it/get_it.dart';
import 'image_header.dart';
import '../controllers/subreddit_page.dart';
import './subredditDrawWidget.dart';
import 'package:draw/draw.dart' as draw;

class DrawerButton extends StatelessWidget {
  final IconData icon;

  final String title;

  final String route;

  final void Function()? callback;

  const DrawerButton(
      {Key? key,
      required this.icon,
      required this.title,
      required this.route,
      this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currentRoute = "";

    currentRoute = ModalRoute.of(context)!.settings.name!;
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: callback ??
          () {
            if (currentRoute == route) {
              Navigator.pop(context);
            } else {
              Navigator.pushNamed(context, route);
            }
          },
    );
  }
}

class UnsharpDrawer extends StatelessWidget {
  final Redditor user;
  final List<draw.Subreddit> subreddits;
  const UnsharpDrawer({Key? key, required this.user, required this.subreddits})
      : super(key: key);

  @override
  Widget build(context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          const SizedBox(height: 20),
          ExpansionTile(
            initiallyExpanded: true,
            title: const Text("Vos Subreddits"),
            children: <Widget>[
              ...subreddits.map(
                (e) => TextButton(
                  style: TextButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/subreddit',
                        arguments: SubredditPageArguments(e.displayName));
                  },
                  child: SubredditDrawWidget(subreddit: e),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
