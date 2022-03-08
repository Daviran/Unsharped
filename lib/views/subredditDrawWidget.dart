import 'package:flutter/material.dart';
import './../models/subreddit.dart';
import 'package:intl/intl.dart';
import 'package:draw/draw.dart' as draw;

class SubredditDrawWidget extends StatelessWidget {
  final draw.Subreddit subreddit;

  const SubredditDrawWidget({Key? key, required this.subreddit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
            padding: const EdgeInsets.all(8),
            child: CircleAvatar(
              radius: 10,
              foregroundImage: subreddit.iconImage.toString() != ""
                  ? Image.network(
                      subreddit.iconImage.toString(),
                      errorBuilder: (_, __, ___) => Container(),
                    ).image
                  : null,
              child: Text(subreddit.displayName[0]),
            )),
        Expanded(child: Text(subreddit.displayName)),
      ],
    );
  }
}
