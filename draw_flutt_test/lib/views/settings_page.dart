import 'package:flutter/material.dart';
import '../models/redditor.dart';
import './unsharp_page.dart';

class SettingsPageView extends StatefulWidget {
  Redditor user;

  final Map<String, String> settings;

  SettingsPageView({Key? key, required this.user, required this.settings})
      : super(key: key);

  @override
  State<SettingsPageView> createState() => _SettingsPageViewState();
}

class _SettingsPageViewState extends State<SettingsPageView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> settingsFields = [];
    Widget saveButton = Column(children: [
      ElevatedButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Sauvegarder les changements.'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: const <Widget>[
                      Text(
                          'Une fois vos options enregistrées, vous serez redirigé vers la page d\'accueil.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Enregistré !'),
                    onPressed: () {
                      widget.user.pushPrefs(widget.settings.keys.toList());
                      Navigator.popUntil(context, ModalRoute.withName('/home'));
                    },
                  ),
                ],
              );
            }),
        child: const Text("Sauvegarder"),
        style: ElevatedButton.styleFrom(
            primary: Theme.of(context).backgroundColor),
      ),
    ]);

    for (var key in widget.settings.keys) {
      settingsFields.add(Container(
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            Expanded(child: Text(widget.settings[key]!)),
            Switch(
                value: widget.user.prefs[key],
                onChanged: (bool value) => setState(() {
                      widget.user.prefs[key] = value;
                    })),
          ])));
    }

    // return UnsharpPage(
    //     title: "Options",
    //     body:
    return Column(children: settingsFields + [saveButton]); //);
  }
}
