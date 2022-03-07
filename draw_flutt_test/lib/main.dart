import 'package:draw_flutt_test/controllers/unsharp_page.dart';

import './controllers/subreddit_page.dart';
import 'package:flutter/material.dart';
import './controllers/redditor_page.dart';
import './controllers/login_page.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './controllers/home_page.dart';
import './models/reddit_interface.dart';
import './controllers/search_page.dart';
import './controllers/post_page.dart';
import './controllers/settings_page.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  RedditInterface interface = RedditInterface();
  GetIt.I.registerSingleton<RedditInterface>(interface);
  runApp(MyApp(connected: interface.connected));
}

class MyApp extends StatelessWidget {
  final bool connected;
  const MyApp({Key? key, required this.connected}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Unsharp',
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Color.fromARGB(255, 0, 0, 0)),
        initialRoute: connected ? "/home" : "/login",
        onGenerateRoute: (settings) {
          Map routes = {
            '/login': () => const LoginPageController(),
            '/user': () => const RedditorPageController(),
            '/home': () =>
                const UnsharpPageController(), //HomePageController(),
            '/search': () => const SearchPageController(),
            '/subreddit': () => const ExtractArgumentsSubredditPage(),
            '/post': () => const ExtractArgumentsPostPage(),
            '/settings': () => const SettingsPageController(),
          };
          if (settings.name == Navigator.defaultRouteName) {
            return null;
          }
          return PageRouteBuilder(
              settings:
                  settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
              pageBuilder: (_, __, ___) => routes[settings.name].call(),
              transitionsBuilder: (context, animation, secondaryAnimation,
                      child) =>
                  SlideTransition(
                    position: animation.drive(
                        Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                            .chain(CurveTween(curve: Curves.ease))),
                    child: child,
                  ));
        });
  }
}
