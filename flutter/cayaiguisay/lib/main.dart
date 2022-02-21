// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cayaiguisay/api/getToken.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CayAiguisay',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[500],
          title: const Text('Reddit eco + '),
        ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[600],
                ),
                onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  getToken()));
                },
                child: const Text('Se connecter via Reddit:'),
              ),
              Text('C est quoi ce binze!')
            ]
          ),
        )
      )
      )
    );
  }
  
}
