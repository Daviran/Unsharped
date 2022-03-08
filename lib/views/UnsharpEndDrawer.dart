import 'package:draw_flutt_test/models/redditor.dart';
import 'package:flutter/material.dart';
import './../models/redditor.dart';
import './../models/reddit_interface.dart';
import 'package:get_it/get_it.dart';
import 'image_header.dart';
import '../models/redditor.dart';
import 'package:time_elapsed/time_elapsed.dart';

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

class UnsharpEndDrawer extends StatelessWidget {
  final Redditor user;
  const UnsharpEndDrawer({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTime = CustomTimeElapsed(
      now: "maintenant",
      seconds: "secondes",
      minutes: "minutes",
      hours: "heures",
      days: "jours",
      weeks: "semaines",
    );
    String ancientnessFormat = TimeElapsed.fromDateTime(user.ancientness)
        .toCustomTimeElapsed(customTime);
    return Drawer(
        child: Column(
      children: [
        SizedBox(
            height: 200.0,
            child: DrawerHeader(
                child: Column(children: [
              SizedBox(
                height: 100,
                child:
                    CircularCachedNetworkImage(url: user.pictureUrl, size: 80),
              ),
              Text(user.name, style: const TextStyle(fontSize: 20))
            ]))),
        const DrawerButton(
            icon: Icons.account_circle, route: '/user', title: 'Profil'),
        Row(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(left: 10)),
            const Icon(Icons.token),
            const Padding(padding: EdgeInsets.only(left: 5)),
            Expanded(
              child: Text("Karma: " + user.karma.toString()),
            ),
            const VerticalDivider(),
            const Icon(Icons.card_membership),
            const Padding(padding: EdgeInsets.only(right: 5)),
            Expanded(
              child: Text("Ancienneté: " + ancientnessFormat),
            ),
            const Padding(padding: EdgeInsets.only(right: 10)),
          ],
        ),
        Expanded(child: Container()),
        DrawerButton(
            icon: Icons.logout,
            route: '/settings',
            title: 'Se déconnecter',
            callback: () {
              GetIt.I<RedditInterface>().stopAPIConnection();
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).popAndPushNamed("/login");
            }),
      ],
    ));
  }
}
