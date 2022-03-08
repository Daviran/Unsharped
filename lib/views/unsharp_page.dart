// ignore_for_file: unnecessary_import, must_be_immutable

import 'package:draw_flutt_test/controllers/home_page.dart';
import 'package:draw_flutt_test/controllers/search_page.dart';
import 'package:draw_flutt_test/controllers/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './unsharp_drawer.dart';
import 'package:get_it/get_it.dart';
import './../models/reddit_interface.dart';
import './UnsharpEndDrawer.dart';

class UnsharpPage extends StatefulWidget {
  Widget? body;
  String? title;
  UnsharpPage({
    Key? key,
    this.title,
    this.body,
  }) : super(key: key);

  @override
  State<UnsharpPage> createState() => _UnsharpPageState();
}

class _UnsharpPageState extends State<UnsharpPage> {
  int _selectedIndex = 0;
  List<Widget> bodyList = [
    const HomePageController(),
    const SearchPageController(),
    const SettingsPageController()
  ];
  List<String> titleList = ["Accueil", "Subreddits", "Options"];
  late Widget body;
  late String title;

  @override
  void initState() {
    super.initState();
    setState(() {
      body = bodyList[0];
      title = titleList[0];
    });
  }

  void _onItemTapped(int index) {
    _selectedIndex = index;
    widget.body = null;
    widget.title = null;

    switch (_selectedIndex) {
      case 0:
        body = bodyList[0];
        title = titleList[0];
        break;
      case 1:
        body = bodyList[1];
        title = titleList[1];
        break;
      case 2:
        body = bodyList[2];
        title = titleList[2];
        break;
      default:
        return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:
          UnsharpEndDrawer(user: GetIt.I<RedditInterface>().loggedRedditor),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(129, 50, 168, 1),
        elevation: 0,
        title: widget.title == null
            ? Text(title,
                style: const TextStyle(
                    color: Colors.white, fontSize: 18, fontFamily: "Base02"))
            : Text(widget.title!,
                style: const TextStyle(
                    color: Colors.white, fontSize: 18, fontFamily: "Base02")),
        actions: [
          Builder(
              builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  icon: CircleAvatar(
                    backgroundImage: NetworkImage(
                        GetIt.I<RedditInterface>().loggedRedditor.pictureUrl),
                  )))
        ],
      ),
      drawer: UnsharpDrawer(
          user: GetIt.I<RedditInterface>().loggedRedditor,
          subreddits: GetIt.I<RedditInterface>().loggedRedditor.subSubreddits),
      body: widget.body ?? body,
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 15,
        selectedIconTheme: const IconThemeData(
            color: Color.fromRGBO(129, 50, 168, 1), size: 20),
        selectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Rechercher',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Options',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
