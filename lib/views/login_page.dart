
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import './../models/reddit_interface.dart';

/// View for login screen
class LoginPageView extends StatelessWidget {
  const LoginPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          const Text("UNSHARPED",
              style: TextStyle(
                  color: Color.fromRGBO(129, 50, 168, 1),
                  fontSize: 50,
                  fontFamily: "Base02")),
          //const Image(image: AssetImage('assets/title.png'), height: 350),
          const Image(
              image: AssetImage('assets/icon.png'), width: 400, height: 400),
          Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await GetIt.I<RedditInterface>().createAPIConnection();
                    Navigator.pushNamed(context, '/home');
                  } catch (e) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Une erreur est survenue'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: const <Widget>[
                                  Text(
                                      'Unsharp n\'a pas pu se connecter à Reddit.'),
                                  Text('Vérifiez votre connexion internet'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Réessayer'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  }
                },
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    primary: Colors.grey,
                    maximumSize: const Size(150, 40)),
                child: Row(
                    children: const [Icon(Icons.login), Text(' Se connecter')]),
              )),
        ]));
  }
}
